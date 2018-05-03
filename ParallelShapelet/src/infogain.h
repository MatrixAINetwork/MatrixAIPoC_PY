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
#include "pub.h"
#include <curand.h>
#include <curand_kernel.h>

__global__ void rand_init(unsigned int seed, curandState_t* states, int shapelet_num);

__global__ void kernel_Computeifgain(float* gpu_cmpMinDist, char* gpu_label, const int N, const int totals, float* gpu_infogain, float* gpu_dividepoint, int* gpu_leftis, int* gpu_glbidx, const float outthrehold, const int L, const int lo, const int hi, const int labelcacheoffset, const int coalesceforN, int suma, int sumb, curandState_t* states, int w, int idxst, int* gpu_arrindex);

