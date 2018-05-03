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
#include <random> // std::default_random_engine  
#include <chrono>
#include <string>

#include "metric.h"
#include "readfile.h"
#include "shapelet.h"


//call read funtion

using namespace std;

//const int N = 50;
//const int L = 150;
/*
vector<int> shuffleN(int N){
    vector<int> v;
    for(int i = 0;i < N;i++)
        v.push_back(i);
    unsigned seed = std::chrono::system_clock::now ().time_since_epoch ().count ();  
    std::shuffle (v.begin (), v.end (), std::default_random_engine (seed));  
    for (auto& it : v) {  
        std::cout << it << " ";  
    }  
  
    std::cout << "\n";  
    return v;
}
*/


int main(int argc, char* argv[]) {
    //这里定义cuda初始化等.
    vector<vector<float>> data1;
    vector<char> veclabel;
    //string str("data/GUN_POINT_TRAIN.csv");
    //read(str, &data1, &veclabel);
    /*
    int N = 50;
    int L = 150;
    int lo = 40;
    int hi = 100;
    int w = 0;
    */

    string str;
    string teststr;
    int N,L,lo,hi,w,shapelet_num;
    float outthrehold;
    string func = "euclid";
    if(argc != 11){
        printf("wrong number of argrment\n");
        str = "data/wafer_TRAIN.txt";
        teststr = "data/wafer_TEST.txt";
        N = 1000;
        L = 152;
        lo = 50;
        hi = 150;
        w = 0;
        shapelet_num = 107000;
        outthrehold = -100 + 0.00001;
        func = "geneticdtw";
    }else{
        str = argv[1];
        teststr = argv[8];
        N = atoi(argv[2]);
        L = atoi(argv[3]);
        lo = atoi(argv[4]);
        hi = atoi(argv[5]);
        w = atoi(argv[6]);
        shapelet_num = atoi(argv[9]);
        outthrehold = stod(argv[7]) + 0.00001;
        func = argv[10];
    }

    read(str, &data1, &veclabel);
    
    printf("%lf\n",outthrehold);
    float *data = (float*)malloc(N*L*sizeof(float));
    char *label = (char*)malloc(N*sizeof(char));   
    //vector<int> shuffleindex = shuffleN(N);
    //srand(1214);
//rintf("gpu_data as follows\n");   
    for(int i = 0;i < N;i++){
        //int index = shuffleindex[i];
        for(int j = 0;j < L;j++){
            data[i*L+j] = data1[i][j];
//            data[i*L+j] = 0.1*rand()/RAND_MAX;
    //        if(i == 1)
    //          printf(" %lf",data[i*L+j]);
        }
    //    printf("\n");
        label[i] = veclabel[i];
    }
    char* u_label = (char*)malloc(N*128*sizeof(char));
    for(int i = 0;i < 128;i++){
         copy (label, label+N, u_label+(i*N));
    }
    TPOUT p3;

    clock_t t;
    t = clock();
    apply(data,u_label,w,N,L,lo,hi,shapelet_num,outthrehold,&p3,func);
    t = clock() - t;
    printf("The elapsed time is %lf ms\n",1.0*t/1000);

    //这里需要输出参数

    vector<vector<float>> testdata;
    vector<char> testlabel;
    //string teststr("data/GUN_POINT_TEST.csv");
    read(teststr, &testdata, &testlabel);
    int idx,st,len,leftis;
    float dividepoint,infogain;

    idx = get<0>(p3);
    st =  get<2>(p3);
    len =  get<1>(p3);
    dividepoint =  get<4>(p3);
    leftis =  get<5>(p3);
    infogain = get<3>(p3);
    //vector<float>S(len);
    //把效果最好的怎么选出来.
    printf("idx = %d,st = %d, len = %d\n",idx, st , len);
    printf("dividepoint = %lf, leftis = %d\n",dividepoint,leftis);
    vector<float>S(data+idx*L+st,data+idx*L+st+len);
    //copy(data+idx*L+st,data+idx*L+st+len,S);
    
    ofstream out("temp/min.txt");
    if(out.is_open()){
        out << infogain << endl;
        out.close();
    }
    
    float accu = Accuracy(testdata, testlabel,S,w,dividepoint,leftis);
    printf("output:$$$$$$,Auccracy = %f.\n",accu);
	
    return 0;
}
