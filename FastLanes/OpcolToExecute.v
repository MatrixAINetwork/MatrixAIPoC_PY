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

module OpcolToExecute(	
					input reset,
					input clk,
					
					input [`SIZE_SM_LOG-1:0] fuSM_i,
					input [`NUM_WARP_LOG-1:0] fuWarp_i,
					input fuPacketValid_i,
					input [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
						+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
						:0]fuPacket_i,						
					input [`SIZE_CORE-1:0] fuMask_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane0_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane1_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane2_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane3_i,		
					input [3*`SIZE_DATA-1:0] fuPacketLane4_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane5_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane6_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane7_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane8_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane9_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane10_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane11_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane12_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane13_i,		
					input [3*`SIZE_DATA-1:0] fuPacketLane14_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane15_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane16_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane17_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane18_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane19_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane20_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane21_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane22_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane23_i,		
					input [3*`SIZE_DATA-1:0] fuPacketLane24_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane25_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane26_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane27_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane28_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane29_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane30_i,
					input [3*`SIZE_DATA-1:0] fuPacketLane31_i,
				
					input stall_i,
					
				
					output reg [`SIZE_SM_LOG-1:0] fuSM_o,
					output reg [`NUM_WARP_LOG-1:0] fuWarp_o,
					output reg fuPacketValid_o,
					output reg [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
						+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
						:0]fuPacket_o,						
					output reg [`SIZE_CORE-1:0] fuMask_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane0_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane1_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane2_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane3_o,		
					output reg [3*`SIZE_DATA-1:0] fuPacketLane4_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane5_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane6_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane7_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane8_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane9_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane10_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane11_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane12_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane13_o,		
					output reg [3*`SIZE_DATA-1:0] fuPacketLane14_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane15_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane16_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane17_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane18_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane19_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane20_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane21_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane22_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane23_o,		
					output reg [3*`SIZE_DATA-1:0] fuPacketLane24_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane25_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane26_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane27_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane28_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane29_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane30_o,
					output reg [3*`SIZE_DATA-1:0] fuPacketLane31_o
					
										
				);
	
	
	always @(posedge clk) begin
		if(reset) begin
			fuSM_o			<= 0;
			fuWarp_o       	<= 0;
			fuPacketValid_o <= 0;
			fuPacket_o  	<= 0;
			fuMask_o 		<= 0;
			fuPacketLane0_o <= 0;
			fuPacketLane1_o <= 0;
			fuPacketLane2_o <= 0;
			fuPacketLane3_o <= 0;
			fuPacketLane4_o <= 0;
			fuPacketLane5_o <= 0;
			fuPacketLane6_o <= 0;
			fuPacketLane7_o <= 0;
			fuPacketLane8_o <= 0;
			fuPacketLane9_o <= 0;
			fuPacketLane10_o <= 0;
			fuPacketLane11_o <= 0;
			fuPacketLane12_o <= 0;
			fuPacketLane13_o <= 0;
			fuPacketLane14_o <= 0;
			fuPacketLane15_o <= 0;
			fuPacketLane16_o <= 0;
			fuPacketLane17_o <= 0;
			fuPacketLane18_o <= 0;
			fuPacketLane19_o <= 0;
			fuPacketLane20_o <= 0;
			fuPacketLane21_o <= 0;
			fuPacketLane22_o <= 0;
			fuPacketLane23_o <= 0;
			fuPacketLane24_o <= 0;
			fuPacketLane25_o <= 0;
			fuPacketLane26_o <= 0;
			fuPacketLane27_o <= 0;
			fuPacketLane28_o <= 0;
			fuPacketLane29_o <= 0;
			fuPacketLane30_o <= 0;
			fuPacketLane31_o <= 0;
			
		end
		else begin
			if(~stall_i) begin
				fuSM_o			<= fuSM_i;
				fuWarp_o       	<= fuWarp_i;
				fuPacketValid_o <= fuPacketValid_i;
				fuPacket_o  	<= fuPacket_i;
				fuMask_o 		<= fuMask_i;
				fuPacketLane0_o <= fuPacketLane0_i;
				fuPacketLane1_o <= fuPacketLane1_i;
				fuPacketLane2_o <= fuPacketLane2_i;
				fuPacketLane3_o <= fuPacketLane3_i;
				fuPacketLane4_o <= fuPacketLane4_i;
				fuPacketLane5_o <= fuPacketLane5_i;
				fuPacketLane6_o <= fuPacketLane6_i;
				fuPacketLane7_o <= fuPacketLane7_i;
				fuPacketLane8_o <= fuPacketLane8_i;
				fuPacketLane9_o <= fuPacketLane9_i;
				fuPacketLane10_o <= fuPacketLane10_i;
				fuPacketLane11_o <= fuPacketLane11_i;
				fuPacketLane12_o <= fuPacketLane12_i;
				fuPacketLane13_o <= fuPacketLane13_i;
				fuPacketLane14_o <= fuPacketLane14_i;
				fuPacketLane15_o <= fuPacketLane15_i;
				fuPacketLane16_o <= fuPacketLane16_i;
				fuPacketLane17_o <= fuPacketLane17_i;
				fuPacketLane18_o <= fuPacketLane18_i;
				fuPacketLane19_o <= fuPacketLane19_i;
				fuPacketLane20_o <= fuPacketLane20_i;
				fuPacketLane21_o <= fuPacketLane21_i;
				fuPacketLane22_o <= fuPacketLane22_i;
				fuPacketLane23_o <= fuPacketLane23_i;
				fuPacketLane24_o <= fuPacketLane24_i;
				fuPacketLane25_o <= fuPacketLane25_i;
				fuPacketLane26_o <= fuPacketLane26_i;
				fuPacketLane27_o <= fuPacketLane27_i;
				fuPacketLane28_o <= fuPacketLane28_i;
				fuPacketLane29_o <= fuPacketLane29_i;
				fuPacketLane30_o <= fuPacketLane30_i;
				fuPacketLane31_o <= fuPacketLane31_i;
			end
		end	
	end
	
endmodule
