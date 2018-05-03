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
`define L1Delay 1
`define L2Delay 20
`define DRAMDelay 400
`define RAM_SIZE_LOG 5
module L1L2Pipeline(
		input reset,
		input clk,
		input stall,
		
		input [`SIZE_CORE_LOG - 1:0] SegNum,			
		
		output reg [9:0] Delay
);
	always @ (posedge clk)
	begin
		if(reset)
		begin
			Delay <= 0;
			end
		else if (~stall)
		begin
			Delay <= `DRAMDelay - 1;	
		end
	end
endmodule

module SharedPipeline(
		input reset,
		input clk,
		input stall,
		
		input [`SIZE_CORE_LOG - 1:0] SegNum,			
		
		output reg [9:0] Delay
);
	always @ (posedge clk)
	begin
		if(reset)
		begin
			Delay <= 0;
			end
		else if (~stall)
		begin
			Delay <= 1;	
		end
	end
endmodule