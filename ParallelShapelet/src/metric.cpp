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
#include <iostream>
#include <vector>
#include <algorithm>
#include <numeric>
#include <stdlib.h>
#include <iterator>

#include "metric.h"
#include "distanceoncpu.h"

using namespace std;


float SubsequenceDist(vector<float> T, vector<float> S, int l, float min_dist){
    if(T.size()<S.size()+l)
        //是否合理?
        return -1;
    float dist = 0;
    for(int i=0; i<S.size(); i++){
        //为什么这里要把float弄过来?
        float S_val = S[i];
        float T_val = T[i+l];
        dist += (S_val-T_val)*(S_val-T_val);
    }
    return dist;
}

//get minimum Distance of sequence T and subsequence S
float SubsequenceDist(vector<float> T, vector<float> S){
    int l = 0;
    float min_Dist = -1;
    while(true){
        float dist = SubsequenceDist(T, S, l, min_Dist);
        if(dist<0)
            break;
        if(min_Dist<0)
            min_Dist = dist;
        else{
            if(min_Dist>dist)
                min_Dist = dist;
        }
        l++;
    }
    return min_Dist;
}

float SubsequenceDtwDist(const vector<float>&T, const vector<float>&S, int w){
    int M = S.size(); int N = T.size();
    float vec_a[M];
    float vec_b[M];
    float dist = INFINITY;
    copy(S.begin(),S.end(),vec_a);
    for(int st = 0; st < N - M + 1; st ++){
        copy(T.begin()+st,T.begin()+st+M,vec_b);
        float temp = Pruning_dtw(vec_a,vec_b,w,M);
        if(temp < dist){
            dist = temp;
        }
    
    }
    return dist;
}

int predict(const vector<float>&T, const vector<float>&S, int w, float dividepoint, int leftis){
    int dist = SubsequenceDtwDist(T,S,w);
    return ((dist < dividepoint)?leftis:(1-leftis));
}

float Accuracy(const vector<vector<float>> testdata, const vector<char> &testlabel,const vector<float>&S,int w, float dividepoint, int lefis){
    int N = testdata.size();
    if(N != testlabel.size()){
        printf("The size of testdata not equal to testlabel");
    }
    int Cnt = 0;
    for(int i = 0;i < N;i ++){
        if(testlabel[i] == predict(testdata[i],S,w,dividepoint,lefis))
            Cnt++;    
    }
    return 1.0*Cnt/N;
}

