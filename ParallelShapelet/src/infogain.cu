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
#include <curand.h>
#include <curand_kernel.h>
#include <thrust/device_vector.h>
#include <thrust/pair.h>


#define INFOGAINBLOCKSIZE 32


__global__ void rand_init(unsigned int seed, curandState_t* states, int shapelet_num){
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    if(index < shapelet_num){
        curand_init(seed, blockIdx.x, 0, &states[blockIdx.x]);
    }
}

template <class T>
__host__ __device__ void swap(T& x,T& y)
{
    T temp;
    temp=x;
    x=y;
    y=temp;
}

__global__ void kernel_Computeifgain(float* gpu_cmpMinDist, char* gpu_label, const int N, const int totals, float* gpu_infogain, float* gpu_dividepoint, int* gpu_leftis, int* gpu_glbidx, const float outthrehold, const int L, const int lo, const int hi, const int labelcacheoffset, const int coalesceforN, int suma, int sumb, curandState_t* states, int w, int idxst, int* gpu_arrindex){
    //coalesceforN read a group of distance. 
    
    int tid = threadIdx.x;
    int s = threadIdx.y;
    int index = blockIdx.x * blockDim.y + s;
    float* gpu_local = gpu_cmpMinDist + index * coalesceforN;
        
    extern __shared__ char cache[];

    int end = INFOGAINBLOCKSIZE * N;
    int step = blockDim.x * blockDim.y;
    for(int i = tid + s * blockDim.x; i < end; i += step){
        cache[i] = gpu_label[i];
    }
    
    int* cacheindex = (int*)(cache+end);
//    __syncthreads();
    for(int i = tid + s * blockDim.x; i < L; i+= step){
        cacheindex[i] = gpu_arrindex[i];    
    }
    
    __syncthreads();
    
    if(tid ==0 && index < totals){
            
        char* locallabel = cache + s * N;
        T3ddi p1;

        /*
        for(unsigned int i = 1;i < N;i++){
            unsigned int j = curand(&states[index])%(i+1);
            if(i==j)
                continue; 
            swap(gpu_local[i], gpu_local[j]);
            swap(locallabel[i], locallabel[j]);
        }
        HeuristicSplitInfogain(gpu_local, N, locallabel, &p1, suma, sumb);
        */
        
        thrust::sort_by_key(thrust::seq, gpu_local, gpu_local + N, locallabel);
        BestSplitInfogain(gpu_local, N, locallabel, &p1,suma,sumb);
        
        //    thrust::tuple<int,int,int> n123 = index_decompose(index,N,hi-lo,L-lo+1);
        //    idx = thrust::get<0>(n123);
        //    st = thrust::get<2>(n123);
        //    len = thrust::get<1>(n123) + lo;

        gpu_infogain[index] = thrust::get<0>(p1);
        gpu_dividepoint[index] = thrust::get<1>(p1);
        gpu_leftis[index] = thrust::get<2>(p1);

        if(thrust::get<0>(p1) < outthrehold){
             //使用incompose做一下.
             thrust::tuple<int,int,int> n123 = index_decomposeNoloss(index, cacheindex, L-lo+1);
             int idx = thrust::get<0>(n123) + idxst;
             int st = thrust::get<1>(n123);
             int len = thrust::get<2>(n123) + lo;
        /*
             int idx = index/cacheindex[L-lo+1] + idxst;
             int temp = index - (idx-idxst)*cacheindex[L-lo+1];
             int st = binarysearch(cacheindex,temp,0,L-lo+1);
         */
             /*
             int st = 0;
             while(cacheindex[st+1] <= temp){
                st ++;
             }
             */
//             int len = temp - cacheindex[st] + lo;
             
             printf("infogain = %lf,dividepoint = %lf, leftis = %d, idx = %d, st = %d, len = %d, index_out = %d,(%d,%d,%d,%d)\n",thrust::get<0>(p1) , thrust::get<1>(p1),thrust::get<2>(p1),idx,st,len,index,lo,hi,N,L);
        }
    
    }

}

