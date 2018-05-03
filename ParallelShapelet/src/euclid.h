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
#include "pub.h"
#include <stdio.h>

__global__ void kernel_ComputeDist(float* gpu_data, float* gpu_infogain, float* gpu_dividepoint,int* gpu_leftis, const int N,const int L,const int lo,const int hi, const float outthrehold, float* gpu_cmpMinDist, int idxst, int* gpu_arrindex);

//__global__ void kernel_ComputeDist_Coalesced(float* gpu_data, float* gpu_infogain, float* gpu_dividepoint,int* gpu_leftis,const int N,const int L, const int lo, const int hi, const float outthrehold, float* gpu_cmpMinDist);

__global__ void kernel_ComputeDistSaveBlk(float* gpu_data, const int N,const int L, const int lo, const int hi,  float* gpu_fortranspose, int idxst,  int* gpu_arrindex, int CoalescedForL_lo_1);

__global__ void kernel_Transpose(float* gpu_fortranspose, float* gpu_cmpMinDist, const int N, const int L, const int lo, const int hi, int idxst, int* gpu_arrindex, int coalesceforN, int CoalescedForL_lo_1);

__global__ void kernel_ComputeDist_AddTranspose(float* gpu_data, float* gpu_infogain, float* gpu_dividepoint,int* gpu_leftis,const int N,const int L, const int lo, const int hi, const float outthrehold, float* gpu_cmpMinDist, int idxst,  int* gpu_arrindex);

__global__ void fillarrwith(float* gpu_arr, int D1, float value);
