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
#include "pub.h"
#include <thrust/tuple.h>
#include <string.h>
//declare
typedef thrust::tuple<int,int,int,float,float,int> TPOUT;
void apply(float*data, char*label, int w, int N, int L, int lo, int hi,int shapelet_num,float outthrehold, TPOUT* p1, std::string func);
