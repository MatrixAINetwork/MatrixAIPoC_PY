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
`define RAM_SIZE_LOG 5

`define L1Size_log 14 //16k bytes = 2^(4 + 10) bytes
`define L2Size_log 19 //512 bytes = 2^(9 + 10) bytes
`define MEMSize_log 28 // 假设总共只有256M bytes的Memory
`define MEMDepth 256 * 1024 * 1024    // 2^(`MEMSize_log - `SIZE_SEGMENT_BYTES�

`define L1Depth_log `L1Size_log - `SIZE_SEGMENT_BYTES_LOG //9
`define L1Depth 512
`define L2Depth_log `L2Size_log - `SIZE_SEGMENT_BYTES_LOG //14
`define L2Depth 16*1024
`define L1TagSize `SIZE_ADDR-`L1Size_log  // 18
`define L2TagSize `SIZE_ADDR-`L2Size_log  // 13
`define L1Delay 1
`define L2Delay 20
`define DRAMDelay 400

module	L1TagUnit (
		input reset,
		input clk,
		input stall,
		
		input [`SIZE_ADDR - 1 : 0 ] L1TagWriteAddr,
		input L1TagWrite,		
		input [`SIZE_ADDR-1:0] Coalesce2L1_o,
		input [`SIZE_CORE_LOG - 1:0] SegNum,	
		
		output [9:0] Delay,
		output L1_HIT
		);
	//wire [`SIZE_ADDR-1:0]
	reg [`L1Depth - 1 : 0] L1Valid;
	reg [`SIZE_ADDR-1:0] Coalesce2L1_o_pre;
	wire [`L1TagSize - 1 : 0 ] L1Tag_i; //多一个valid�
	wire [`L1Depth_log - 1 : 0] L1Index_i;
	wire [`L1TagSize - 1 : 0 ] L1Tag_o;
	
	assign L1_HIT = (Coalesce2L1_o_pre != Coalesce2L1_o) & (L1Valid[L1Index_i] == 1) & 
						(Coalesce2L1_o[`SIZE_ADDR - 1 :`L1Depth_log + `SIZE_MEMLINE_BYTES_LOG] == L1Tag_o[`L1TagSize-1 : 0]);
	assign Delay = L1_HIT?`L1Delay : 0;					
	assign L1Index_i =  Coalesce2L1_o[`L1Depth_log + `SIZE_MEMLINE_BYTES_LOG - 1 : `SIZE_MEMLINE_BYTES_LOG];
	assign L1Tag_i = L1TagWriteAddr[`SIZE_ADDR - 1 :`L1Depth_log + `SIZE_MEMLINE_BYTES_LOG];
	always @ (posedge clk)
	begin
		if(reset)
		begin
			Coalesce2L1_o_pre <= 0;
			L1Valid <= `L1Depth'b0;
		end
		else if(~stall)
		begin			
			Coalesce2L1_o_pre <= Coalesce2L1_o;
			if(L1TagWrite)
				L1Valid [L1TagWriteAddr[`L1Depth_log + `SIZE_MEMLINE_BYTES_LOG - 1 : `SIZE_MEMLINE_BYTES_LOG]] <= 1;
		end
	end
	IPCore_DisRAM_SimplePort #(`L1Depth, `L1Depth_log, `L1TagSize)//多一位valid
		memAccessBundleRamL1(
		  .a(L1TagWriteAddr[`L1Depth_log + `SIZE_MEMLINE_BYTES_LOG - 1 : `SIZE_MEMLINE_BYTES_LOG]),//addr_write
		  .d(L1Tag_i),//din
		  .dpra(L1Index_i),//addr_read
		  .clk(clk),
		  .we(~stall & L1TagWrite),
		  .dpo(L1Tag_o)//dout
		);	

endmodule