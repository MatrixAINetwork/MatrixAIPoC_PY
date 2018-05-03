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
#include<cuda.h>
#include<cuda_runtime_api.h>
#include<stdio.h>
//#include <stdlib.h> 
#include <time.h>  
#include <thrust/sort.h>
#include <thrust/execution_policy.h>
#include "euclid.h"

const int coalescefor128B = 128/sizeof(float);
//const unsigned int Mask_0xFFF0 = 0xFFF0;


__global__ void fillarrwith(float* gpu_arr, int D1, float value){

    int tid = threadIdx.x;
    int index_out = blockIdx.x * blockDim.x + tid;
    if(index_out < D1){
        gpu_arr[index_out] = value;
    }
}

__global__ void kernel_ComputeDist(float* gpu_data, float* gpu_infogain, float* gpu_dividepoint,int* gpu_leftis,const int N,const int L, const int lo, const int hi, const float outthrehold, float* gpu_cmpMinDist, int idxst,  int* gpu_arrindex){

    int s = threadIdx.x; 
    int idx = blockIdx.x + idxst;
    int len = blockIdx.y + lo;
    int stop = L-len+1;

    extern __shared__ char smem[];

    float* buf0 = (float*)smem;
    float* buf = buf0 + L;
    int* cache_arrindex = (int*)(smem + 2 * L * sizeof(float));
    
    for(int i = s; i < L; i += blockDim.x){
        cache_arrindex[i] = gpu_arrindex[i];
    }
    
    __syncthreads();

    if(idx < N && len < hi && s < stop){
     
        int coalesceforN = ((N-1)/coalescefor128B+1)*coalescefor128B;
        //int coalesceforN = ((N-1)/coalescefor128B)+coalescefor128B;

//      int temp = ((idx * (L-lo+1) + s)*(hi-lo)+(len-lo));
//      int index_out = index_compose(idx - idxst,N,s,L-lo+1,len-lo,hi-lo);
//        int index_out = (idx - idxst)*gpu_arrindex[L-lo+1]+gpu_arrindex[s]+(len-hi);
//        int index_out = (idx - idxst)*cache_arrindex[L-lo+1] + cache_arrindex[s]+(len-lo);
        int index_out = index_ComposeNoloss(idx-idxst, cache_arrindex, L-lo+1, s, len-lo);
//        float* glb2local = gpu_cmpMinDist + ((idx * (L-lo+1) + s)*(hi-lo)+(len-lo))*coalesceforN;
        float* glb2local = gpu_cmpMinDist + index_out*coalesceforN;

        float dist[coalescefor128B];
        //last:float dist[77];
        float tmp;
        float tmp_l;
        int coal_j = 0;
        for(int j = 0 ;j < N; j++){
            
//           label[j] = gpu_label[j];
            buf0[s] = 0.0;
            buf[s] = 0.0;
            
            __syncthreads();
            int idxXL = idx * L;
            int jXL = j * L;
            for(int i = 0; i < len; i++){
                //Omega,(idx,1),(j,s+1)
                tmp = (gpu_data[idxXL+i] - gpu_data[jXL+s+i]);               
                buf0[s] += tmp * tmp;
                //Omega,(idx,s+1),(j,1)
                tmp = gpu_data[idxXL+s+i] - gpu_data[jXL+i];
                buf[s] += tmp * tmp;
            }
            
            dist[coal_j] = buf[s];
            
            //last:dist[j] = buf[s];
            
            for(int u = 1;u < L-len+1;u ++){
                //O(1)
                __syncthreads();
                
                if(s!=0){
                    tmp = gpu_data[idxXL+s-1] - gpu_data[jXL+u-1];
                    tmp_l = gpu_data[idxXL+s-1+len] - gpu_data[jXL+u-1+len];
                    buf[s] = buf[s-1] + (tmp_l* tmp_l) - (tmp * tmp);
                }
                __syncthreads();

               if(s==0)
                    buf[s] = buf0[u];

                if(buf[s] < dist[coal_j])
                    dist[coal_j] = buf[s];
            }

            coal_j ++;
            if(coal_j == coalescefor128B || j == N-1){
                for(int u=0;u < coalescefor128B;u++){
                    glb2local[u] = dist[u];
                }
                glb2local += coalescefor128B;
                coal_j = 0; 
            }

        }
    }
}


__global__ void kernel_ComputeDistSaveBlk(float* gpu_data, const int N,const int L, const int lo, const int hi,  float* gpu_fortranspose, int idxst,  int* gpu_arrindex, int CoalescedForL_lo_1){

    int s = threadIdx.x; 
    int idx = blockIdx.x + idxst;
    int len = blockIdx.y + lo;
    int stop = L-len+1;

    extern __shared__ char smem[];

    float* buf0 = (float*)smem;
    float* buf = buf0 + L;
    float* maxbuf = buf + L;

    int coalesceforN = ((N-1)/coalescefor128B+1)*coalescefor128B;
    float* gpu_transform = gpu_fortranspose + (blockIdx.x + blockIdx.y * gridDim.x)*CoalescedForL_lo_1*coalesceforN;

    if(idx < N && len < hi && s < stop){
     
        //float* glb2local = gpu_cmpMinDist + index_out*coalesceforN;

        //float dist[coalescefor128B];
        //last:float dist[77];
        float tmp;
        float tmp_l;
        
        for(int j = 0 ;j < N; j++){
            
            buf0[s] = 0.0;
            buf[s] = 0.0;
            
            __syncthreads();
            int idxXL = idx * L;
            int jXL = j * L;
            for(int i = 0; i < len; i++){
                //Omega,(idx,1),(j,s+1)
                tmp = (gpu_data[idxXL+i] - gpu_data[jXL+s+i]);               
                buf0[s] += tmp * tmp;
                //Omega,(idx,s+1),(j,1)
                tmp = gpu_data[idxXL+s+i] - gpu_data[jXL+i];
                buf[s] += tmp * tmp;
            }
            
            maxbuf[s] = buf[s];
            
            for(int u = 1;u < L-len+1;u ++){
                //O(1)
                __syncthreads();
                
                if(s!=0){
                    tmp = gpu_data[idxXL+s-1] - gpu_data[jXL+u-1];
                    tmp_l = gpu_data[idxXL+s-1+len] - gpu_data[jXL+u-1+len];
                    buf[s] = buf[s-1] + (tmp_l* tmp_l) - (tmp * tmp);
                }
                __syncthreads();

               if(s==0)
                    buf[s] = buf0[u];

                if(buf[s] < maxbuf[s])
                    maxbuf[s] = buf[s];
            }
            
            gpu_transform[j* CoalescedForL_lo_1 + s] = maxbuf[s];
        }
    }
}

__global__ void kernel_Transpose(float* gpu_fortranspose, float* gpu_cmpMinDist, const int N, const int L, const int lo, const int hi, int idxst, int* gpu_arrindex, int coalesceforN, int CoalescedForL_lo_1){

    int s = threadIdx.x + blockDim.x * threadIdx.y; 
    int idx = blockIdx.x + idxst;
    int len = blockIdx.y + lo;
    int stop = L - len + 1;

    //Coalesced XiuGai
    float* gpu_transform = gpu_fortranspose + (blockIdx.x + blockIdx.y * gridDim.x)* CoalescedForL_lo_1 *coalesceforN;
    //L-len+1
    //33*(L-lo+1);
    extern __shared__ char smem[];

    int* cache_arrindex = (int*)(smem);
    
    for(int i = s; i < L; i += blockDim.x* blockDim.y){
        cache_arrindex[i] = gpu_arrindex[i];
    }

    float* sdata = ((float*)smem) + L;

    //Coalesced XiuGai
    //float* gpu_temp = gpu_transform;// (L-len+1)*coalescefor128B;
//    int stop = L-len+1;
    for(int offset = 0; offset < coalesceforN; offset += coalescefor128B){
    //    float* gpu_temp = gpu_transform + (L-len+1)*coalescefor128B;
        for(int i = 0; i < coalescefor128B; i+= 1){
            if(s < stop){
                sdata[s*33+i] = gpu_transform[(offset+i)* CoalescedForL_lo_1 + s];
            }
            __syncthreads();
        }
        for(int row = 0;row < stop; row += blockDim.y){
            int index_out = index_ComposeNoloss(idx-idxst, cache_arrindex, L-lo+1, row, len-lo);
            float* glb2local = gpu_cmpMinDist + index_out * coalesceforN + offset;
            glb2local[threadIdx.x] = sdata[row*33+threadIdx.x];
        }
    }
}
