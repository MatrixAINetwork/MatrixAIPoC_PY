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
module FirstAddr(
    input [`SIZE_ADDR-1:0] addr0,
    input [`SIZE_ADDR-1:0] addr1,
    input [`SIZE_ADDR-1:0] addr2,
    input [`SIZE_ADDR-1:0] addr3,
    input [`SIZE_ADDR-1:0] addr4,
    input [`SIZE_ADDR-1:0] addr5,
    input [`SIZE_ADDR-1:0] addr6,
    input [`SIZE_ADDR-1:0] addr7,
    input [`SIZE_ADDR-1:0] addr8,
    input [`SIZE_ADDR-1:0] addr9,
    input [`SIZE_ADDR-1:0] addr10,
    input [`SIZE_ADDR-1:0] addr11,
    input [`SIZE_ADDR-1:0] addr12,
    input [`SIZE_ADDR-1:0] addr13,
    input [`SIZE_ADDR-1:0] addr14,
    input [`SIZE_ADDR-1:0] addr15,
    input [`SIZE_ADDR-1:0] addr16,
    input [`SIZE_ADDR-1:0] addr17,
    input [`SIZE_ADDR-1:0] addr18,
    input [`SIZE_ADDR-1:0] addr19,
    input [`SIZE_ADDR-1:0] addr20,
    input [`SIZE_ADDR-1:0] addr21,
    input [`SIZE_ADDR-1:0] addr22,
    input [`SIZE_ADDR-1:0] addr23,
    input [`SIZE_ADDR-1:0] addr24,
    input [`SIZE_ADDR-1:0] addr25,
    input [`SIZE_ADDR-1:0] addr26,
    input [`SIZE_ADDR-1:0] addr27,
    input [`SIZE_ADDR-1:0] addr28,
    input [`SIZE_ADDR-1:0] addr29,
    input [`SIZE_ADDR-1:0] addr30,
    input [`SIZE_ADDR-1:0] addr31,
	 input [`SIZE_CORE_LOG - 1:0] FirstOne,
	 input [`SIZE_CORE - 1 : 0] Mask,
	 output reg [`SIZE_ADDR-1:0] FirstOneAddr,
	 output [`SIZE_CORE-1:0] outmask
	);
	
	always @ (*)
	begin
	case(FirstOne) 
		5'b00000:  FirstOneAddr <= addr0;
		5'b00001:  FirstOneAddr <= addr1;
		5'b00010:  FirstOneAddr <= addr2;
		5'b00011:  FirstOneAddr <= addr3;
		5'b00100:  FirstOneAddr <= addr4;
		5'b00101:  FirstOneAddr <= addr5;
		5'b00110:  FirstOneAddr <= addr6;
		5'b00111:  FirstOneAddr <= addr7; 
		5'b01000:  FirstOneAddr <= addr8;
		5'b01001:  FirstOneAddr <= addr9;
		5'b01010:  FirstOneAddr <= addr10;
		5'b01011:  FirstOneAddr <= addr11;
		5'b01100:  FirstOneAddr <= addr12;
		5'b01101:  FirstOneAddr <= addr13;
		5'b01110:  FirstOneAddr <= addr14;
		5'b01111:  FirstOneAddr <= addr15;
		5'b10000:  FirstOneAddr <= addr16;
		5'b10001:  FirstOneAddr <= addr17;
		5'b10010:  FirstOneAddr <= addr18;
		5'b10011:  FirstOneAddr <= addr19;
		5'b10100:  FirstOneAddr <= addr20;
		5'b10101:  FirstOneAddr <= addr21;
		5'b10110:  FirstOneAddr <= addr22;
		5'b10111:  FirstOneAddr <= addr23;
		5'b11000:  FirstOneAddr <= addr24;
		5'b11001:  FirstOneAddr <= addr25;
		5'b11010:  FirstOneAddr <= addr26;
		5'b11011:  FirstOneAddr <= addr27;
		5'b11100:  FirstOneAddr <= addr28;
		5'b11101:  FirstOneAddr <= addr29;
		5'b11110:  FirstOneAddr <= addr30;
		5'b11111:  FirstOneAddr <= addr31;
	endcase
	end
	
		assign outmask[0] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr0[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[0])? 1'b1:1'b0;
		assign outmask[1] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr1[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[1])? 1'b1:1'b0;
		assign outmask[2] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr2[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[2])? 1'b1:1'b0;
		assign outmask[3] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr3[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[3])? 1'b1:1'b0;
		assign outmask[4] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr4[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[4])? 1'b1:1'b0;
		assign outmask[5] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr5[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[5])? 1'b1:1'b0;
		assign outmask[6] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr6[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[6])? 1'b1:1'b0;
		assign outmask[7] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr7[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[7])? 1'b1:1'b0;
		assign outmask[8] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr8[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[8])? 1'b1:1'b0;
		assign outmask[9] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr9[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[9])? 1'b1:1'b0;
		assign outmask[10] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr10[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[10])? 1'b1:1'b0;
		assign outmask[11] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr11[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[11])? 1'b1:1'b0;
		assign outmask[12] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr12[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[12])? 1'b1:1'b0;
		assign outmask[13] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr13[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[13])? 1'b1:1'b0;
		assign outmask[14] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr14[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[14])? 1'b1:1'b0;
		assign outmask[15] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr15[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[15])? 1'b1:1'b0;
		assign outmask[16] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr16[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[16])? 1'b1:1'b0;
		assign outmask[17] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr17[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[17])? 1'b1:1'b0;
		assign outmask[18] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr18[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[18])? 1'b1:1'b0;
		assign outmask[19] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr19[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[19])? 1'b1:1'b0;
		assign outmask[20] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr20[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[20])? 1'b1:1'b0;
		assign outmask[21] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr21[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[21])? 1'b1:1'b0;
		assign outmask[22] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr22[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[22])? 1'b1:1'b0;
		assign outmask[23] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr23[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[23])? 1'b1:1'b0;
		assign outmask[24] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr24[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[24])? 1'b1:1'b0;
		assign outmask[25] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr25[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[25])? 1'b1:1'b0;
		assign outmask[26] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr26[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[26])? 1'b1:1'b0;
		assign outmask[27] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr27[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[27])? 1'b1:1'b0;
		assign outmask[28] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr28[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[28])? 1'b1:1'b0;
		assign outmask[29] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr29[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[29])? 1'b1:1'b0;
		assign outmask[30] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr30[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[30])? 1'b1:1'b0;
		assign outmask[31] = ((FirstOneAddr[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG] == addr31[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG]) & Mask[31])? 1'b1:1'b0;

endmodule