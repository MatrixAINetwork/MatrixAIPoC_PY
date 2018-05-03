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
`include "MemoryParam.v"
`define SIZE_RAM 32
`define SIZE_RAM_LOG 5
module FirstZero(
			input [`SIZE_RAM - 1 : 0] RamValid,
			output [`SIZE_RAM_LOG - 1 : 0] FirstZero
		);
	wire [`SIZE_CORE - 1 : 0] Pre;
	wire [`SIZE_RAM - 1 : 0] Mask;
	assign Mask = RamValid;
	assign Pre[0] = Mask[0] ;
	assign Pre[1] = Mask[1] & Mask[0];
	assign Pre[2] = Mask[2] & Mask[1]& Mask[0];
	assign Pre[3] = Mask[3] & Mask[2]& Mask[1]& Mask[0];
	assign Pre[4] = Mask[4] & Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[5] = Mask[5] & Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[6] = Mask[6] & Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[7] = Mask[7] & Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[8] = Mask[8] & Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[9] = Mask[9] & Mask[8]& Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[10] = Mask[10] & Mask[9]& Mask[8]& Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[11] = Mask[11] & Mask[10]& Mask[9]& Mask[8]& Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[12] = Mask[12] & Mask[11]& Mask[10]& Mask[9]& Mask[8]& Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[13] = Mask[13] & Mask[12]& Mask[11]& Mask[10]& Mask[9]& Mask[8]& Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[14] = Mask[14] & Mask[13]& Mask[12]& Mask[11]& Mask[10]& Mask[9]& Mask[8]& Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[15] = Mask[15] & Mask[14]& Mask[13]& Mask[12]& Mask[11]& Mask[10]& Mask[9]& Mask[8]& Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[16] = Mask[16] & Mask[15]& Mask[14]& Mask[13]& Mask[12]& Mask[11]& Mask[10]& Mask[9]& Mask[8]& Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[17] = Mask[17] & Mask[16]& Mask[15]& Mask[14]& Mask[13]& Mask[12]& Mask[11]& Mask[10]& Mask[9]& Mask[8]& Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[18] = Mask[18] & Mask[17]& Mask[16]& Mask[15]& Mask[14]& Mask[13]& Mask[12]& Mask[11]& Mask[10]& Mask[9]& Mask[8]& Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[19] = Mask[19] & Mask[18]& Mask[17]& Mask[16]& Mask[15]& Mask[14]& Mask[13]& Mask[12]& Mask[11]& Mask[10]& Mask[9]& Mask[8]& Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[20] = Mask[20] & Mask[19]& Mask[18]& Mask[17]& Mask[16]& Mask[15]& Mask[14]& Mask[13]& Mask[12]& Mask[11]& Mask[10]& Mask[9]& Mask[8]& Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[21] = Mask[21] & Mask[20]& Mask[19]& Mask[18]& Mask[17]& Mask[16]& Mask[15]& Mask[14]& Mask[13]& Mask[12]& Mask[11]& Mask[10]& Mask[9]& Mask[8]& Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[22] = Mask[22] & Mask[21]& Mask[20]& Mask[19]& Mask[18]& Mask[17]& Mask[16]& Mask[15]& Mask[14]& Mask[13]& Mask[12]& Mask[11]& Mask[10]& Mask[9]& Mask[8]& Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[23] = Mask[23] & Mask[22]& Mask[21]& Mask[20]& Mask[19]& Mask[18]& Mask[17]& Mask[16]& Mask[15]& Mask[14]& Mask[13]& Mask[12]& Mask[11]& Mask[10]& Mask[9]& Mask[8]& Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[24] = Mask[24] & Mask[23]& Mask[22]& Mask[21]& Mask[20]& Mask[19]& Mask[18]& Mask[17]& Mask[16]& Mask[15]& Mask[14]& Mask[13]& Mask[12]& Mask[11]& Mask[10]& Mask[9]& Mask[8]& Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[25] = Mask[25] & Mask[24]& Mask[23]& Mask[22]& Mask[21]& Mask[20]& Mask[19]& Mask[18]& Mask[17]& Mask[16]& Mask[15]& Mask[14]& Mask[13]& Mask[12]& Mask[11]& Mask[10]& Mask[9]& Mask[8]& Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[26] = Mask[26] & Mask[25]& Mask[24]& Mask[23]& Mask[22]& Mask[21]& Mask[20]& Mask[19]& Mask[18]& Mask[17]& Mask[16]& Mask[15]& Mask[14]& Mask[13]& Mask[12]& Mask[11]& Mask[10]& Mask[9]& Mask[8]& Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[27] = Mask[27] & Mask[26]& Mask[25]& Mask[24]& Mask[23]& Mask[22]& Mask[21]& Mask[20]& Mask[19]& Mask[18]& Mask[17]& Mask[16]& Mask[15]& Mask[14]& Mask[13]& Mask[12]& Mask[11]& Mask[10]& Mask[9]& Mask[8]& Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[28] = Mask[28] & Mask[27]& Mask[26]& Mask[25]& Mask[24]& Mask[23]& Mask[22]& Mask[21]& Mask[20]& Mask[19]& Mask[18]& Mask[17]& Mask[16]& Mask[15]& Mask[14]& Mask[13]& Mask[12]& Mask[11]& Mask[10]& Mask[9]& Mask[8]& Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[29] = Mask[29] & Mask[28]& Mask[27]& Mask[26]& Mask[25]& Mask[24]& Mask[23]& Mask[22]& Mask[21]& Mask[20]& Mask[19]& Mask[18]& Mask[17]& Mask[16]& Mask[15]& Mask[14]& Mask[13]& Mask[12]& Mask[11]& Mask[10]& Mask[9]& Mask[8]& Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[30] = Mask[30] & Mask[29]& Mask[28]& Mask[27]& Mask[26]& Mask[25]& Mask[24]& Mask[23]& Mask[22]& Mask[21]& Mask[20]& Mask[19]& Mask[18]& Mask[17]& Mask[16]& Mask[15]& Mask[14]& Mask[13]& Mask[12]& Mask[11]& Mask[10]& Mask[9]& Mask[8]& Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	assign Pre[31] = Mask[31] & Mask[30]& Mask[29]& Mask[28]& Mask[27]& Mask[26]& Mask[25]& Mask[24]& Mask[23]& Mask[22]& Mask[21]& Mask[20]& Mask[19]& Mask[18]& Mask[17]& Mask[16]& Mask[15]& Mask[14]& Mask[13]& Mask[12]& Mask[11]& Mask[10]& Mask[9]& Mask[8]& Mask[7]& Mask[6]& Mask[5]& Mask[4]& Mask[3]& Mask[2]& Mask[1]& Mask[0];
	
assign FirstZero = Pre[0]+Pre[1]+Pre[2]+Pre[3]+Pre[4]+Pre[5]+Pre[6]+Pre[7]+Pre[8]+Pre[9]+Pre[10]+Pre[11]+Pre[12]+Pre[13]+Pre[14]+Pre[15]+Pre[16]+Pre[17]+Pre[18]+Pre[19]+Pre[20]+Pre[21]+Pre[22]+Pre[23]+Pre[24]+Pre[25]+Pre[26]+Pre[27]+Pre[28]+Pre[29]+Pre[30]+Pre[31];
	
	endmodule