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

module INTU(
			input [`SIZE_DATA-1:0] a_i,
			input [`SIZE_DATA-1:0] b_i,
			input [`SIZE_DATA-1:0] c_i,
			input [`SIZE_OPCODE_USED-1:0] opcode_i,
			
			output [`SIZE_DATA-1:0] 		result_o
			);
			
	reg [`SIZE_DATA-1:0] 		result;
	reg [`SIZE_DATA-1:0] 		result_hi;
	reg [`SIZE_DATA-1:0] 		result_lo;
	wire [`SIZE_DATA-1:0] a;
	wire [`SIZE_DATA-1:0] b;
	wire [`SIZE_DATA-1:0] c;
	
	assign result_o    = result;
	assign a = a_i;
	assign b = b_i;
	assign c = c_i;
	
	always @(*) begin:INTU_OPERATION
		case(opcode_i)
			`ADD_S32:
			begin
				result = a + b;
			end
			
			`SUB_S32:
			begin
				result = a - b;
			end
			
			`MUL_LO_S32:
			begin
				{result_hi, result_lo} = a * b;
				result = result_lo;
			end
			
			`MUL_HI_S32:
			begin
				{result_hi, result_lo} = a * b;
				result = result_hi;
			end
			
			`MAD_S32:
			begin
				{result_hi, result_lo} = a * b + c;// need to modify?
				result = result_lo;
			end
			
			`DIV_S32:
			begin
				//result = a / b;
				result = 32'b1110;//hu xie?
			end
			
			`REM_S32:
			begin
				//result = a % b;
				result = 32'b10;//hu xie?
			end
			
			`ABS_S32:
			begin
				if(a[`SIZE_DATA-1] == 1'b0)
					result = a;
				else 
					result = -a;
			end
			
			`NEG_S32:
			begin
				result = -a;
			end
			
			`MIN_S32:
			begin
				result = (a < b) ? a:b;
			end
			
			`MAX_S32:
			begin
				result = (a > b) ? a:b;
			end
			
			`SETP_EQ_S32:
			begin
				result = {31'b0, (a == b)};
			end
			
			`SETP_NE_S32:
			begin
				result = {31'b0, (a != b)};
			end
			
			`SETP_LT_S32:
			begin
				result = {31'b0, (a < b)};
			end
			
			`SETP_LE_S32:
			begin
				result = {31'b0, (a <= b)};
			end
			
			`SETP_GT_S32:
			begin
				result = {31'b0, (a > b)};
			end
			
			`SETP_GE_S32:
			begin
				result = {31'b0, (a >= b)};
			end
			
			`MOV:
			begin
				result = a + b;	//MOV or MOVI
			end
			
			`MOV_SR:
			begin
				result = a;	
			end
			
			`SELP:
			begin
				result = c[0]? a : b;
			end
			
			`AND:
			begin
				result = a & b;
			end
			
			`OR:
			begin
				result = a | b;
			end
			
			`XOR:
			begin
				result = a ^ b;
			end
			
			`NOT:
			begin
				result = ~a;
			end
			
			`CNOT:
			begin
				result = (a == 0) ? 32'b1:0;
			end
			
			`SHL:
			begin
				result = a << b;
			end
			
			`SHR:
			begin
				result = a >> b;
			end
			
			default:
			begin
			end
		endcase
	end
	
endmodule
