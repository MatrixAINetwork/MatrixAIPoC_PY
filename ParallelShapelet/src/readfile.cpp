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
#include <stdlib.h>
#include <time.h>
#include "readfile.h"

using namespace std;

vector<string> split(const string &s, char delim) {
    stringstream ss(s);
    string item;
    vector<string> tokens;
    while (getline(ss, item, delim)) {
        tokens.push_back(item);
    }
    return tokens;
}

void read(string &path,vector<vector<float> > *data, vector<char> *label){
    data->clear();
    label->clear();
    ifstream fin(path);
    string s;
    while(getline(fin, s)){
        int t;
        vector<string> stringVector = split(s,',');
        t = stoi(stringVector[0]);
        label->push_back((t-1==0)?0:1);
        vector<float> floatVector(stringVector.size()-1);
        transform(stringVector.begin() + 1, stringVector.end(), floatVector.begin(),[](const string& val) { return stod(val); });
        data->push_back(floatVector);
    }
}

