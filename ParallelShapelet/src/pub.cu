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
/*
#include<stdio.h>
//#include "cuda_runtime.h"
#include <cuda.h>
#include <cuda_runtime_api.h>
#include "device_launch_parameters.h"

#include <thrust/sort.h>
#include <thrust/execution_policy.h>
#include <thrust/tuple.h>
*/
//#include <tuple>
#include "device_launch_parameters.h"
#include "pub.h"
#include <thrust/device_vector.h>
#include <thrust/pair.h>

#define M 100000000
//#define INFINITY 1.79769e+308

__host__ void CheckCudaError(cudaError_t err, char const* errMsg){
    if(err == cudaSuccess)
        return;
    printf("%s\nError Message:%s.\n",errMsg,cudaGetErrorString(err));
    exit(EXIT_FAILURE);
}

__host__ __device__ int NumsOfThreadPerBlock(int needsize){
    int size = 32;
    while(size < needsize){
        size *= 2;
    }
    return size;
}

__host__ __device__ int index_compose(int n1,int D1,int n2, int D2 , int n3, int D3){
    return (n1*D2 + n2)*D3 + n3;
}

__host__ __device__ thrust::tuple<int,int,int> index_decompose(int index,int D1,int D2,int D3){
    int n3 = index % D3;
    int temp = index / D3;
    int n2 = temp % D2;
    int n1 = temp / D2;
    return thrust::make_tuple(n1,n2,n3);
}

__host__ __device__ int binarysearch(int* arr, int key, int low, int high){

    int mid;
    while(low <= high){
        mid = (low + high) >> 1;
        if(key == arr[mid])
            return mid;
        if(key < arr[mid]){
            high = mid - 1;
        }else{
            low = mid + 1;
        }
    }
    return low - 1;
}

__host__ __device__ int index_ComposeNoloss(int n1, int* arrindex, int IndexOflastElement, int n2, int n3){
    return n1 * arrindex[IndexOflastElement] + arrindex[n2] + n3;
}


__host__ __device__ thrust::tuple<int,int,int> index_decomposeNoloss(int index, int* arrindex, int IndexOflastElement){
    int n1 = index / arrindex[IndexOflastElement];
    int temp = index - n1 * arrindex[IndexOflastElement];
    int n2 = binarysearch(arrindex, temp , 0 , IndexOflastElement);
    int n3 = temp - arrindex[n2];
    return thrust::make_tuple(n1,n2,n3);
}


//N,0,0
/*
__host__ __device__ int index_CustomCompose(int idx,int st, int len, int N, int lo, int hi, int L){
    int 

}

__host__ __device__ thrust::tuple<int,int,int> index_Customdecompose(int index, int N, int L, int lo, int hi){


}
*/

/*********************************************************
public function calc the best infogain (include the below three function)
*********************************************************/
__host__ __device__ float Entropy(int  a, int b){
    if(a==0) return 0;
    if(b==0) return 0;
    float pa = (a+0.0)/(a+b+0.0);
    float pb = (b+0.0)/(a+b+0.0);
    return -(pa*log(pa)+pb*log(pb));
}


__host__ __device__ float EntropyScale(int a, int b){
    return (a+b)*Entropy(a,b);
}

//Entropy after division
__host__ __device__ float EntropySplit(int a1, int b1, int a2, int b2){
    return ((a1+b1)*Entropy(a1, b1)+(a2+b2)*Entropy(a2, b2))/(a1+a2+b1+b2);
}


__host__ __device__ float EntropyPN(int  a, int b, int p, int n){
    if(a==0) return 0;
    if(b==0) return 0;
    float pa = (a+0.0)/(a+b+0.0);
    float pb = (b+0.0)/(a+b+0.0);
    return -(p*pa*log(pa)+n*pb*log(pb));
}

//Entropy after division
__host__ __device__ float EntropySplitPN(int a1, int b1, int a2, int b2){
    return ((a1+b1)*Entropy(a1, b1)+(a2+b2)*Entropy(a2, b2))/(a1+a2+b1+b2);
}

//__host__ __device__ void swap(float* dist, int x, int y)

template <class T>
__host__ __device__ void swap(T& x,T& y)
{
     T temp;
     temp=x;
     x=y;
     y=temp;
}

__host__ __device__ int Partition(float* dist, char* label, int left, int right){
    
    float pivot = dist[right];
    int p = left;
    for(int q = left; q < right; q++){
        if(dist[q] < pivot){
            swap(dist[p],dist[q]);
            swap(label[p],label[q]);
            p ++;
        }
    }
    swap(dist[p],dist[right]);
    swap(label[p],label[right]);
    return p;
}


__host__ __device__ void quicksort(float* dist, char* label, int left, int right){

    if(left >= right)
        return;    
    int mid = Partition(dist,label,left,right);
    quicksort(dist,label,left,mid-1);
    quicksort(dist,label,mid+1,right);
}

/*
__host__ __device__ void quicksort(float* dist, char* label, thrust::device_vector<R>&Region){
//    thrust::device_vector<R> Region; 
    Region.push_back(thrust::make_pair(0,N-1));
    while(Region.size()>0){
        R it = Region.back();
        Region.pop_back();
        int left = it.first;
        int right = it.second;
        if(left >= right)
            continue;
        int mid = Partition(dist,label,left,right);
        Region.push_back(thrust::make_pair(left,mid-1));
        Region.push_back(thrust::make_pair(mid+1,right));
    }
}
*/
__host__ __device__ int RangeCount(char* label, int left, int right, char c){
    int cnt = 0;
    for(int i = left;i < right; i++)
        if(label[i] == c)
            cnt ++;
    return cnt;    
}


__host__ __device__ void HeuristicSplitInfogain(float* dist, int N, char* label, T3ddi* p1, int suma, int sumb){
    int lefta1,leftb1,righta1,rightb1;
    lefta1 = leftb1 = righta1 = rightb1 = 0;
    
    int left = 0; 
    int right = N - 1; 
    while(left < right){
        int p = Partition(dist,label,left,right);
        int lefta2 = RangeCount(label,left,p,0);
        int leftb2 = (p-left) - lefta2;
        float leftEntropy = Entropy(lefta1+lefta2,leftb1+leftb2);
        int righta2,rightb2;
        righta2 = suma - (lefta1+lefta2+righta1);
        rightb2 = sumb - (leftb1+leftb2+rightb1);
        if(label[p] == 0){
            righta2 -= 1;
        }
        else{
            rightb2 -= 1;
        }
        
        float rightEntropy = Entropy(righta1+righta2, rightb1+rightb2);
        if(leftEntropy < rightEntropy){
            lefta1 += lefta2;
            leftb1 += leftb2;
            if(label[p]==0){lefta1+=1;}else{leftb1+=1;}            
            left = p + 1;
        }else{
            righta1 += righta2;
            rightb1 += rightb2;
            if(label[p]==0){righta1+=1;}else{rightb1+=1;}
            right = p - 1;    
        }
    }
    //归入左边还是右边?
    int mida = (label[left]==0?1:0); 
    int midb = (label[left]==1?1:0);
    float goleft = EntropySplit(lefta1+mida,leftb1+midb,righta1,rightb1);
    float goright = EntropySplit(lefta1,leftb1,righta1+mida,rightb1+midb);
    float dividepoint;
    float infogain;
    int leftis;
    if(goleft < goright){
        float rightmin = INFINITY;
        for(int i = left + 1;i < N; i++){
            if(dist[i] < rightmin)
                rightmin = dist[i]; 
        }
        infogain = goleft;
        dividepoint = (rightmin+dist[left]) / 2;
        lefta1 += mida;
        leftb1 += midb;
        leftis = (lefta1>leftb1)?0:1;
    }else{
        float leftmax = 0;
        for(int i = left-1;i >= 0;i--){
            if(dist[i] > leftmax)
                leftmax = dist[i];
        }
        infogain = goright;
        dividepoint = (leftmax +dist[left]) / 2;
        righta1 += mida;
        rightb1 += midb;
        leftis = (lefta1>leftb1)?0:1;
    }   
    (*p1) = thrust::make_tuple(infogain,dividepoint,leftis);
}


//typedef thrust::tuple<float, float, int> T3ddi;
__host__ __device__ void BestSplitInfogain(float* dist, int N, char* label, T3ddi* p1, int suma, int sumb){

	int lefta1 = 0;
	int leftb1 = 0;
	
	float infogain = INFINITY;
	float dividepoint = 0.0;
	int leftis = 0;

	for(int i = 0;i< N-1;i++){
		if(label[i] == 0)
			lefta1 ++;
		else
			leftb1 ++;
		float thisentropy = EntropySplit(lefta1,leftb1,suma-lefta1,sumb-leftb1);
//		float thisgap = dist[i+1] - dist[i];
//        thisentropy = thisentropy * M + ((thisgap>10)?0:(10-thisgap)); 
		if(thisentropy < infogain){
			infogain = thisentropy;
			leftis = (lefta1>leftb1)?0:1;
			dividepoint = (dist[i]+dist[i+1])/2;
		}
	}
    (*p1) = thrust::make_tuple(infogain,dividepoint,leftis);
}

__host__ __device__ void BestSplitInfogainNoStrust(float* dist, int N, int* label, float* infogain_out, float* dividepoint_out, int*leftis_out){

	int suma = 0;
	int sumb = 0;
	for(int i = 0;i < N;i++){
		if(label[i] == 0)
			suma ++;
		else
			sumb ++;
	}
	int lefta1 = 0;
	int leftb1 = 0;
	
	float infogain = INFINITY;
	float dividepoint = 0.0;
	int leftis = 0;

	for(int i = 0;i< N-1;i++){
		if(label[i] == 0)
			lefta1 ++;
		else
			leftb1 ++; 
		float thisentropy = EntropySplit(lefta1,leftb1,suma-lefta1,sumb-leftb1);
		
		if(thisentropy < infogain){
			infogain = thisentropy;
			leftis = (lefta1>leftb1)?0:1;
			dividepoint = (dist[i]+dist[i+1])/2;
		}
	}
    //(*p1) = thrust::make_tuple(infogain,dividepoint,leftis);
    (*infogain_out) = infogain;
    (*dividepoint_out) = dividepoint;
    (*leftis_out) = leftis;
}




