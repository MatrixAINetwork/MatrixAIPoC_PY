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
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:02:03 05/12/2013 
// Design Name: 
// Module Name:    timecheck 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`include "GPGPUParam.v"
`include "MemoryParam.v"
`define SIZE_RAM 32
`define SIZE_RAM_LOG 5
`define SIZE_COUNT 16
module TimeCheck(
			input clk,
			input reset,
			input stall,
			
			input DDR3_n_rdy,
			input LSUOut_working,
			input [`SIZE_RAM_LOG - 1 : 0 ] RAM_Addr_L1,
			input [`SIZE_COUNT - 1 : 0] L1HeadOutTime,
			input [`SIZE_COUNT - 1 : 0] L1HeadInTime,
			input [`SIZE_ADDR - 1 : 0] L1FIFOAddrOut,
			
			input [`SIZE_RAM_LOG - 1 : 0 ] RAM_Addr_L2,
			input [`SIZE_COUNT - 1 : 0] L2HeadOutTime,
			input [`SIZE_COUNT - 1 : 0] L2HeadInTime,
			input [`SIZE_ADDR - 1 : 0] L2FIFOAddrOut,
			
			input [`SIZE_RAM_LOG - 1 : 0 ] RAM_Addr_DRAM,
			input [`SIZE_COUNT - 1 : 0] DRAMHeadOutTime,
			input [`SIZE_COUNT - 1 : 0] DRAMHeadInTime,
			input [`SIZE_ADDR - 1 : 0] DRAMFIFOAddrOut,
			
			input [`SIZE_RAM_LOG - 1 : 0 ] RAM_Addr_Shared,
			input [`SIZE_COUNT - 1 : 0] SharedHeadOutTime,
			input [`SIZE_COUNT - 1 : 0] SharedHeadInTime,
			input [`SIZE_ADDR - 1 : 0] SharedFIFOAddrOut,
			
			
			output reg [1:0] FIFO_Out_Type,
			output reg [`SIZE_RAM_LOG - 1 : 0 ] RAM_Out_Addr,
			output reg [`SIZE_ADDR - 1 : 0 ] FIFOAddrOut,
			output RAM_Out,
			output reg [`SIZE_COUNT - 1 : 0] count
);
	reg [1:0] RoundTag;
	
	reg [`SIZE_COUNT - 1 : 0] HeadOutTime1,HeadOutTime2,HeadOutTime3,HeadOutTime4;
	always @ ( * )
	begin
	case(RoundTag)
	2'b00://L1
	begin
		HeadOutTime1 = L1HeadOutTime;
		HeadOutTime2 = L2HeadOutTime;
		HeadOutTime3 = DRAMHeadOutTime;
		HeadOutTime4 = SharedHeadOutTime;	
	end
	2'b01://L2
	begin
		HeadOutTime4 = L1HeadOutTime;
		HeadOutTime1 = L2HeadOutTime;
		HeadOutTime2 = DRAMHeadOutTime;
		HeadOutTime3 = SharedHeadOutTime;	
	end
	2'b10://DRAM
	begin
		HeadOutTime3 = L1HeadOutTime;
		HeadOutTime4 = L2HeadOutTime;
		HeadOutTime1 = DRAMHeadOutTime;
		HeadOutTime2 = SharedHeadOutTime;	
	end
	2'b11://Shared
	begin
		HeadOutTime2 = L1HeadOutTime;
		HeadOutTime3 = L2HeadOutTime;
		HeadOutTime4 = DRAMHeadOutTime;
		HeadOutTime1 = SharedHeadOutTime;		
	end	
	endcase
	end
	always @ ( * )
	begin
	case(FIFO_Out_Type)
	2'b00://L1
	begin
		FIFOAddrOut = L1FIFOAddrOut;
		RAM_Out_Addr = RAM_Addr_L1;	
	end
	2'b01://L2
	begin
		FIFOAddrOut = L2FIFOAddrOut;
		RAM_Out_Addr = RAM_Addr_L2;
	end		
	2'b10://DRAM
	begin
		FIFOAddrOut = DRAMFIFOAddrOut;
		RAM_Out_Addr = RAM_Addr_DRAM;
	end		
	2'b11://Shared
	begin
		FIFOAddrOut = SharedFIFOAddrOut;
		RAM_Out_Addr = RAM_Addr_Shared;	
	end
	endcase
	end
	always @ ( * )
	begin
	if(HeadOutTime1 <= count)
	begin
		FIFO_Out_Type = RoundTag;
	end
	else if(HeadOutTime2 <= count)begin
		FIFO_Out_Type = RoundTag + 1;
	end
	else if(HeadOutTime3 <= count)begin
		FIFO_Out_Type = RoundTag + 2;
	end
	else if(HeadOutTime4 <= count)
		FIFO_Out_Type = RoundTag + 3;
	end
	
	
	assign RAM_Out = ((HeadOutTime1 <= count) | (HeadOutTime2 <= count) | (HeadOutTime3 <= count) | (HeadOutTime4 <= count))& (~LSUOut_working) ;
	
always @ (posedge clk)
	begin
		if(reset)
		begin
			RoundTag <= 0;
			count <= 0;
		end
		else if ( ~stall)
		begin
			count <= count + 1;
			if(RAM_Out)
			begin
				RoundTag <= RoundTag + 1;
			end
		end
	end
endmodule