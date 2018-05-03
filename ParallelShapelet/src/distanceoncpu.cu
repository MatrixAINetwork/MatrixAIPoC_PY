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
#include "distanceoncpu.h"

#include <thrust/sort.h>
#include <thrust/execution_policy.h>
#include <thrust/tuple.h>
#include <thrust/fill.h>
//#define INFINITY 1.79769e+308
using namespace std;

#define abs(x) (x>0)?x:-x

#define square(x) ((x)*(x))

typedef thrust::tuple<float,float,int> T3ddi;
// function declaration
//__host__ __device__ void BestSplitInfogain(float* dist, int N, int* label, T3ddi* p1);
/********************************************
native implemented dtw on cpu
*********************************************/

__host__ float native_dtw(float* vec_a,float* vec_b, int M){

    float dp[M+1][M+1];
	for(int i = 1;i <= M;i++){
        dp[i][0] = INFINITY;
        dp[0][i] = INFINITY;
    }

    dp[0][0] = 0.0;
    for(int m = 1;m <= M;m++){
        for(int n = 1;n <= M;n++){
            dp[m][n] = square(vec_a[m-1]-vec_b[n-1]) + min(dp[m-1][n-1],min(dp[m-1][n],dp[m][n-1]));
//            printf(" %lf",dp[m][n]);
        }
//        printf("\n");
    }
    return dp[M][M];
}


/********************************************
pruned implemented dtw on cpu
*********************************************/

bool isvalidoncpu(int x,int y, int w, int M){
    return (y>=max(1,x-w) && (y<=min(M,x+w))&& (x>=1) && (x<=M));
}
__host__ float Euclid_Distance(float* vec_a, float* vec_b, int M){
    float tmp = 0.0;
    for(int i = 0; i < M; i++){
        tmp += square(vec_a[i]-vec_b[i]);
    }
    return tmp;
}


__host__ float Pruning_dtw(float* vec_a, float* vec_b, int w, int M){

	float dp[M+1][M+1];
    //avoid some -nan;
    memset(dp,0,(M+1)*(M+1)*sizeof(float));

    dp[0][0] = 0.0;
	for(int i = 1;i <= M;i++){
        dp[i][0] = INFINITY;
        dp[0][i] = INFINITY;
    }
    
    float left,down;
    for (int i = 1; i <= M; i++)
    {
        for (int j = max(1, i - w); j <= min(M, i + w); j++)
        {
            left = isvalidoncpu(i,j-1,w,M)?dp[i][j-1]:INFINITY;
            down = isvalidoncpu(i-1,j,w,M)?dp[i-1][j]:INFINITY;
            dp[i][j] = min(dp[i-1][j-1],min(left,down)) + square(vec_a[i-1]-vec_b[j-1]);
        }
    }
    return dp[M][M];
}

typedef thrust::tuple<int,int,int> T3iloc;

__host__ void host_calcdtws(float* data, float* shapelet, char* label,int N, int L, int lo, int hi, int w, int suma, int sumb, TPOUT* p3){
   
    T3iloc lastloc = thrust::make_tuple(0,0,0);
    T3ddi  lastifgain = thrust::make_tuple(INFINITY,INFINITY,0);
    T3ddi  tempifgain = thrust::make_tuple(INFINITY,INFINITY,0);
    for(int grpidx = 0; grpidx < N; grpidx++){
        for(int grpstx = 0; grpstx < L-lo+1; grpstx++){
            for(int len = lo; len < min(hi,L-grpstx+1); len ++){

                if(grpidx != 22 || grpstx != 1 || len != 42)
                   continue;
                //printf("hello world.\n");
                float* tmpshapelet = shapelet + grpidx*L + grpstx;
                float dist[N];
                char tmplabel[N];
                copy(label, label+N, tmplabel);
                for(int idx = 0; idx < N; idx++){
                    dist[idx] = INFINITY;
                    
                    for(int i = 0; i < L-len+1;i++){
                        float* tmpdata = data + idx* L + i;
                        float tmpdis;
                        if(w == 0){
                            tmpdis = Euclid_Distance(tmpdata,tmpshapelet,len);
                        }
                        else{
                            tmpdis = Pruning_dtw(tmpdata,tmpshapelet,w,len);
                        }
                        dist[idx] = min(dist[idx],tmpdis);
                    }
                    printf("cpu:%f,%d\n",dist[idx],label[idx]);
                }
                //排序.
                thrust::stable_sort_by_key(thrust::host, dist, dist+N, tmplabel);
                BestSplitInfogain(dist,N,tmplabel,&tempifgain,suma,sumb);
//                HeuristicSplitInfogain(dist,N,label,&tempifgain,suma,sumb);
                /* 
                for(int i = 0;i < N;i++){
                    printf("cpu:%lf\n",dist[i]);
                }
               */ 
                //if(grpidx == 13 && grpstx == 1 && len == 40)
                //    printf("13140:%lf\n",thrust::get<0>(tempifgain));
                if(thrust::get<0>(tempifgain) < thrust::get<0>(lastifgain)){
                    lastifgain = tempifgain;
                    lastloc = thrust::make_tuple(grpidx,grpstx,len);
                }
                //printf("######################################the cpu calc ifgain = %lf, dividepoint = %lf\n",thrust::get<0>(lastifgain),thrust::get<1>(lastifgain));
            }    
        }
    }
    (*p3) = thrust::make_tuple(thrust::get<0>(lastloc),thrust::get<2>(lastloc),thrust::get<1>(lastloc),thrust::get<0>(lastifgain),thrust::get<1>(lastifgain),thrust::get<2>(lastifgain));

    printf("The CPU calc infogain = %lf,dividepoint = %lf,location = (%d,%d,%d)\n",thrust::get<0>(lastifgain),thrust::get<1>(lastifgain),thrust::get<0>(lastloc),thrust::get<1>(lastloc),thrust::get<2>(lastloc));
}

