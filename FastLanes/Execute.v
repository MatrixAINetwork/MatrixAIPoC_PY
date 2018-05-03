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

module Execute(
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
				
				output [`SIZE_SM_LOG-1:0] intuSM_o,
				output [`NUM_WARP_LOG-1:0] intuWarp_o,
				output intuPacketValid_o,
				output [`SIZE_CORE-1:0] intuMask_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane0_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane1_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane2_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane3_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane4_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane5_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane6_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane7_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane8_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane9_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane10_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane11_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane12_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane13_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane14_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane15_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane16_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane17_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane18_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane19_o,	
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane20_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane21_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane22_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane23_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane24_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane25_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane26_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane27_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane28_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane29_o,	
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane30_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane31_o,
						
				
				output [`NUM_WARP_LOG-1:0] ldstWarp_o,
				output ldstPacketValid_o,
				output load_o,
				output store_o,
				output [`LDST_SPACE_LOG-1:0] ldstSpace_o,
				output [`SIZE_CORE-1:0] ldstMask_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane0_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane1_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane2_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane3_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane4_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane5_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane6_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane7_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane8_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane9_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane10_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane11_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane12_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane13_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane14_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane15_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane16_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane17_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane18_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane19_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane20_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane21_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane22_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane23_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane24_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane25_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane26_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane27_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane28_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane29_o,				
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane30_o,
				output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0]ldstPacketLane31_o
			);
	
	
	assign intuSM_o = fuSM_i;
	
	reg intuValid;
	reg ldstValid;
	reg [`SIZE_CORE-1:0] intuMask;
	reg [`SIZE_CORE-1:0] ldstMask;
	assign intuMask_o = intuMask;
	assign ldstMask_o = ldstMask;
	
	wire [`SIZE_OPCODE-1:0] instOpcode;
	wire instStore;
	wire instLoad;
	wire [`INST_TYPES_LOG-1:0] instFU;
	
	assign instOpcode = fuPacket_i[`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1:`SIZE_RP+1+3*`SIZE_PC];
	
	assign instStore = fuPacket_i[2+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
								+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1] && fuPacketValid_i;
	assign instLoad = fuPacket_i[1+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
								+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1] && fuPacketValid_i;	
	assign instFU = fuPacket_i[`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
								+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1:
								`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
								+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC];
	

	
	
	always @(*) begin:CHOOSE_CLUSTER
		case(instFU) 
			`INSTRUCTION_INT_R: begin
				intuValid 	= fuPacketValid_i;
				intuMask 	= fuMask_i;
				ldstValid 	= 1'b0;
				ldstMask 	= 0;
			end
			
			`INSTRUCTION_FP_R: begin
				intuValid 	= fuPacketValid_i;
				intuMask 	= fuMask_i;
				ldstValid 	= 1'b0;
				ldstMask 	= 0;
			end
			
			`INSTRUCTION_SF_R: begin
				intuValid 	= 1'b0;
				intuMask 	= 0;
				ldstValid 	= 1'b0;
				ldstMask 	= 0;
			end
			
			`INSTRUCTION_INT_I: begin
				intuValid 	= fuPacketValid_i;
				intuMask 	= fuMask_i;
				ldstValid 	= 1'b0;
				ldstMask 	= 0;
			end
			
			`INSTRUCTION_FP_I: begin
				intuValid 	= fuPacketValid_i;
				intuMask 	= fuMask_i;
				ldstValid 	= 1'b0;
				ldstMask 	= 0;
			end
			
			`INSTRUCTION_SF_I: begin
				intuValid 	= 1'b0;
				intuMask 	= 0;
				ldstValid 	= 1'b0;
				ldstMask 	= 0;
			end
			
			`INSTRUCTION_LS: begin
				intuValid 	= 1'b0;
				intuMask 	= 0;
				ldstValid 	= fuPacketValid_i;
				ldstMask 	= fuMask_i;
			end
			
			default: begin
				intuValid 	= 1'b0;
				intuMask 	= 0;
				ldstValid 	= 1'b0;
				ldstMask 	= 0;
			end
			
		endcase
	end
	
	
	INTUCluster 
		intuCluster(
				.reset(reset),
				.clk(clk),
				
				.fuWarp_i(fuWarp_i),
				.fuPacketValid_i(intuValid),
				.fuPacket_i(fuPacket_i),					
				.fuMask_i(intuMask),
				.fuPacketLane0_i(fuPacketLane0_i),
				.fuPacketLane1_i(fuPacketLane1_i),
				.fuPacketLane2_i(fuPacketLane2_i),
				.fuPacketLane3_i(fuPacketLane3_i),
				.fuPacketLane4_i(fuPacketLane4_i),
				.fuPacketLane5_i(fuPacketLane5_i),
				.fuPacketLane6_i(fuPacketLane6_i),
				.fuPacketLane7_i(fuPacketLane7_i),	
				.fuPacketLane8_i(fuPacketLane8_i),
				.fuPacketLane9_i(fuPacketLane9_i),	
				.fuPacketLane10_i(fuPacketLane10_i),
				.fuPacketLane11_i(fuPacketLane11_i),
				.fuPacketLane12_i(fuPacketLane12_i),
				.fuPacketLane13_i(fuPacketLane13_i),
				.fuPacketLane14_i(fuPacketLane14_i),
				.fuPacketLane15_i(fuPacketLane15_i),
				.fuPacketLane16_i(fuPacketLane16_i),
				.fuPacketLane17_i(fuPacketLane17_i),	
				.fuPacketLane18_i(fuPacketLane18_i),
				.fuPacketLane19_i(fuPacketLane19_i),
				.fuPacketLane20_i(fuPacketLane20_i),
				.fuPacketLane21_i(fuPacketLane21_i),
				.fuPacketLane22_i(fuPacketLane22_i),
				.fuPacketLane23_i(fuPacketLane23_i),
				.fuPacketLane24_i(fuPacketLane24_i),
				.fuPacketLane25_i(fuPacketLane25_i),
				.fuPacketLane26_i(fuPacketLane26_i),
				.fuPacketLane27_i(fuPacketLane27_i),	
				.fuPacketLane28_i(fuPacketLane28_i),
				.fuPacketLane29_i(fuPacketLane29_i),	
				.fuPacketLane30_i(fuPacketLane30_i),
				.fuPacketLane31_i(fuPacketLane31_i),

				.intuWarp_o(intuWarp_o),
				.intuPacketValid_o(intuPacketValid_o),
				//.intuMask_o(intuMask_o),
				.intuPacketLane0_o(intuPacketLane0_o),
				.intuPacketLane1_o(intuPacketLane1_o),
				.intuPacketLane2_o(intuPacketLane2_o),
				.intuPacketLane3_o(intuPacketLane3_o),
				.intuPacketLane4_o(intuPacketLane4_o),
				.intuPacketLane5_o(intuPacketLane5_o),
				.intuPacketLane6_o(intuPacketLane6_o),
				.intuPacketLane7_o(intuPacketLane7_o),	
				.intuPacketLane8_o(intuPacketLane8_o),
				.intuPacketLane9_o(intuPacketLane9_o),	
				.intuPacketLane10_o(intuPacketLane10_o),
				.intuPacketLane11_o(intuPacketLane11_o),
				.intuPacketLane12_o(intuPacketLane12_o),
				.intuPacketLane13_o(intuPacketLane13_o),
				.intuPacketLane14_o(intuPacketLane14_o),
				.intuPacketLane15_o(intuPacketLane15_o),
				.intuPacketLane16_o(intuPacketLane16_o),
				.intuPacketLane17_o(intuPacketLane17_o),	
				.intuPacketLane18_o(intuPacketLane18_o),
				.intuPacketLane19_o(intuPacketLane19_o),
				.intuPacketLane20_o(intuPacketLane20_o),
				.intuPacketLane21_o(intuPacketLane21_o),
				.intuPacketLane22_o(intuPacketLane22_o),
				.intuPacketLane23_o(intuPacketLane23_o),
				.intuPacketLane24_o(intuPacketLane24_o),
				.intuPacketLane25_o(intuPacketLane25_o),
				.intuPacketLane26_o(intuPacketLane26_o),
				.intuPacketLane27_o(intuPacketLane27_o),	
				.intuPacketLane28_o(intuPacketLane28_o),
				.intuPacketLane29_o(intuPacketLane29_o),	
				.intuPacketLane30_o(intuPacketLane30_o),
				.intuPacketLane31_o(intuPacketLane31_o)					
				);
		
		
	LDSTCluster 
		ldstCluster(
				.reset(reset),
				.clk(clk),
				
				.fuWarp_i(fuWarp_i),
				.fuPacketValid_i(ldstValid),
				.fuPacket_i(fuPacket_i),					
				.fuMask_i(ldstMask),
				.fuPacketLane0_i(fuPacketLane0_i),
				.fuPacketLane1_i(fuPacketLane1_i),
				.fuPacketLane2_i(fuPacketLane2_i),
				.fuPacketLane3_i(fuPacketLane3_i),
				.fuPacketLane4_i(fuPacketLane4_i),
				.fuPacketLane5_i(fuPacketLane5_i),
				.fuPacketLane6_i(fuPacketLane6_i),
				.fuPacketLane7_i(fuPacketLane7_i),	
				.fuPacketLane8_i(fuPacketLane8_i),
				.fuPacketLane9_i(fuPacketLane9_i),	
				.fuPacketLane10_i(fuPacketLane10_i),
				.fuPacketLane11_i(fuPacketLane11_i),
				.fuPacketLane12_i(fuPacketLane12_i),
				.fuPacketLane13_i(fuPacketLane13_i),
				.fuPacketLane14_i(fuPacketLane14_i),
				.fuPacketLane15_i(fuPacketLane15_i),
				.fuPacketLane16_i(fuPacketLane16_i),
				.fuPacketLane17_i(fuPacketLane17_i),	
				.fuPacketLane18_i(fuPacketLane18_i),
				.fuPacketLane19_i(fuPacketLane19_i),
				.fuPacketLane20_i(fuPacketLane20_i),
				.fuPacketLane21_i(fuPacketLane21_i),
				.fuPacketLane22_i(fuPacketLane22_i),
				.fuPacketLane23_i(fuPacketLane23_i),
				.fuPacketLane24_i(fuPacketLane24_i),
				.fuPacketLane25_i(fuPacketLane25_i),
				.fuPacketLane26_i(fuPacketLane26_i),
				.fuPacketLane27_i(fuPacketLane27_i),	
				.fuPacketLane28_i(fuPacketLane28_i),
				.fuPacketLane29_i(fuPacketLane29_i),	
				.fuPacketLane30_i(fuPacketLane30_i),
				.fuPacketLane31_i(fuPacketLane31_i),			

				.ldstWarp_o(ldstWarp_o),
				.ldstPacketValid_o(ldstPacketValid_o),
				.load_o(load_o),
				.store_o(store_o),
				.ldstSpace_o(ldstSpace_o),
				//.ldstMask_o(ldstMask_o),
				.ldstPacketLane0_o(ldstPacketLane0_o),
				.ldstPacketLane1_o(ldstPacketLane1_o),
				.ldstPacketLane2_o(ldstPacketLane2_o),
				.ldstPacketLane3_o(ldstPacketLane3_o),
				.ldstPacketLane4_o(ldstPacketLane4_o),
				.ldstPacketLane5_o(ldstPacketLane5_o),
				.ldstPacketLane6_o(ldstPacketLane6_o),
				.ldstPacketLane7_o(ldstPacketLane7_o),	
				.ldstPacketLane8_o(ldstPacketLane8_o),
				.ldstPacketLane9_o(ldstPacketLane9_o),	
				.ldstPacketLane10_o(ldstPacketLane10_o),
				.ldstPacketLane11_o(ldstPacketLane11_o),
				.ldstPacketLane12_o(ldstPacketLane12_o),
				.ldstPacketLane13_o(ldstPacketLane13_o),
				.ldstPacketLane14_o(ldstPacketLane14_o),
				.ldstPacketLane15_o(ldstPacketLane15_o),
				.ldstPacketLane16_o(ldstPacketLane16_o),
				.ldstPacketLane17_o(ldstPacketLane17_o),	
				.ldstPacketLane18_o(ldstPacketLane18_o),
				.ldstPacketLane19_o(ldstPacketLane19_o),
				.ldstPacketLane20_o(ldstPacketLane20_o),
				.ldstPacketLane21_o(ldstPacketLane21_o),
				.ldstPacketLane22_o(ldstPacketLane22_o),
				.ldstPacketLane23_o(ldstPacketLane23_o),
				.ldstPacketLane24_o(ldstPacketLane24_o),
				.ldstPacketLane25_o(ldstPacketLane25_o),
				.ldstPacketLane26_o(ldstPacketLane26_o),
				.ldstPacketLane27_o(ldstPacketLane27_o),	
				.ldstPacketLane28_o(ldstPacketLane28_o),
				.ldstPacketLane29_o(ldstPacketLane29_o),	
				.ldstPacketLane30_o(ldstPacketLane30_o),
				.ldstPacketLane31_o(ldstPacketLane31_o)								
				);
			
endmodule