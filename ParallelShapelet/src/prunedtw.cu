// Copyright 2018 The Matrix Authors
// This file is part of the Matrix library.
//
// The Matrix library is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// The Matrix library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with the Matrix library. If not, see <http://www.gnu.org/licenses/>.
#include <stdio.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "pub.h"
#include "prunedtw.h"

#include <thrust/sort.h>
#include <thrust/execution_policy.h>
#include <thrust/tuple.h>
#include <thrust/fill.h>
//#define INFINITY 1.79769e+308
#define abs(x) (x>0)?x:-x

#define square(x) ((x)*(x))

#define BankConflictStride 17
//#define Coalescedfor128B 128/sizeof(float)
const int Coalescedfor128B = 128/sizeof(float);

typedef thrust::tuple<float,float,int> T3ddi;


/********************************************
Prune implemented dtw on cpu,but length
*********************************************/
//参数部分可以放在constant device中
__device__ bool isvalid(int x,int y, int w, int M){
    return (y>=max(1,x-w) && (y<=min(M,x+w))&& (x>=1) && (x<=M));
}
/***********************************************
when transformation between no diag element and diag element;
***********************************************/
#define Reverse  if(turn == 0){                 \
                        x0 += 1;                \
                        turn = 1;               \
                    }                           \
                    else{                       \
                        y0 += 1;                \
                        turn = 0;               \
                    }                           \
                    firstline = secondline;     \
                    secondline = thirdline;     \
                    thirdline = firstline;
/*************************************************
when w < threadhold and N < threadhold;
*************************************************/
__global__ void kernel_Computedtwsperblock(float* data, float* shapelet, int w, int N, int L, int lo, int hi, float* gpu_cmpMinDist, int idxst, int* gpu_arrindex){
    //这个函数的参数要好好设计一下
    extern __shared__ float cache[];

    int grpidx = blockIdx.x + idxst;
    int grpstx = blockIdx.y;

    int idx = threadIdx.x;
    int tid = threadIdx.y;
    
    //coalesceforN 由blockDim.x传递
    int coalesceforN = ((N-1)/Coalescedfor128B+1)*Coalescedfor128B;
    //griddim.y = L-lo +1
    //float* glb2local = gpu_cmpMinDist + ((grpidx-idxst) * gridDim.y + grpstx) * (hi-lo) * coalesceforN;
    int* cache_arrindex = (int*)(cache + 2*N*(w+2));
    int step1 = blockDim.x * blockDim.y;

    for(int i = threadIdx.y * blockDim.x + threadIdx.x; i < L; i+= step1){
        cache_arrindex[i] = gpu_arrindex[i];
    }
    
    __syncthreads();
    //float* glb2local = gpu_cmpMinDist + ((grpidx-idxst) * cache_arrindex[L-lo+1] + cache_arrindex[grpstx]) * coalesceforN;
    float* glb2local = gpu_cmpMinDist + index_ComposeNoloss(grpidx-idxst, cache_arrindex, L-lo+1, grpstx, 0) * coalesceforN;
    int end = (cache_arrindex[grpstx+1] - cache_arrindex[grpstx]) * coalesceforN;
    for(int i = threadIdx.y * blockDim.x + threadIdx.x; i < end; i+= step1){
        glb2local[i] = INFINITY;
    }    
    __syncthreads();
    
    
    if(idx < N && grpstx < (L-lo+1)){


        int wide = w + 1;
        int size = (w + 2)*2;
        int center = wide/2;

        float* sdata = cache + idx * size;

        float* tmpshapelet = shapelet + grpidx * L + grpstx;
        
        //public
        //虽然 griddim.y = L - lo + 1,但是gridDim.y对应grpstx,不应该在这里使用.
        for(int st = 0; st < L - lo + 1; st++){

            //data[idx][st:(st+len)]            
            float* tmp_data = data + (idx*L) + st;
            {
                for(int i = tid;i < size;i+= blockDim.y)
                    sdata[i] = INFINITY;
                if(tid == 0)
                    sdata[center] = 0.0;
            }
            __syncthreads();

            
            int x0,y0,x,y,turn;
            x0 = 1 - (w >> 1); y0 = 1 + (w >> 1);
            turn = w&(0x01);

            float* firstline = sdata;
            float* secondline = sdata + wide + 1;
            float* thirdline = firstline;
            
            //modify @1.22 add L-st+1,modify @ 1.17;
            //DTW截至长度.
            int longest = min(hi, min(L-grpstx+1, L-st+1));
            for(int step = 1; step < longest; step++){
                
                __syncthreads();
                for(int i = tid;i < wide; i+= blockDim.y){
                    x = x0 + i;
                    y = y0 - i;
                    
                    if(isvalid(x,y,w,longest)){
                        // modify @ 1.22
                        thirdline[i+turn] = square(tmp_data[x-1]-tmpshapelet[y-1]) + min(firstline[i+turn],min(secondline[i],secondline[i+1]));
                    }
                }

                //modify @ 1.22 avoid the 1-31 threads arrive early.
                __syncthreads();
                
                //这里限制了带宽,使带宽降低了16倍
                //Bandrate 85GB/s
                if((tid==0)&&(step>=lo)){
                    int tmp_index = (step-lo) * coalesceforN + idx;
                    glb2local[tmp_index] = min(sdata[center], glb2local[tmp_index]);
                    if(grpidx == 22 && grpstx == 1 && step == 42 && st == L - lo){
                        printf("gpu:%f\n",glb2local[tmp_index]);
                    }
                }
                // avoid the last threads arrive early. @1.22
                __syncthreads();
                Reverse;

                __syncthreads();
                for(int i = tid;i < wide; i+= blockDim.y){
                    x = x0 + i;
                    y = y0 - i;
                    if(isvalid(x,y,w,longest)){
                        thirdline[i+turn] = square(tmp_data[x-1]-tmpshapelet[y-1]) + min(firstline[i+turn],min(secondline[i],secondline[i+1]));
                    }
               
                }
                __syncthreads();
                Reverse;
            }
            
        }

    }
}

/***********************************************
  for big data. 
***********************************************/
__global__ void kernel_ComputedtwsperblockforlargerW(float* data, float* shapelet, int w, int N, int L, int lo, int hi, float* gpu_cmpMinDist, int idxst, int* gpu_arrindex){
    //这个函数的参数要好好设计一下
    extern __shared__ float cache[];

    int grpidx = blockIdx.x + idxst;
    int grpstx = blockIdx.y;

    int idx = threadIdx.x;
    int tid = threadIdx.y;
    int* cache_arrindex = (int*)(cache + 2*(w+2)*blockDim.x);
    int coalesceforN = ((N - 1)/Coalescedfor128B + 1) * Coalescedfor128B;
    int step1 = blockDim.x * blockDim.y;
    for(int i = threadIdx.y * blockDim.x + threadIdx.x; i < L; i+= step1){
        cache_arrindex[i] = gpu_arrindex[i];        
    }
    __syncthreads();
    //float* glb2local = gpu_cmpMinDist + (grpidx * (L - lo +  1) + grpstx) * (hi-lo) * coalesceforN;
    //float* glb2local = gpu_cmpMinDist + ((grpidx - idxst) * gridDim.y + grpstx) * (hi-lo) * coalesceforN;
    //float* glb2local = gpu_cmpMinDist + ((grpidx - idxst) * cache_arrindex[L-lo+1] + cache_arrindex[grpstx])  * coalesceforN;
    float* glb2local = gpu_cmpMinDist + index_ComposeNoloss(grpidx-idxst, cache_arrindex, L-lo+1, grpstx, 0) * coalesceforN;
    //int end = (hi - lo) * coalesceforN;
    int end = (cache_arrindex[grpstx+1] - cache_arrindex[grpstx]) * coalesceforN;
    for(int i = threadIdx.y * blockDim.x + threadIdx.x; i < end; i+= step1){
        glb2local[i] = INFINITY;
    }    
    __syncthreads();
    
    int wide = w + 1;
    int size = (w + 2)*2;
    int center = wide/2;

    float* sdata = cache + idx * size;
//  float* transfer = cache + N*2*(w+2);
//  add @ 1.17,update @ 1.20
   
    //modify for big data @1.25 remove idx < N
    //其实可以同一个代码?对吧? 
    if(grpstx < (L-lo+1)){

        float* tmpshapelet = shapelet + grpidx * L + grpstx;
        
        for(; idx < N; idx += blockDim.x){
        //public
            for(int st = 0; st < L - lo + 1; st++){
                
                float* tmp_data = data + (idx*L) + st;
                {
                    for(int i = tid;i < size;i+= blockDim.y)
                        sdata[i] = INFINITY;
                    if(tid == 0)
                        sdata[center] = 0.0;
                }

                __syncthreads();
                
                int x0,y0,x,y,turn;
                x0 = 1 - (w / 2); y0 = 1 + (w / 2);
                turn = w&(0x01);

                float* firstline = sdata;
                float* secondline = sdata + wide + 1;
                float* thirdline = firstline;
                
                //modify @1.22 add L-st+1,modify @ 1.17;
                int longest = min(hi, min(L-grpstx+1, L-st+1));
                for(int step = 1; step < longest; step++){
                    
                    __syncthreads();
                    for(int i = tid;i < wide; i+= blockDim.y){
                        x = x0 + i;
                        y = y0 - i;
                        if(isvalid(x,y,w,hi)){
                            // modify @ 1.22
                            thirdline[i+turn] = square(tmp_data[x-1]-tmpshapelet[y-1]) + min(firstline[i+turn],min(secondline[i],secondline[i+1]));

                        }
                    }

                    //modify @ 1.22 avoid the 1-31 threads arrive early.
                    __syncthreads();
                    
                    //这里限制了带宽,使带宽降低了16倍
                    if((tid==0)&&(step>=lo)){
                        int tmp_index = (step-lo) * coalesceforN + idx;
                        glb2local[tmp_index] = min(sdata[center], glb2local[tmp_index]);
                        /*
                        if(grpidx == 3 && grpstx == 27 && idx == 3 && step == 86){
                            printf("gpu list :st = %d,%lf,%lf\n",st,sdata[center],glb2local[tmp_index]);
                        }
                        */
                    }
     
                    // avoid the last threads arrive early. @1.22
                    __syncthreads();
                    Reverse;

                    __syncthreads();
                    for(int i = tid;i < wide; i+= blockDim.y){
                        x = x0 + i;
                        y = y0 - i;
                        if(isvalid(x,y,w,hi)){
                            thirdline[i+turn] = square(tmp_data[x-1]-tmpshapelet[y-1]) + min(firstline[i+turn],min(secondline[i],secondline[i+1]));
                        }
                   
                    }
                    __syncthreads();
                    Reverse;
                }
                
            }
            /*
            if(grpidx == 3 && grpstx == 27 && idx == 3 && tid == 0){
                printf("the 3 distance is %lf\n",gpu_cmpMinDist[21646*64+idx]);
            }
            */
        }
    }
}


__global__ void kernel_ComputedtwsperblockforAll(float* data, float* shapelet, int w, int N, int L, int lo, int hi, float* gpu_cmpMinDist, int idxst, int* gpu_arrindex){
    //这个函数的参数要好好设计一下
    extern __shared__ float cache[];

    int grpidx = blockIdx.x + idxst;
    int grpstx = blockIdx.y;

    int idx = threadIdx.x;
    int tid = threadIdx.y;

    int stride = 2*(w+2)+1;
    int* cache_arrindex = (int*)(cache + stride *blockDim.x);
    //int coalesceforN = (N - 1)&0xFFF0 + 0x0010;
    int coalesceforN = ((N - 1)/Coalescedfor128B + 1) * Coalescedfor128B;

    int step_CoalescedCopy = blockDim.x * blockDim.y;
    for(int i = threadIdx.y * blockDim.x + threadIdx.x; i < L; i+= step_CoalescedCopy){
        cache_arrindex[i] = gpu_arrindex[i];        
    }
    __syncthreads();
    //float* glb2local = gpu_cmpMinDist + (grpidx * (L - lo +  1) + grpstx) * (hi-lo) * coalesceforN;
    //float* glb2local = gpu_cmpMinDist + ((grpidx - idxst) * gridDim.y + grpstx) * (hi-lo) * coalesceforN;
    //float* glb2local = gpu_cmpMinDist + ((grpidx - idxst) * cache_arrindex[L-lo+1] + cache_arrindex[grpstx])  * coalesceforN;
    float* glb2local = gpu_cmpMinDist + index_ComposeNoloss(grpidx-idxst, cache_arrindex, L-lo+1, grpstx, 0) * coalesceforN;
    //int end = (hi - lo) * coalesceforN;
    int end = (cache_arrindex[grpstx+1] - cache_arrindex[grpstx]) * coalesceforN;
    for(int i = threadIdx.y * blockDim.x + threadIdx.x; i < end; i+= step_CoalescedCopy){
        glb2local[i] = INFINITY;
    }    
    __syncthreads();
    
    int wide = w + 1;
    int size = (w + 2)*2;
    int center = wide/2;

    float* sdata = cache + idx * stride;
    
    if(grpstx < (L-lo+1)){

        float* tmpshapelet = shapelet + grpidx * L + grpstx;
        //When N < blockDim.x, Only 1 loop for every thread.
        for(; idx < N; idx += blockDim.x){
        //if(idx < N){
            for(int st = 0; st < L - lo + 1; st++){
                
                float* tmp_data = data + (idx*L) + st;
                {
                    for(int i = tid;i < size;i+= blockDim.y)
                        sdata[i] = INFINITY;
                    if(tid == 0)
                        sdata[center] = 0.0;
                }

                __syncthreads();
                
                int x0,y0,x,y,turn;
                x0 = 1 - (w >> 1); y0 = 1 + (w >> 1);
                turn = w&(0x01);

                float* firstline = sdata;
                float* secondline = sdata + wide + 1;
                float* thirdline = firstline;
                
                //modify @1.22 add L-st+1,modify @ 1.17;
                int longest = min(hi, min(L-grpstx+1, L-st+1));
                for(int step = 1; step < longest; step++){
                    
                    __syncthreads();
                    for(int i = tid;i < wide; i+= blockDim.y){
                        x = x0 + i;
                        y = y0 - i;
                        if(isvalid(x,y,w,longest)){
                            // modify @ 1.22
                            thirdline[i+turn] = square(tmp_data[x-1]-tmpshapelet[y-1]) + min(firstline[i+turn],min(secondline[i],secondline[i+1]));

                        }
                    }
                    //modify @ 1.22 avoid the 1-31 threads arrive early.
                    __syncthreads();
                    
                    //这里限制了带宽,使带宽降低了16倍
                    if((tid==0)&&(step>=lo)){
                        int tmp_index = (step-lo) * coalesceforN + idx; 
                        glb2local[tmp_index] = min(sdata[center], glb2local[tmp_index]);
                        /*
                        if(grpidx == 22 && grpstx == 0 && step == 42 && idx == 1 && tid == 0){
                            printf("gpu:%f\n",glb2local[tmp_index]);
                        }
                        */
                    }
     
                    // avoid the last threads arrive early. @1.22
                    __syncthreads();
                    Reverse;

                    __syncthreads();
                    for(int i = tid;i < wide; i+= blockDim.y){
                        x = x0 + i;
                        y = y0 - i;
                        if(isvalid(x,y,w,longest)){
                            thirdline[i+turn] = square(tmp_data[x-1]-tmpshapelet[y-1]) + min(firstline[i+turn],min(secondline[i],secondline[i+1]));
                        }
                   
                    }
                    __syncthreads();
                    Reverse;
                }
                
            }
            /*
            if(grpidx == 22 && grpstx == 1 && idx == 0 && tid == 0){
            float* ccccc = gpu_cmpMinDist + index_ComposeNoloss(grpidx-idxst, cache_arrindex, L-lo+1, grpstx, (42-lo)) * coalesceforN;
            for(int i = 0;i < N;i++)
                printf("gpu:%f\n",ccccc[i]);
            }
            */
        }


        
    }
}
