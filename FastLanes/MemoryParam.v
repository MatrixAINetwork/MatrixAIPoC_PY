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
//----------------------------
//**Data Memory**
//----------------------------
`define SIZE_MEM_BYTES			512*1024			//256K = 262144
`define SIZE_MEM_BYTES_LOG		(9+10)				//18
`define SIZE_MEM_WORDS			`SIZE_MEM_BYTES/4		//65535
`define SIZE_MEM_WORDS_LOG		(`SIZE_MEM_BYTES_LOG-2)	//16
`define SIZE_MEM_BITS			`SIZE_MEM_BYTES*8		//2097152
`define SIZE_MEM_BITS_LOG		(`SIZE_MEM_BYTES_LOG+3)	//21

	//*Mem Line*
	`define SIZE_MEMLINE_BYTES		32						
	`define SIZE_MEMLINE_BYTES_LOG	(5)	
	`define SIZE_MEMLINE_BITS		`SIZE_MEMLINE_BYTES*8				//32*8 = 256
	`define SIZE_MEMLINE_BITS_LOG	(`SIZE_MEM_BYTES_LOG+3)				//5+3 = 8
	`define NUM_MEMLINE				`SIZE_MEM_BYTES/`SIZE_MEMLINE_BYTES			//256K/32 = 8192
	`define NUM_MEMLINE_LOG			(`SIZE_MEM_BYTES_LOG-`SIZE_MEMLINE_BYTES_LOG)	//18-5 = 13
//----------------------------



//----------------------------
//**Global Cache**
//----------------------------
	//*L1 Cache*
	`define SIZE_L1_GLOBAL_CACHE_BYTES			32*4							//16K = 16384
	`define SIZE_L1_GLOBAL_CACHE_BYTES_LOG		(5+2)							//14
	`define SIZE_L1_GLOBAL_CACHE_BITS			`SIZE_L1_GLOBAL_CACHE_BYTES*8			//131072
	`define SIZE_L1_GLOBAL_CACHE_BITS_LOG		`SIZE_L1_GLOBAL_CACHE_BYTES+3			//17
	`define L1_GLOBAL_CACHE_WAY					`SIZE_MEM_BYTES/`SIZE_L1_GLOBAL_CACHE_BYTES				//256K/16K = 16
	`define L1_GLOBAL_CACHE_WAY_LOG				(`SIZE_MEM_BYTES_LOG-`SIZE_L1_GLOBAL_CACHE_BYTES_LOG)		//18-14 = 4
	`define NUM_L1_GLOBAL_LINE					`SIZE_L1_GLOBAL_CACHE_BYTES/`SIZE_MEMLINE_BYTES			//512
	`define NUM_L1_GLOBAL_LINE_LOG				(`SIZE_MEM_BYTES_LOG-`SIZE_L1_GLOBAL_CACHE_BYTES_LOG)			//14-5 = 9

	//L2 Cache
	`define SIZE_L2_GLOBAL_CACHE_BYTES			32*8							//32K = 16384
	`define SIZE_L2_GLOBAL_CACHE_BYTES_LOG		(5+3)							//15
	`define SIZE_L2_GLOBAL_CACHE_BITS			`SIZE_L2_GLOBAL_CACHE_BYTES*8			//131072
	`define SIZE_L2_GLOBAL_CACHE_BITS_LOG		(`SIZE_L2_GLOBAL_CACHE_BYTES+3)			//17
	`define L2_GLOBAL_CACHE_WAY					`SIZE_MEM_BYTES/`SIZE_L2_GLOBAL_CACHE_BYTES				//256K/16K = 16
	`define L2_GLOBAL_CACHE_WAY_LOG				(`SIZE_MEM_BYTES_LOG-`SIZE_L2_GLOBAL_CACHE_BYTES_LOG)		//18-14 = 4
	`define NUM_L2_GLOBAL_LINE							`SIZE_L2_GLOBAL_CACHE_BYTES/`SIZE_MEMLINE_BYTES			//512
	`define NUM_L2_GLOBAL_LINE_LOG						(`SIZE_MEM_BYTES_LOG-`SIZE_L2_GLOBAL_CACHE_BYTES_LOG)			//14-5 = 9
//----------------------------



//----------------------------
//**Coalesce**
//----------------------------
`define SIZE_SEGMENT_BYTES			32
`define SIZE_SEGMENT_BYTES_LOG		5
`define SIZE_SEGMENT_BITS			`SIZE_SEGMENT_BYTES*8
`define SIZE_SEGMENT_BITS_LOG		(`SIZE_SEGMENT_BYTES_LOG+3)
//----------------------------