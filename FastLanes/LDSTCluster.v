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

module LDSTCluster(
				input reset,
				input clk,
				
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
				
	reg  [`SIZE_CORE-1:0] ldstMask;
	
	assign ldstPacketValid_o = fuPacketValid_i;		
	assign ldstWarp_o = fuWarp_i;
	
	always @(*) begin
		if(fuPacketValid_i == 1'b1) begin
			ldstMask = fuMask_i;
		end
		else begin
			ldstMask = 0;
		end
	end
	
	
	assign load_o = fuPacketValid_i && fuPacket_i[1+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
					+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1];
	assign store_o = fuPacketValid_i &&fuPacket_i[2+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
					+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1];
	assign ldstSpace_o = fuPacket_i[`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
					+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
					:6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
					+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC];
	
	
	//debug
	wire [`SIZE_PC-1:0] fuPC;
	wire [`SIZE_OPCODE-1:0] fuOpcode;
	assign fuPC = fuPacket_i[`SIZE_PC*3-1:`SIZE_PC*2];
  assign fuOpcode = fuPacket_i[`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1:`SIZE_RP+1+3*`SIZE_PC];
	always @(*)begin
	   		$display("\n fuPacket_i: %b",fuPacket_i);	
	   		$display("\n  fuPC: %d  fuOpcode: %b",fuPC,fuOpcode);	
	end
	//****
	
		
	LDSTLane
		ldstLane0(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[0]),
			.fuPacketLane_i(fuPacketLane0_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[0]),
			.ldstPacketLane_o(ldstPacketLane0_o)	
		);
		
	LDSTLane
		ldstLane1(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[1]),
			.fuPacketLane_i(fuPacketLane1_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[1]),
			.ldstPacketLane_o(ldstPacketLane1_o)	
		);
		
	LDSTLane
		ldstLane2(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[2]),
			.fuPacketLane_i(fuPacketLane2_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[2]),
			.ldstPacketLane_o(ldstPacketLane2_o)	
		);
		
	LDSTLane
		ldstLane3(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[3]),
			.fuPacketLane_i(fuPacketLane3_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[3]),
			.ldstPacketLane_o(ldstPacketLane3_o)	
		);
		
	LDSTLane
		ldstLane4(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[4]),
			.fuPacketLane_i(fuPacketLane4_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[4]),
			.ldstPacketLane_o(ldstPacketLane4_o)	
		);
		
	LDSTLane
		ldstLane5(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[5]),
			.fuPacketLane_i(fuPacketLane5_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[5]),
			.ldstPacketLane_o(ldstPacketLane5_o)	
		);
		
	LDSTLane
		ldstLane6(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[6]),
			.fuPacketLane_i(fuPacketLane6_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[6]),
			.ldstPacketLane_o(ldstPacketLane6_o)	
		);
		
	LDSTLane
		ldstLane7(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[7]),
			.fuPacketLane_i(fuPacketLane7_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[7]),
			.ldstPacketLane_o(ldstPacketLane7_o)	
		);
		
	LDSTLane
		ldstLane8(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[8]),
			.fuPacketLane_i(fuPacketLane8_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[8]),
			.ldstPacketLane_o(ldstPacketLane8_o)	
		);
		
	LDSTLane
		ldstLane9(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[9]),
			.fuPacketLane_i(fuPacketLane9_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[9]),
			.ldstPacketLane_o(ldstPacketLane9_o)	
		);
		
	LDSTLane
		ldstLane10(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[10]),
			.fuPacketLane_i(fuPacketLane10_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[10]),
			.ldstPacketLane_o(ldstPacketLane10_o)	
		);
		
	LDSTLane
		ldstLane11(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[11]),
			.fuPacketLane_i(fuPacketLane11_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[11]),
			.ldstPacketLane_o(ldstPacketLane11_o)	
		);
		
	LDSTLane
		ldstLane12(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[12]),
			.fuPacketLane_i(fuPacketLane12_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[12]),
			.ldstPacketLane_o(ldstPacketLane12_o)	
		);
		
	LDSTLane
		ldstLane13(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[13]),
			.fuPacketLane_i(fuPacketLane13_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[13]),
			.ldstPacketLane_o(ldstPacketLane13_o)	
		);
		
	LDSTLane
		ldstLane14(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[14]),
			.fuPacketLane_i(fuPacketLane14_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[14]),
			.ldstPacketLane_o(ldstPacketLane14_o)	
		);
		
	LDSTLane
		ldstLane15(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[15]),
			.fuPacketLane_i(fuPacketLane15_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[15]),
			.ldstPacketLane_o(ldstPacketLane15_o)	
		);
		
	LDSTLane
		ldstLane16(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[16]),
			.fuPacketLane_i(fuPacketLane16_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[16]),
			.ldstPacketLane_o(ldstPacketLane16_o)	
		);
		
	LDSTLane
		ldstLane17(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[17]),
			.fuPacketLane_i(fuPacketLane17_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[17]),
			.ldstPacketLane_o(ldstPacketLane17_o)	
		);
		
	LDSTLane
		ldstLane18(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[18]),
			.fuPacketLane_i(fuPacketLane18_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[18]),
			.ldstPacketLane_o(ldstPacketLane18_o)	
		);
		
	LDSTLane
		ldstLane19(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[19]),
			.fuPacketLane_i(fuPacketLane19_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[19]),
			.ldstPacketLane_o(ldstPacketLane19_o)	
		);
	
	LDSTLane
		ldstLane20(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[20]),
			.fuPacketLane_i(fuPacketLane20_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[20]),
			.ldstPacketLane_o(ldstPacketLane20_o)	
		);
		
	LDSTLane
		ldstLane21(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[21]),
			.fuPacketLane_i(fuPacketLane21_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[21]),
			.ldstPacketLane_o(ldstPacketLane21_o)	
		);
		
	LDSTLane
		ldstLane22(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[22]),
			.fuPacketLane_i(fuPacketLane22_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[22]),
			.ldstPacketLane_o(ldstPacketLane22_o)	
		);
		
	LDSTLane
		ldstLane23(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[23]),
			.fuPacketLane_i(fuPacketLane23_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[23]),
			.ldstPacketLane_o(ldstPacketLane23_o)	
		);
		
	LDSTLane
		ldstLane24(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[24]),
			.fuPacketLane_i(fuPacketLane24_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[24]),
			.ldstPacketLane_o(ldstPacketLane24_o)	
		);
		
	LDSTLane
		ldstLane25(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[25]),
			.fuPacketLane_i(fuPacketLane25_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[25]),
			.ldstPacketLane_o(ldstPacketLane25_o)	
		);
		
	LDSTLane
		ldstLane26(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[26]),
			.fuPacketLane_i(fuPacketLane26_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[26]),
			.ldstPacketLane_o(ldstPacketLane26_o)	
		);
		
	LDSTLane
		ldstLane27(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[27]),
			.fuPacketLane_i(fuPacketLane27_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[27]),
			.ldstPacketLane_o(ldstPacketLane27_o)	
		);
		
	LDSTLane
		ldstLane28(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[28]),
			.fuPacketLane_i(fuPacketLane28_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[28]),
			.ldstPacketLane_o(ldstPacketLane28_o)	
		);
		
	LDSTLane
		ldstLane29(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[29]),
			.fuPacketLane_i(fuPacketLane29_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[29]),
			.ldstPacketLane_o(ldstPacketLane29_o)	
		);
		
	LDSTLane
		ldstLane30(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[30]),
			.fuPacketLane_i(fuPacketLane30_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[30]),
			.ldstPacketLane_o(ldstPacketLane30_o)	
		);
		
	LDSTLane
		ldstLane31(
			.reset(reset),
			.clk(clk),
			.fuPacketValid_i(fuPacketValid_i),
			.fuPacket_i(fuPacket_i),
			
			.fuPacketLaneValid_i(ldstMask[31]),
			.fuPacketLane_i(fuPacketLane31_i),
			
			.ldstPacketLaneValid_o(ldstMask_o[31]),
			.ldstPacketLane_o(ldstPacketLane31_o)	
		);
	
endmodule
