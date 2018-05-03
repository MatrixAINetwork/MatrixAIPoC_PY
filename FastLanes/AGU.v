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
`timescale 1ns / 1ps
`include "GPGPUParam.v"
`include "SimplePTX_ISA.v"

module AGU (
		input [`SIZE_DATA-1:0] 		data1_i,		
		input [`SIZE_IMMEDIATE-1:0] 	immd_i,

		output [`SIZE_DATA-1:0] 	result_o
	    ); 


	reg [`SIZE_DATA-1:0] 		result;


	assign result_o    = result;




	always @(*)
	begin:ALU_OPERATION
	  reg [`SIZE_DATA-1:0] sign_ex_immd;
		
		if(immd_i[`SIZE_IMMEDIATE-1] == 1'b1)
			sign_ex_immd = {16'b1111111111111111,immd_i};
		else
			sign_ex_immd = {16'b0000000000000000,immd_i};

		result 	   = data1_i + sign_ex_immd;
		
	end    

endmodule