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
#include<cuda.h>
#include<cuda_runtime_api.h>

#include<thrust/sort.h>
#include<thrust/execution_policy.h>
#include<thrust/tuple.h>

#include <thrust/device_vector.h>
#include <thrust/pair.h>


__host__ void CheckCudaError(cudaError_t err, char const* errMsg);

__host__ __device__ int NumsOfThreadPerBlock(int needsize);

__host__ __device__ int index_compose(int n1,int D1,int n2, int D2, int n3, int D3);

__host__ __device__ thrust::tuple<int,int,int> index_decompose(int index,int D1,int D2,int D3);

__host__ __device__ int binarysearch(int* arr, int key, int low, int high);

__host__ __device__ int index_ComposeNoloss(int n1, int* arrindex, int IndexOflastElement, int n2, int n3);
__host__ __device__ thrust::tuple<int,int,int> index_decomposeNoloss(int index, int* arrindex, int IndexOflastElement);

typedef thrust::pair<int,int> R;
//__host__ __device__ void quicksort(float* dist, char* label, thrust::device_vector<R>&Region);
__host__ __device__ void quicksort(float* dist, char* label, int left, int right);

__host__ __device__ void BestSplitInfogainNoStrust(float* dist, int N, int* label, float* infogain, float* dividepoint,int*leftis);



typedef thrust::tuple<float, float, int> T3ddi;
__host__ __device__ void HeuristicSplitInfogain(float* dist, int N, char* label, T3ddi* p1, int suma, int sumb);

__host__ __device__ void BestSplitInfogain(float* dist, int N, char* label, T3ddi* p1, int suma, int sumb);
