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
#include <cmath>
#include <fstream>
#include <sstream>
#include <algorithm>
#include <numeric>
#include <cuda_runtime_api.h>
#include <curand_kernel.h>
#include <tuple>
#include <stdlib.h>
#include <time.h>
#include <iterator>
#include <algorithm>    // std::random_shuffle
#include "metric.h"
#include "readfile.h"
//call read funtion

using namespace std;

//const int N = 50;
//const int L = 150;
typedef tuple<float,float,int,int,int,int> TP2d4i;
void ReadAllCombination(string file, vector<TP2d4i> &AllCombination){
    fstream f("temp/allcandidates.txt");
    string line;
    bool start = false;
    while(getline(f,line)){
            if(line.find("infogain")!=0)
                continue;
            
            float t1,t2;
            int t3,t4,t5,t6,t7;
            sscanf(line.c_str(),"infogain = %f,dividepoint = %f, leftis = %d, idx = %d, st = %d, len = %d, index_out = %d",&t1,&t2,&t3,&t4,&t5,&t6,&t7);
            AllCombination.push_back(make_tuple(t1,t2,t3,t4,t5,t6));
    } 
    
}


int main(int argc, char* argv[]) {
    //这里定义cuda初始化等.
    printf("0\n");
    vector<vector<float>> data1;
    vector<char> veclabel;
    string str(argv[1]);
    read(str, &data1, &veclabel);
    
    int N = atoi(argv[2]);
    int L = atoi(argv[3]);
    int w = atoi(argv[4]);
//    printf("1\n");
    float *data = (float*)malloc(N*L*sizeof(float));
    int *label = (int*)malloc(N*sizeof(int));   
//srand(1214);
//rintf("gpu_data as follows\n");   
    for(int i = 0;i < N;i++){
        for(int j = 0;j < L;j++){
            data[i*L+j] = data1[i][j];
        }
        label[i] = veclabel[i];
    }

//    printf("2\n");
    vector<vector<float>> testdata;
    vector<char> testlabel;
    //string teststr("data/GUN_POINT_TEST.csv");
    string teststr(argv[5]);
    read(teststr, &testdata, &testlabel);

	vector<TP2d4i> AllCombination;
    ReadAllCombination("",AllCombination);
    if(AllCombination.size() > 100){
        random_shuffle(AllCombination.begin(),AllCombination.end());
        AllCombination.erase(AllCombination.begin()+100,AllCombination.end());
    }
        
//    printf("3\n");

    float AuccSum = 0.0;
    int vector_size = AllCombination.size();
    for(auto e:AllCombination){
//        printf("3.1\n");
        float dividepoint = get<1>(e);
//        printf("3.2\n");
        int leftis =  get<2>(e);
        int idx = get<3>(e);
        int st =  get<4>(e);
        int len =  get<5>(e);
        
//        printf("%d,%d,%d\n",idx,st,len);
    	vector<float>S(data+idx*L+st,data+idx*L+st+len);
//        printf("3.3\n");
    	float accu = Accuracy(testdata, testlabel,S,w,dividepoint,leftis);
//        printf("3.4\n");
    	//printf("Auccracy = %lf.\n",accu);
		AuccSum += accu;
    }
//    printf("4\n");
	printf("output:$$$$$$,All S(totals :%d) average accuracy = %lf\n", vector_size , (AuccSum / vector_size)); 

	return 0;
}
