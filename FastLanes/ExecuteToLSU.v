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

module ExecuteToLSU(	
					input reset,
					input clk,
					
					input load_i,
					input store_i,
					input [`LDST_SPACE_LOG-1:0] ldstSpace_i,
					input [`NUM_WARP_LOG-1:0] ldstWarp_i,
					input ldstPacketValid_i,
					input [`SIZE_CORE-1:0] ldstMask_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane0_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane1_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane2_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane3_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane4_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane5_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane6_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane7_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane8_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane9_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane10_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane11_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane12_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane13_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane14_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane15_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane16_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane17_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane18_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane19_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane20_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane21_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane22_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane23_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane24_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane25_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane26_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane27_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane28_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane29_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane30_i,
					input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane31_i,
					
					input stall_i,
					
					
					output reg load_o,
					output reg store_o,
					output reg [`LDST_SPACE_LOG-1:0] ldstSpace_o,
					output reg [`NUM_WARP_LOG-1:0] ldstWarp_o,
					output reg ldstPacketValid_o,
					output reg [`SIZE_CORE-1:0] ldstMask_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane0_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane1_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane2_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane3_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane4_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane5_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane6_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane7_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane8_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane9_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane10_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane11_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane12_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane13_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane14_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane15_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane16_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane17_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane18_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane19_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane20_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane21_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane22_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane23_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane24_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane25_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane26_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane27_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane28_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane29_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane30_o,
					output reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:0]ldstPacketLane31_o
					);
					
	
	always @(posedge clk) begin
		if(reset) begin
			load_o <= 0;
			store_o <= 0;
			ldstSpace_o <= 0;
			ldstWarp_o <= 0;
			ldstPacketValid_o <= 0;
			ldstMask_o <= 0;
			ldstPacketLane0_o <= 0;
			ldstPacketLane1_o <= 0;
			ldstPacketLane2_o <= 0;
			ldstPacketLane3_o <= 0;
			ldstPacketLane4_o <= 0;
			ldstPacketLane5_o <= 0;
			ldstPacketLane6_o <= 0;
			ldstPacketLane7_o <= 0;
			ldstPacketLane8_o <= 0;
			ldstPacketLane9_o <= 0;
			ldstPacketLane10_o <= 0;
			ldstPacketLane11_o <= 0;
			ldstPacketLane12_o <= 0;
			ldstPacketLane13_o <= 0;
			ldstPacketLane14_o <= 0;
			ldstPacketLane15_o <= 0;
			ldstPacketLane16_o <= 0;
			ldstPacketLane17_o <= 0;
			ldstPacketLane18_o <= 0;
			ldstPacketLane19_o <= 0;
			ldstPacketLane20_o <= 0;
			ldstPacketLane21_o <= 0;
			ldstPacketLane22_o <= 0;
			ldstPacketLane23_o <= 0;
			ldstPacketLane24_o <= 0;
			ldstPacketLane25_o <= 0;
			ldstPacketLane26_o <= 0;
			ldstPacketLane27_o <= 0;
			ldstPacketLane28_o <= 0;
			ldstPacketLane29_o <= 0;
			ldstPacketLane30_o <= 0;
			ldstPacketLane31_o <= 0;			
		end
		else begin
			if(~stall_i) begin
				load_o <= load_i;
				store_o <= store_i;
				ldstSpace_o <= ldstSpace_i;
				ldstWarp_o <= ldstWarp_i;
				ldstPacketValid_o <= ldstPacketValid_i;
				ldstMask_o <= ldstMask_i;
				ldstPacketLane0_o <= ldstPacketLane0_i;
				ldstPacketLane1_o <= ldstPacketLane1_i;
				ldstPacketLane2_o <= ldstPacketLane2_i;
				ldstPacketLane3_o <= ldstPacketLane3_i;
				ldstPacketLane4_o <= ldstPacketLane4_i;
				ldstPacketLane5_o <= ldstPacketLane5_i;
				ldstPacketLane6_o <= ldstPacketLane6_i;
				ldstPacketLane7_o <= ldstPacketLane7_i;
				ldstPacketLane8_o <= ldstPacketLane8_i;
				ldstPacketLane9_o <= ldstPacketLane9_i;
				ldstPacketLane10_o <= ldstPacketLane10_i;
				ldstPacketLane11_o <= ldstPacketLane11_i;
				ldstPacketLane12_o <= ldstPacketLane12_i;
				ldstPacketLane13_o <= ldstPacketLane13_i;
				ldstPacketLane14_o <= ldstPacketLane14_i;
				ldstPacketLane15_o <= ldstPacketLane15_i;
				ldstPacketLane16_o <= ldstPacketLane16_i;
				ldstPacketLane17_o <= ldstPacketLane17_i;
				ldstPacketLane18_o <= ldstPacketLane18_i;
				ldstPacketLane19_o <= ldstPacketLane19_i;
				ldstPacketLane20_o <= ldstPacketLane20_i;
				ldstPacketLane21_o <= ldstPacketLane21_i;
				ldstPacketLane22_o <= ldstPacketLane22_i;
				ldstPacketLane23_o <= ldstPacketLane23_i;
				ldstPacketLane24_o <= ldstPacketLane24_i;
				ldstPacketLane25_o <= ldstPacketLane25_i;
				ldstPacketLane26_o <= ldstPacketLane26_i;
				ldstPacketLane27_o <= ldstPacketLane27_i;
				ldstPacketLane28_o <= ldstPacketLane28_i;
				ldstPacketLane29_o <= ldstPacketLane29_i;
				ldstPacketLane30_o <= ldstPacketLane30_i;
				ldstPacketLane31_o <= ldstPacketLane31_i;
			end
		end	
	end
	
endmodule