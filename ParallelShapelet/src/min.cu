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
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "pub.h"
#include "min.h"

#include <thrust/sort.h>
#include <thrust/execution_policy.h>
#include <thrust/tuple.h>
#include <thrust/fill.h>

__global__ void kernel_ComputeMin(float* gpu_in, int D1, float* gpu_out, int D2){
    
    int s = threadIdx.x;
    int index_out = blockIdx.x * blockDim.x + s;
    
    __shared__ float sdata[1024];

    if(index_out < D1){
        sdata[s] = gpu_in[index_out];
    }

    int stop = blockDim.x;
    if(blockDim.x * (blockIdx.x + 1) > D1)
        stop = D1 - (blockDim.x * blockIdx.x);

    __syncthreads();
    unsigned int s0 = blockDim.x;
    while(s0 >= stop){
        s0 = (s0>>1);
    }
    
    __syncthreads();

    if(s < (stop-s0) && sdata[s] > sdata[s+s0])
        sdata[s] = sdata[s+s0];

    __syncthreads();

    for(s0 = (s0>>1); s0>0; s0>>=1){
        if(s < s0 && sdata[s] > sdata[s+s0])
            sdata[s] = sdata[s+s0];
        __syncthreads();
    }
    if(s == 0){
        gpu_out[blockIdx.x] = sdata[0];
    }
}


__global__ void kernel_ComputeArgMin(float* gpu_in, int* gpu_idxin, int D1, float* gpu_out, int* gpu_idxout, int D2){
    
    int s = threadIdx.x;
    int index_out = blockIdx.x * blockDim.x + s;
    
    __shared__ float sdata[1024];
    __shared__ unsigned int sidx[1024];

    if(index_out < D1){
        sdata[s] = gpu_in[index_out];
        sidx[s] = gpu_idxin[index_out];
    }

    int stop = (blockIdx.x+1==gridDim.x)?(D1-(blockDim.x* blockIdx.x)):blockDim.x;

    __syncthreads();

    unsigned int s0 = blockDim.x;
    while(s0 >= stop){
        s0 = (s0>>1);
    }
    
    __syncthreads();

    if(s < (stop-s0) && sdata[s] > sdata[s+s0]){
        sdata[s] = sdata[s+s0];
        sidx[s] = sidx[s+s0];
    }

    __syncthreads();
    for(s0 = (s0>>1); s0>0; s0>>=1){
        if(s < s0 && sdata[s] > sdata[s+s0]){
            sdata[s] = sdata[s+s0];
            sidx[s] = sidx[s+s0];
        }
        __syncthreads();
    }
    if(s == 0){
        gpu_out[blockIdx.x] = sdata[0];
        gpu_idxout[blockIdx.x] = sidx[0];
    }
}

__global__ void kernel_GiveIndex(int* vectorindex, int Dn){

    int idx = blockDim.x * blockIdx.x + threadIdx.x;
    if(idx < Dn){
        vectorindex[idx] = idx;
    }
}

__host__ void host_ComputeArgMin(float* gpu_left, int* gpu_leftidx, int D1, float* gpu_right, int* gpu_rightidx, thrust::tuple<float,int>* p1){
    
    int totals = D1;
    float* temp;
    float* left;
    float* right;
    int* tempidx;
    int* leftidx;
    int* rightidx;
    left = gpu_left;
    right = gpu_right;
    leftidx = gpu_leftidx;
    rightidx = gpu_rightidx;
    kernel_GiveIndex<<<((totals-1)>>10)+1,1024>>>(leftidx,D1);
    while(totals > 1){
        int nexttotals = ((totals-1)>>10) + 1;
        kernel_ComputeArgMin<<<nexttotals,1024>>>(left,leftidx,totals,right,rightidx,nexttotals);
        temp = left;
        left = right;
        right = temp;

        tempidx = leftidx;
        leftidx = rightidx;
        rightidx = tempidx;
        totals = nexttotals;
    }
    
    int index_out;
    float ifgain;
    CheckCudaError(cudaMemcpy(&ifgain, gpu_left, sizeof(float), cudaMemcpyDeviceToHost), "copy from gpu_min to debug failed\n");
    CheckCudaError(cudaMemcpy(&index_out, gpu_leftidx, sizeof(int), cudaMemcpyDeviceToHost), "copy from gpu_minvalue to debugid failed\n");
    (*p1) = thrust::make_tuple(ifgain,index_out);
    //printf("gpu calc : ifgain = %lf, idx = %d\n",ifgain,index_out);
}
