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

`define L2Size_log 14 //16k bytes = 2^(4 + 10) bytes
`define L2Size_log 16 //512 bytes = 2^(6 + 10) bytes
`define MEMSize_log 28 // 假设总共只有256M bytes的Memory
`define MEMDepth 256 * 1024 * 1024    // 2^(`MEMSize_log - `SIZE_SEGMENT_BYTES�

`define L1Depth_log `L1Size_log - `SIZE_SEGMENT_BYTES_LOG //9
`define L1Depth 512
`define L2Depth_log `L2Size_log - `SIZE_SEGMENT_BYTES_LOG //12
`define L2Depth 16*1024
`define L1TagSize `SIZE_ADDR-`L1Size_log  // 18
`define L2TagSize `SIZE_ADDR-`L2Size_log  // 16
`define L2Delay 1
`define L2Delay 20
`define DRAMDelay 400


module	L2TagUnit(
		input reset,
		input clk,
		input stall,
		input L2TagWrite,
		input [`SIZE_ADDR - 1 : 0 ] L2TagWriteAddr,
		input [`SIZE_CORE_LOG - 1:0] SegNum,			
		input [`SIZE_ADDR-1:0] Coalesce2L1_o,
		
		output [9:0] Delay,
		output L2_HIT
		);
	//wire [`SIZE_ADDR-1:0];
	reg [`L2Depth - 1 : 0] L2Valid;
	reg [`SIZE_ADDR-1:0] Coalesce2L1_o_pre;
	wire [`L2TagSize - 1 : 0 ] L2Tag_i; //多一个valid�
	wire [`L2Depth_log - 1 : 0] L2Index_i;
	wire [`L2TagSize - 1 : 0 ] L2Tag_o;
	
	assign L2_HIT = (Coalesce2L1_o_pre != Coalesce2L1_o) & (L2Valid[L2Index_i] == 1) & 
						(Coalesce2L1_o[`SIZE_ADDR - 1 :`L2Depth_log + `SIZE_MEMLINE_BYTES_LOG] == L2Tag_o[`L2TagSize-1 : 0]);
	assign Delay = L2_HIT?`L2Delay : 0;					
	assign L2Index_i =  Coalesce2L1_o[`L2Depth_log + `SIZE_MEMLINE_BYTES_LOG - 1 : `SIZE_MEMLINE_BYTES_LOG];
	assign L2Tag_i = L2TagWriteAddr[`SIZE_ADDR - 1 :`L2Depth_log + `SIZE_MEMLINE_BYTES_LOG];
	always @ (posedge clk)
	begin
		if(reset)
		begin
			Coalesce2L1_o_pre <= 0;
			L2Valid <= `L2Depth'b0;
		end
		else if(~stall)
		begin			
			Coalesce2L1_o_pre <= Coalesce2L1_o;
			if(L2TagWrite)
				L2Valid [L2TagWriteAddr[`L2Depth_log + `SIZE_MEMLINE_BYTES_LOG - 1 : `SIZE_MEMLINE_BYTES_LOG]] <= 1;
		end
	end
	IPCore_DisRAM_SimplePort #(`L2Depth, `L2Depth_log, `L2TagSize)//多一位valid
		memAccessBundleRamL2(
		  .a(L2TagWriteAddr[`L2Depth_log + `SIZE_MEMLINE_BYTES_LOG - 1 : `SIZE_MEMLINE_BYTES_LOG]),//addr_write
		  .d(L2Tag_i),//din
		  .dpra(L2Index_i),//addr_read
		  .clk(clk),
		  .we(~stall & L2TagWrite),
		  .dpo(L2Tag_o)//dout
		);	

endmodule