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
#include <cuda.h>
#include<cuda_runtime.h>
#include "pub.h"
#include <thrust/tuple.h>
//declare

typedef thrust::tuple<int,float,float,int> Tiddi;
__host__ void host_ComputeArgMin(float* gpu_left, int* gpu_leftidx, int D1, float* gpu_right, int* gpu_rightidx, thrust::tuple<float,int>* p1);

__global__ void kernel_ComputeMin(float* gpu_in, int D1, float* gpu_out, int D2);

__global__ void kernel_ComputeArgMin(float* gpu_in, int* gpu_idxin, int D1, float* gpu_out,int* gpu_idxout, int D2);
