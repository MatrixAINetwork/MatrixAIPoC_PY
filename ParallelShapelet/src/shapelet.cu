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
#include<stdio.h>
#include "shapelet.h"
#include "pub.h"
#include "prunedtw.h"
#include "infogain.h"
#include "euclid.h"
#include "min.h"
#include "distanceoncpu.h"

#include <curand.h>
#include <curand_kernel.h>
#include <string>

#define ShareMemThrehold 48*1024

#define INFOGAINBLOCKSIZE 32

//#define BankConflictStride 17

const int coalescefor128B = 128/sizeof(float);

#define ENTIRE_STARTTIME cudaEvent_t ENTIRE_Mstart0, ENTIRE_Mstop0; \
                      cudaEventCreate(&ENTIRE_Mstart0); \
                  cudaEventCreate(&ENTIRE_Mstop0); \
                  cudaEventRecord(ENTIRE_Mstart0, 0);

#define ENTIRE_STOPTIME cudaEventRecord(ENTIRE_Mstop0, 0); \
                     cudaEventSynchronize(ENTIRE_Mstop0); \
                 float ENTIRE_Mtime0; \
                 cudaEventElapsedTime(&ENTIRE_Mtime0, ENTIRE_Mstart0, ENTIRE_Mstop0); \
                 std::cout << "output:$$$$$$,The entire elapsed time: " << ENTIRE_Mtime0 << "ms.(including variable create and distroy)" << std::endl; \
                 cudaEventDestroy(ENTIRE_Mstart0); \
                 cudaEventDestroy(ENTIRE_Mstop0);

#define STARTTIME cudaEvent_t Mstart1, Mstop1; \
                      cudaEventCreate(&Mstart1); \
                  cudaEventCreate(&Mstop1); \
                  cudaEventRecord(Mstart1, 0);

#define STOPTIME cudaEventRecord(Mstop1, 0); \
                     cudaEventSynchronize(Mstop1); \
                 float Mtime1; \
                 cudaEventElapsedTime(&Mtime1, Mstart1, Mstop1); \
                 std::cout << "The entire calc time: " << Mtime1 << "ms.(no create and distroy)" << std::endl; \
                 cudaEventDestroy(Mstart1); \
                 cudaEventDestroy(Mstop1);

#define TEMPSTARTTIME cudaEventRecord(temp_Mstart, 0);

#define TEMPSTOPTIME(x)  cudaEventRecord(temp_Mstop, 0); \
                     cudaEventSynchronize(temp_Mstop); \
                    cudaEventElapsedTime(&temp_Mtime, temp_Mstart, temp_Mstop); \
                     std::cout << (x) << ": "<< temp_Mtime << "ms." << std::endl;



void Batch_CalcMinInfogain(float* gpu_data, char* gpu_label,float* gpu_cmpMinDist, float* gpu_infogain, float* gpu_dividepoint, int* gpu_leftis,int* gpu_glbidx, float* gpu_tempmin, int* gpu_tempminidx, int w, int N, int L, int lo, int hi, int shapelet_num, float outthrehold, float* lastinfogain, TPOUT* p3, int suma, int sumb, curandState_t* states, int idxst, int idxend, std::string func, int* gpu_arrindex, int* arrindex, float* time1, float* time2, float* gpu_fortranspose, int CoalescedForL_lo_1){

    cudaEvent_t temp_Mstart, temp_Mstop;
    float temp_Mtime;
    cudaEventCreate(&temp_Mstart);
    cudaEventCreate(&temp_Mstop);
    
    fillarrwith<<<(shapelet_num-1)/1024+1,1024>>>(gpu_infogain,shapelet_num,INFINITY);
    CheckCudaError(cudaGetLastError(),"After Fill INFINITY.\n");
    CheckCudaError(cudaDeviceSynchronize(),"After Fill INFINITY.\n");
   
    TEMPSTARTTIME;

    int BlockDimForX;
    int coalesceforN = ((N-1)/coalescefor128B+1)*coalescefor128B;    
    int size;
    BlockDimForX = NumsOfThreadPerBlock(L-lo+1);
    if(func == "euclid"){
        dim3 dimgrid(idxend - idxst,hi-lo);
        dim3 dimblock(BlockDimForX,1);
        size = 2 * L * sizeof(float) + L * sizeof(int);
        printf("%s need %d bytes share mem, dimgrid = (%d,%d),dimblock = (%d,%d)\n",func.c_str(),size,dimgrid.x,dimgrid.y,dimblock.x,dimblock.y);
        kernel_ComputeDist<<<dimgrid,dimblock,size>>>(gpu_data,gpu_infogain,gpu_dividepoint,gpu_leftis,N,L,lo,hi,outthrehold,gpu_cmpMinDist,idxst,gpu_arrindex);
        CheckCudaError(cudaGetLastError(),"1.After ComputeDist.\n");
        CheckCudaError(cudaDeviceSynchronize(),"1.After ComputeDist.\n");
        goto CALCINFOGAIN;
    }
   
    if(func == "euclidtranspose"){
        
        dim3 dimgrid(idxend - idxst,hi-lo);
        dim3 dimblock(CoalescedForL_lo_1,1);
        size = 3 * L * sizeof(float);
        /*
        if(size > ShareMemThrehold){
            printf("euclidtranspose share memory can not afford\n");
        }
        */
        printf("%s need %d bytes share mem, dimgrid = (%d,%d),dimblock = (%d,%d)\n",func.c_str(),size,dimgrid.x,dimgrid.y,dimblock.x,dimblock.y);
        kernel_ComputeDistSaveBlk<<<dimgrid,dimblock,size>>>(gpu_data, N,L, lo, hi,  gpu_fortranspose, idxst, gpu_arrindex,CoalescedForL_lo_1);

        CheckCudaError(cudaGetLastError(),"1.After ComputeDist.\n");
        CheckCudaError(cudaDeviceSynchronize(),"1.After ComputeDist.\n");
        size = L*sizeof(int) + (L-lo+1)*33*sizeof(float);
        dim3 dimblocktrans(32, CoalescedForL_lo_1/32);
        kernel_Transpose<<<dimgrid,dimblocktrans,size>>>(gpu_fortranspose, gpu_cmpMinDist, N, L, lo, hi, idxst, gpu_arrindex, coalesceforN,CoalescedForL_lo_1);

        //kernel_ComputeDist_AddTranspose<<<dimgrid,dimblock,size>>>(gpu_data,gpu_infogain,gpu_dividepoint,gpu_leftis,N,L,lo,hi,outthrehold,gpu_cmpMinDist,idxst,gpu_arrindex);
        CheckCudaError(cudaGetLastError(),"1.After transpose.\n");
        CheckCudaError(cudaDeviceSynchronize(),"1.After transpose.\n");
        goto CALCINFOGAIN;
    }

   /* 
    size = N*2*(w+2)*sizeof(float) + L* sizeof(int);
    BlockDimForX = NumsOfThreadPerBlock(N); 
//  if(size < ShareMemThrehold && N <= 1024){
    if(func == "dtw" && BlockDimForX <= 1024){
        dim3 dimgrid(idxend - idxst,L-lo+1);
        dim3 dimblock(BlockDimForX,1);
        printf("%s need %d bytes share mem, dimgrid = (%d,%d),dimblock = (%d,%d)\n",func.c_str(),size,dimgrid.x,dimgrid.y,dimblock.x,dimblock.y);
        kernel_Computedtwsperblock<<<dimgrid,dimblock,size>>>(gpu_data, gpu_data, w, N, L, lo , hi,gpu_cmpMinDist, idxst, gpu_arrindex);
        CheckCudaError(cudaGetLastError(),"2.After compute dtw block.\n");
        CheckCudaError(cudaDeviceSynchronize(),"2.After compute dtw block.\n");
        goto CALCINFOGAIN;
    }
   */ 
    BlockDimForX = 64;
//    int stride = 2*(w+2) + 1;
    size = BlockDimForX* (2*w+5) *sizeof(float) + L * sizeof(int);
//  if(size < ShareMemThrehold){
    if(func == "geneticdtw"){
        dim3 dimgrid(idxend - idxst, L-lo+1);
        dim3 dimblock(BlockDimForX,1);
        printf("%s need %d bytes share mem, dimgrid = (%d,%d),dimblock = (%d,%d)\n",func.c_str(),size,dimgrid.x,dimgrid.y,dimblock.x,dimblock.y);
        kernel_ComputedtwsperblockforAll<<<dimgrid,dimblock,size>>>(gpu_data, gpu_data, w, N, L, lo ,hi, gpu_cmpMinDist,idxst, gpu_arrindex);
        //kernel_ComputedtwsperblockforlargerW<<<dimgrid,dimblock,size>>>(gpu_data, gpu_data, w, N, L, lo ,hi, gpu_cmpMinDist,idxst, gpu_arrindex);
        CheckCudaError(cudaGetLastError(),"3.After compute dtw block.\n");
        CheckCudaError(cudaDeviceSynchronize(),"3.After compute dtw block.\n");
    }else{
        printf("The data is too large to provide a suitable method.\n");
        return;
    }

CALCINFOGAIN:
    TEMPSTOPTIME("CALC DISTANCE");
    (*time1) += temp_Mtime;
    if(N <= 40){
        //CALC INFOGAIN
        dim3 dimgrid1((shapelet_num-1)/INFOGAINBLOCKSIZE+1,1);
        dim3 dimblock1(1,INFOGAINBLOCKSIZE);
        //printf("dim (%d,%d),(%d,%d)\n",dimgrid1.x,dimgrid1.y,dimblock1.x,dimblock1.y); 
        int size2 = INFOGAINBLOCKSIZE * N + L*sizeof(int);
        TEMPSTARTTIME;
        printf("calc infogain need %d bytes, when N = %d and blockDim.y = %d\n",size2,N,INFOGAINBLOCKSIZE); 
        kernel_Computeifgain<<<dimgrid1, dimblock1, size2>>>(gpu_cmpMinDist,gpu_label, N, shapelet_num, gpu_infogain,gpu_dividepoint,gpu_leftis,gpu_glbidx,outthrehold,L,lo,hi,size2, coalesceforN,suma,sumb,states,w,idxst,gpu_arrindex);
        CheckCudaError(cudaGetLastError(),"After compute ifgain.\n");
        CheckCudaError(cudaDeviceSynchronize(),"After compute ifgain.\n");
        /*
        float bbbbbb[coalesceforN];
        CheckCudaError(cudaMemcpy(bbbbbb,gpu_cmpMinDist+(coalesceforN*63571),coalesceforN*sizeof(float),cudaMemcpyDeviceToHost),"aaaaa\n");
        for(int i = 0;i < coalesceforN;i++){
            printf("bbbbbb:%lf\n",bbbbbb[i]);
        }
        */
        TEMPSTOPTIME("CALC INFOGAIN");
        (*time2) += temp_Mtime;
        //CALC MIN  
        thrust::tuple<float,int> p1;
        host_ComputeArgMin(gpu_infogain,gpu_glbidx,shapelet_num,gpu_tempmin,gpu_tempminidx,&p1);
        CheckCudaError(cudaGetLastError(),"After ArgMin\n");
        CheckCudaError(cudaDeviceSynchronize(),"After ArgMin\n");

        printf("this infogain = %lf\n",thrust::get<0>(p1));
        //COMPARE WITH LAST BATCH
        if(thrust::get<0>(p1) < (*lastinfogain)){
            (*lastinfogain) = thrust::get<0>(p1);
            float dividepoint;
            int leftis;
            int index_out = thrust::get<1>(p1);

            CheckCudaError(cudaMemcpy(&dividepoint, gpu_dividepoint+index_out, sizeof(float), cudaMemcpyDeviceToHost), "copy from gpu_dividepoint to dividepoint failed\n");
            CheckCudaError(cudaMemcpy(&leftis, gpu_leftis+index_out, sizeof(int), cudaMemcpyDeviceToHost), "copy from gpu_leftis to leftis failed\n");
            
            //thrust::tuple<int,int,int> p2 = index_decompose(index_out,N,L-lo+1,hi-lo);
            thrust::tuple<int,int,int> p2 = index_decomposeNoloss(index_out,arrindex,L-lo+1);
            (*p3) = thrust::make_tuple(thrust::get<0>(p2)+idxst,thrust::get<2>(p2)+lo,thrust::get<1>(p2),thrust::get<0>(p1),dividepoint,leftis);
        }
    }else{
        
        int blocksize = 100;
        float* cpu_cmpMinDist = (float*)malloc(blocksize * coalesceforN * sizeof(float));
        char* cpu_label = (char*)malloc(blocksize * N * sizeof(char));
   
         
        for(int offset = 0; offset < shapelet_num; offset += blocksize){
            
            CheckCudaError(cudaMemcpy(cpu_cmpMinDist, gpu_cmpMinDist + (offset * coalesceforN) , blocksize * coalesceforN * sizeof(float), cudaMemcpyDeviceToHost), "cpu_cmpMinDist copy\n");
            CheckCudaError(cudaMemcpy(cpu_label, gpu_label, blocksize * N * sizeof(char), cudaMemcpyDeviceToHost),"cpu_label copy\n");
            
            T3ddi p1;
            for(int i = 0; i < blocksize; i++){
                thrust::tuple<int,int,int> n123 = index_decomposeNoloss(offset + i, arrindex, L-lo+1);
                int idx = thrust::get<0>(n123) + idxst;
                int st = thrust::get<1>(n123);
                int len = thrust::get<2>(n123) + lo;
                
                float* dist = cpu_cmpMinDist + i * coalesceforN;
                char* label = cpu_label + i * N;
                thrust::sort_by_key(thrust::seq, dist, dist + N, label);
                BestSplitInfogain(dist, N, label, &p1, suma, sumb);
                if(thrust::get<0>(p1) < outthrehold){
                    printf("infogain = %lf,dividepoint = %lf, leftis = %d, idx = %d, st = %d, len = %d, index_out = %d,(%d,%d,%d,%d)\n",thrust::get<0>(p1), thrust::get<1>(p1),thrust::get<2>(p1),idx,st,len,offset+i,lo,hi,N,L);
                }
                if(thrust::get<0>(p1) < (*lastinfogain)){
                    (*lastinfogain) = thrust::get<0>(p1);
                    (*p3) = thrust::make_tuple(idx,len,st,thrust::get<0>(p1),thrust::get<1>(p1),thrust::get<2>(p1));
                }  
            }            

        }
        
    
    }

    cudaEventDestroy(temp_Mstart);
    cudaEventDestroy(temp_Mstop);

}

void PreCalcIndex(int lo, int hi, int L, int* arr){
    arr[0] = 0;
    //printf("%d\n",arr[0]);
    for(int i = 0;i < (L-lo+1);i++){
        arr[i+1] = min(hi-lo,L-lo+1-i) + arr[i];
    //    printf("%d\n",arr[i+1]);
    }
}


void apply(float* data, char* label, int w, int N, int L, int lo, int hi, int shapelet_num, float outthrehold, TPOUT* p3, std::string func){

    //move from gpu to cpu for count a,b
    int suma = 0;
    int sumb = 0;
    for(int i = 0;i < N;i++){
        if(label[i] == 0)
            suma ++;
        else
            sumb ++;
    }

    if(func == "cpu"){
        printf("cpu calc#########################\n");
        host_calcdtws(data,data,label,N,L,lo,hi,w,suma,sumb,p3);
        return;
    }

    ENTIRE_STARTTIME;

    int* arrindex = (int*)malloc(L*sizeof(int));
    PreCalcIndex(lo,hi,L,arrindex);
    int idxstep = shapelet_num/arrindex[L-lo+1];
    
    int* gpu_arrindex;
    CheckCudaError(cudaMalloc((void **)&gpu_arrindex, L*sizeof(int)),"cuda malloc gpu_arrindex failed\n");
    CheckCudaError(cudaMemcpy(gpu_arrindex, arrindex, L*sizeof(int), cudaMemcpyHostToDevice), "copy from data to gpu_data failed\n");
    
    float* gpu_data = NULL;
    char* gpu_label = NULL;
        
    int coalesceforN = ((N-1)/coalescefor128B+1)*coalescefor128B;    
    //int shapelet_num = N*(L-lo+1)*(hi-lo);

    CheckCudaError(cudaMalloc((void **)&gpu_data,N*L*sizeof(float)),"cuda malloc gpu_data failed\n");
    CheckCudaError(cudaMemcpy(gpu_data, data, N*L*sizeof(float), cudaMemcpyHostToDevice), "copy from data to gpu_data failed\n");
    //对于这个的coalesce不必要要求是128
    
    //printf("cpu calc#########################\n");
    //host_calcdtws(data,data,label,N,L,lo,hi,w,suma,sumb);
    

    int tempblocksize = 128;
    CheckCudaError(cudaMalloc((void **)&gpu_label,tempblocksize*N*sizeof(char)),"cuda malloc gpu_label failed\n");
    CheckCudaError(cudaMemcpy(gpu_label, label, tempblocksize*N*sizeof(char), cudaMemcpyHostToDevice), "copy from label to gpu_label failed\n");
    
    float* gpu_infogain = NULL;
    float* gpu_dividepoint = NULL;
    int* gpu_leftis = NULL;
    int* gpu_glbidx = NULL;
    float* gpu_tempmin = NULL;
    int* gpu_tempminidx = NULL;

    CheckCudaError(cudaMalloc((void **)&gpu_infogain,shapelet_num*sizeof(float)),"cuda malloc gpu_infogain failed\n");
    CheckCudaError(cudaMalloc((void **)&gpu_dividepoint,shapelet_num*sizeof(float)),"cuda malloc gpu_dividepoint failed\n");
    CheckCudaError(cudaMalloc((void **)&gpu_leftis,shapelet_num*sizeof(int)),"cuda malloc gpu_leftis failed\n");
    CheckCudaError(cudaMalloc((void **)&gpu_glbidx,shapelet_num*sizeof(int)),"cuda malloc gpu_glbidx failed\n");
    CheckCudaError(cudaMalloc((void **)&gpu_tempmin,shapelet_num*sizeof(float)),"cuda malloc gpu_tempmin failed\n");
    CheckCudaError(cudaMalloc((void **)&gpu_tempminidx,shapelet_num*sizeof(int)),"cuda malloc gpu_tempminidx failed\n");


    float* gpu_cmpMinDist = NULL;
    int cmpMinDistSize = shapelet_num * coalesceforN * sizeof(float);
    CheckCudaError(cudaMalloc((void **)&gpu_cmpMinDist, cmpMinDistSize),"cudamalloc gpu_cmpMinDist failed\n");

    float* gpu_fortranspose = NULL;
    int CoalescedForL_lo_1 = ((L-lo)/coalescefor128B + 1)*coalescefor128B;
    int fortransposeSize = idxstep * CoalescedForL_lo_1 * (hi-lo) * coalesceforN * sizeof(float);
    CheckCudaError(cudaMalloc((void **)&gpu_fortranspose, fortransposeSize),"cudamalloc gpu_cmpMinDist failed\n");
    
    float lastinfogain = INFINITY;
  
    //STARTTIME;
    curandState_t* states;
    cudaMalloc((void**) &states, shapelet_num * sizeof(curandState_t)); 
    rand_init<<<(shapelet_num-1)/256+1,256>>>(time(0),states, shapelet_num);
    int batch = 1;
   // int idxstep = shapelet_num/arrindex[L-lo+1];
    float elapsedtimefordis = 0.0;
    float elapsedtimeforinfo = 0.0;
    for(int idxst = 0; idxst < N; idxst += idxstep,batch++){
        int idxend = idxst + min(idxstep,N-idxst);
        int temp_shapelet_num = (idxend-idxst)*arrindex[L-lo+1];
        printf("*******The %d batch calc idx index from %d to %d, %d candidates in total.********\n",batch,idxst,idxend,temp_shapelet_num);
        Batch_CalcMinInfogain(gpu_data,gpu_label,gpu_cmpMinDist,gpu_infogain,gpu_dividepoint,gpu_leftis,gpu_glbidx,gpu_tempmin,gpu_tempminidx,w,N,L,lo,hi,temp_shapelet_num,outthrehold,&lastinfogain,p3,suma,sumb,states,idxst,idxend,func, gpu_arrindex, arrindex,&elapsedtimefordis,&elapsedtimeforinfo, gpu_fortranspose,CoalescedForL_lo_1);
    }
    
    //std::cout << "output:$$$$$$,w = " << w << std::endl;
    //std::cout << "output:$$$$$$,calc distance:" << elapsedtimefordis << ",calc infogain:" << elapsedtimeforinfo << std::endl;
    //STOPTIME;
    CheckCudaError(cudaFree(gpu_cmpMinDist),"cudafree gpu_cmpMinDist failed\n");
    CheckCudaError(cudaFree(gpu_fortranspose),"cudafree gpu_fortranspose failed\n");
    CheckCudaError(cudaFree(gpu_data),"cudaFree gpu_data failed\n");
    CheckCudaError(cudaFree(gpu_label),"cudaFree gpu_label failed\n");

    CheckCudaError(cudaFree(gpu_infogain),"cudaFree gpu_infogain failed\n");
    CheckCudaError(cudaFree(gpu_dividepoint),"cudaFree gpu_dividepoint failed\n");
    CheckCudaError(cudaFree(gpu_leftis),"cudaFree gpu_leftis failed\n");
    CheckCudaError(cudaFree(gpu_glbidx),"cudaFree gpu_glbidx failed\n");

    CheckCudaError(cudaFree(gpu_tempmin),"cudaFree gpu_tempmin failed\n");
    CheckCudaError(cudaFree(gpu_tempminidx),"cudaFree gpu_tempminidx failed\n");
    ENTIRE_STOPTIME;

    std::cout << "output:$$$$$$,w=" << w << ":" << ENTIRE_Mtime0 << "\t"<< elapsedtimefordis << "\t" << elapsedtimeforinfo << std::endl;
    return;

}
