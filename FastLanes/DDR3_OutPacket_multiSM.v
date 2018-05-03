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
`define SIZE_SM_LOG 2
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:43:44 05/20/2013 
// Design Name: 
// Module Name:    DDR3_OutPacket_multiSM 
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
module DDR3_OutPacket_multiSM(
			input clk,
			input reset,
			input stall_i,
			
			input [`SIZE_CORE * `SIZE_ADDR - 1 :0 ] InfoRamAddr_i,
			input [`SIZE_CORE - 1 : 0 ] lane_mask_i,
			input [`NUM_WARP_LOG - 1 :0] RAM2DDR3_ldstWarp_i,
			input [`SIZE_REGFILE_BR - 1 :0] RAM2DDR3_ldstReg_i,
			input load_i,
			input [511:0] dout_i,
			input rdy,				//read ready
			input [`SIZE_SM_LOG-1:0] sm_i,
			
			output reg [`SIZE_REGFILE_BR - 1 : 0] loadWarp_o,
			output reg loadPacketValid_o,
			output reg [`SIZE_CORE - 1 : 0] loadMask_o,		
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane0_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane1_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane2_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane3_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane4_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane5_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane6_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane7_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane8_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane9_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane10_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane11_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane12_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane13_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane14_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane15_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane16_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane17_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane18_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane19_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane20_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane21_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane22_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane23_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane24_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane25_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane26_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane27_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane28_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane29_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane30_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane31_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLaneFirstOne_o,
			output reg DDR3OutPacketWorking_o
    );
	 
	 		wire [`SIZE_REGFILE_BR - 1 : 0] loadWarp_o_sm0;
			wire loadPacketValid_o_sm0;
			wire [`SIZE_CORE - 1 : 0] loadMask_o_sm0;					
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane0_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane1_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane2_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane3_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane4_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane5_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane6_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane7_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane8_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane9_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane10_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane11_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane12_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane13_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane14_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane15_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane16_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane17_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane18_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane19_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane20_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane21_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane22_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane23_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane24_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane25_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane26_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane27_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane28_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane29_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane30_o_sm0;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane31_o_sm0;
	

	
	
	DDR3_OutPacket	
	DDR3_OutPacket_sm0(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i),
			
			.InfoRamAddr_i(InfoRamAddr_i),
			.lane_mask_i(lane_mask_i),
			.RAM2DDR3_ldstWarp_i(RAM2DDR3_ldstWarp_i),
			.RAM2DDR3_ldstReg_i(RAM2DDR3_ldstReg_i),
			.load_i(load_i & (sm_i == 0)),
			.dout_i(dout_i),
			.rdy(rdy),				//read ready
			
			.loadWarp_o(loadWarp_o_sm0),
			.loadPacketValid_o(loadPacketValid_o_sm0),
			.loadMask_o(loadMask_o_sm0),					
			.loadPacketLane0_o(loadPacketLane0_o_sm0),
			.loadPacketLane1_o(loadPacketLane1_o_sm0),
			.loadPacketLane2_o(loadPacketLane2_o_sm0),
			.loadPacketLane3_o(loadPacketLane3_o_sm0),
			.loadPacketLane4_o(loadPacketLane4_o_sm0),
			.loadPacketLane5_o(loadPacketLane5_o_sm0),
			.loadPacketLane6_o(loadPacketLane6_o_sm0),
			.loadPacketLane7_o(loadPacketLane7_o_sm0),
			.loadPacketLane8_o(loadPacketLane8_o_sm0),
			.loadPacketLane9_o(loadPacketLane9_o_sm0),
			.loadPacketLane10_o(loadPacketLane10_o_sm0),
			.loadPacketLane11_o(loadPacketLane11_o_sm0),
			.loadPacketLane12_o(loadPacketLane12_o_sm0),
			.loadPacketLane13_o(loadPacketLane13_o_sm0),
			.loadPacketLane14_o(loadPacketLane14_o_sm0),
			.loadPacketLane15_o(loadPacketLane15_o_sm0),
			.loadPacketLane16_o(loadPacketLane16_o_sm0),
			.loadPacketLane17_o(loadPacketLane17_o_sm0),
			.loadPacketLane18_o(loadPacketLane18_o_sm0),
			.loadPacketLane19_o(loadPacketLane19_o_sm0),
			.loadPacketLane20_o(loadPacketLane20_o_sm0),
			.loadPacketLane21_o(loadPacketLane21_o_sm0),
			.loadPacketLane22_o(loadPacketLane22_o_sm0),
			.loadPacketLane23_o(loadPacketLane23_o_sm0),
			.loadPacketLane24_o(loadPacketLane24_o_sm0),
			.loadPacketLane25_o(loadPacketLane25_o_sm0),
			.loadPacketLane26_o(loadPacketLane26_o_sm0),
			.loadPacketLane27_o(loadPacketLane27_o_sm0),
			.loadPacketLane28_o(loadPacketLane28_o_sm0),
			.loadPacketLane29_o(loadPacketLane29_o_sm0),
			.loadPacketLane30_o(loadPacketLane30_o_sm0),
			.loadPacketLane31_o(loadPacketLane31_o_sm0),
			.working(DDR3OutPacketWorking_sm0)
	);
	
	
	
	
			wire [`SIZE_REGFILE_BR - 1 : 0] loadWarp_o_sm1;
			wire loadPacketValid_o_sm1;
			wire [`SIZE_CORE - 1 : 0] loadMask_o_sm1;					
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane0_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane1_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane2_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane3_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane4_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane5_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane6_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane7_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane8_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane9_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane10_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane11_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane12_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane13_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane14_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane15_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane16_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane17_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane18_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane19_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane20_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane21_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane22_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane23_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane24_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane25_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane26_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane27_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane28_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane29_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane30_o_sm1;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane31_o_sm1;
	

	DDR3_OutPacket	
	DDR3_OutPacket_sm1(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i),
			
			.InfoRamAddr_i(InfoRamAddr_i),
			.lane_mask_i(lane_mask_i),
			.RAM2DDR3_ldstWarp_i(RAM2DDR3_ldstWarp_i),
			.RAM2DDR3_ldstReg_i(RAM2DDR3_ldstReg_i),
			.load_i(load_i & (sm_i == 1)),
			.dout_i(dout_i),
			.rdy(rdy),				//read ready
			
			
			.loadWarp_o(loadWarp_o_sm1),
			.loadPacketValid_o(loadPacketValid_o_sm1),
			.loadMask_o(loadMask_o_sm1),					
			.loadPacketLane0_o(loadPacketLane0_o_sm1),
			.loadPacketLane1_o(loadPacketLane1_o_sm1),
			.loadPacketLane2_o(loadPacketLane2_o_sm1),
			.loadPacketLane3_o(loadPacketLane3_o_sm1),
			.loadPacketLane4_o(loadPacketLane4_o_sm1),
			.loadPacketLane5_o(loadPacketLane5_o_sm1),
			.loadPacketLane6_o(loadPacketLane6_o_sm1),
			.loadPacketLane7_o(loadPacketLane7_o_sm1),
			.loadPacketLane8_o(loadPacketLane8_o_sm1),
			.loadPacketLane9_o(loadPacketLane9_o_sm1),
			.loadPacketLane10_o(loadPacketLane10_o_sm1),
			.loadPacketLane11_o(loadPacketLane11_o_sm1),
			.loadPacketLane12_o(loadPacketLane12_o_sm1),
			.loadPacketLane13_o(loadPacketLane13_o_sm1),
			.loadPacketLane14_o(loadPacketLane14_o_sm1),
			.loadPacketLane15_o(loadPacketLane15_o_sm1),
			.loadPacketLane16_o(loadPacketLane16_o_sm1),
			.loadPacketLane17_o(loadPacketLane17_o_sm1),
			.loadPacketLane18_o(loadPacketLane18_o_sm1),
			.loadPacketLane19_o(loadPacketLane19_o_sm1),
			.loadPacketLane20_o(loadPacketLane20_o_sm1),
			.loadPacketLane21_o(loadPacketLane21_o_sm1),
			.loadPacketLane22_o(loadPacketLane22_o_sm1),
			.loadPacketLane23_o(loadPacketLane23_o_sm1),
			.loadPacketLane24_o(loadPacketLane24_o_sm1),
			.loadPacketLane25_o(loadPacketLane25_o_sm1),
			.loadPacketLane26_o(loadPacketLane26_o_sm1),
			.loadPacketLane27_o(loadPacketLane27_o_sm1),
			.loadPacketLane28_o(loadPacketLane28_o_sm1),
			.loadPacketLane29_o(loadPacketLane29_o_sm1),
			.loadPacketLane30_o(loadPacketLane30_o_sm1),
			.loadPacketLane31_o(loadPacketLane31_o_sm1),
			.working(DDR3OutPacketWorking_sm1)
	);
	
	
	
	
				wire [`SIZE_REGFILE_BR - 1 : 0] loadWarp_o_sm2;
			wire loadPacketValid_o_sm2;
			wire [`SIZE_CORE - 1 : 0] loadMask_o_sm2;					
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane0_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane1_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane2_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane3_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane4_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane5_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane6_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane7_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane8_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane9_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane10_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane11_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane12_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane13_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane14_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane15_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane16_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane17_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane18_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane19_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane20_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane21_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane22_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane23_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane24_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane25_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane26_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane27_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane28_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane29_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane30_o_sm2;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane31_o_sm2;
	

	DDR3_OutPacket
	DDR3_OutPacket_sm2(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i),
			
			.InfoRamAddr_i(InfoRamAddr_i),
			.lane_mask_i(lane_mask_i),
			.RAM2DDR3_ldstWarp_i(RAM2DDR3_ldstWarp_i),
			.RAM2DDR3_ldstReg_i(RAM2DDR3_ldstReg_i),
			.load_i(load_i & (sm_i == 2)),
			.dout_i(dout_i),
			.rdy(rdy),				//read ready
			
			
			.loadWarp_o(loadWarp_o_sm2),
			.loadPacketValid_o(loadPacketValid_o_sm2),
			.loadMask_o(loadMask_o_sm2),					
			.loadPacketLane0_o(loadPacketLane0_o_sm2),
			.loadPacketLane1_o(loadPacketLane1_o_sm2),
			.loadPacketLane2_o(loadPacketLane2_o_sm2),
			.loadPacketLane3_o(loadPacketLane3_o_sm2),
			.loadPacketLane4_o(loadPacketLane4_o_sm2),
			.loadPacketLane5_o(loadPacketLane5_o_sm2),
			.loadPacketLane6_o(loadPacketLane6_o_sm2),
			.loadPacketLane7_o(loadPacketLane7_o_sm2),
			.loadPacketLane8_o(loadPacketLane8_o_sm2),
			.loadPacketLane9_o(loadPacketLane9_o_sm2),
			.loadPacketLane10_o(loadPacketLane10_o_sm2),
			.loadPacketLane11_o(loadPacketLane11_o_sm2),
			.loadPacketLane12_o(loadPacketLane12_o_sm2),
			.loadPacketLane13_o(loadPacketLane13_o_sm2),
			.loadPacketLane14_o(loadPacketLane14_o_sm2),
			.loadPacketLane15_o(loadPacketLane15_o_sm2),
			.loadPacketLane16_o(loadPacketLane16_o_sm2),
			.loadPacketLane17_o(loadPacketLane17_o_sm2),
			.loadPacketLane18_o(loadPacketLane18_o_sm2),
			.loadPacketLane19_o(loadPacketLane19_o_sm2),
			.loadPacketLane20_o(loadPacketLane20_o_sm2),
			.loadPacketLane21_o(loadPacketLane21_o_sm2),
			.loadPacketLane22_o(loadPacketLane22_o_sm2),
			.loadPacketLane23_o(loadPacketLane23_o_sm2),
			.loadPacketLane24_o(loadPacketLane24_o_sm2),
			.loadPacketLane25_o(loadPacketLane25_o_sm2),
			.loadPacketLane26_o(loadPacketLane26_o_sm2),
			.loadPacketLane27_o(loadPacketLane27_o_sm2),
			.loadPacketLane28_o(loadPacketLane28_o_sm2),
			.loadPacketLane29_o(loadPacketLane29_o_sm2),
			.loadPacketLane30_o(loadPacketLane30_o_sm2),
			.loadPacketLane31_o(loadPacketLane31_o_sm2),
			.working(DDR3OutPacketWorking_sm2)
	);
	
	
	
				wire [`SIZE_REGFILE_BR - 1 : 0] loadWarp_o_sm3;
			wire loadPacketValid_o_sm3;
			wire [`SIZE_CORE - 1 : 0] loadMask_o_sm3;					
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane0_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane1_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane2_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane3_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane4_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane5_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane6_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane7_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane8_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane9_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane10_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane11_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane12_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane13_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane14_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane15_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane16_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane17_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane18_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane19_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane20_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane21_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane22_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane23_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane24_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane25_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane26_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane27_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane28_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane29_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane30_o_sm3;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane31_o_sm3;
	

	DDR3_OutPacket
	DDR3_OutPacket_sm3(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i),
			
			.InfoRamAddr_i(InfoRamAddr_i),
			.lane_mask_i(lane_mask_i),
			.RAM2DDR3_ldstWarp_i(RAM2DDR3_ldstWarp_i),
			.RAM2DDR3_ldstReg_i(RAM2DDR3_ldstReg_i),
			.load_i(load_i & (sm_i == 3)),
			.dout_i(dout_i),
			.rdy(rdy),				//read ready
			
			
			.loadWarp_o(loadWarp_o_sm3),
			.loadPacketValid_o(loadPacketValid_o_sm3),
			.loadMask_o(loadMask_o_sm3),					
			.loadPacketLane0_o(loadPacketLane0_o_sm3),
			.loadPacketLane1_o(loadPacketLane1_o_sm3),
			.loadPacketLane2_o(loadPacketLane2_o_sm3),
			.loadPacketLane3_o(loadPacketLane3_o_sm3),
			.loadPacketLane4_o(loadPacketLane4_o_sm3),
			.loadPacketLane5_o(loadPacketLane5_o_sm3),
			.loadPacketLane6_o(loadPacketLane6_o_sm3),
			.loadPacketLane7_o(loadPacketLane7_o_sm3),
			.loadPacketLane8_o(loadPacketLane8_o_sm3),
			.loadPacketLane9_o(loadPacketLane9_o_sm3),
			.loadPacketLane10_o(loadPacketLane10_o_sm3),
			.loadPacketLane11_o(loadPacketLane11_o_sm3),
			.loadPacketLane12_o(loadPacketLane12_o_sm3),
			.loadPacketLane13_o(loadPacketLane13_o_sm3),
			.loadPacketLane14_o(loadPacketLane14_o_sm3),
			.loadPacketLane15_o(loadPacketLane15_o_sm3),
			.loadPacketLane16_o(loadPacketLane16_o_sm3),
			.loadPacketLane17_o(loadPacketLane17_o_sm3),
			.loadPacketLane18_o(loadPacketLane18_o_sm3),
			.loadPacketLane19_o(loadPacketLane19_o_sm3),
			.loadPacketLane20_o(loadPacketLane20_o_sm3),
			.loadPacketLane21_o(loadPacketLane21_o_sm3),
			.loadPacketLane22_o(loadPacketLane22_o_sm3),
			.loadPacketLane23_o(loadPacketLane23_o_sm3),
			.loadPacketLane24_o(loadPacketLane24_o_sm3),
			.loadPacketLane25_o(loadPacketLane25_o_sm3),
			.loadPacketLane26_o(loadPacketLane26_o_sm3),
			.loadPacketLane27_o(loadPacketLane27_o_sm3),
			.loadPacketLane28_o(loadPacketLane28_o_sm3),
			.loadPacketLane29_o(loadPacketLane29_o_sm3),
			.loadPacketLane30_o(loadPacketLane30_o_sm3),
			.loadPacketLane31_o(loadPacketLane31_o_sm3),
			.working(DDR3OutPacketWorking_sm3)
	);
	always @(*)
	begin
	case(sm_i)
	0:begin
			loadWarp_o = loadWarp_o_sm0;
			loadPacketValid_o = loadPacketValid_o_sm0;
			loadMask_o = loadMask_o_sm0;		
			loadPacketLane0_o = loadPacketLane0_o_sm0;
			loadPacketLane1_o = loadPacketLane1_o_sm0;
			loadPacketLane2_o = loadPacketLane2_o_sm0;
			loadPacketLane3_o = loadPacketLane3_o_sm0;
			loadPacketLane4_o = loadPacketLane4_o_sm0;
			loadPacketLane5_o = loadPacketLane5_o_sm0;
			loadPacketLane6_o = loadPacketLane6_o_sm0;
			loadPacketLane7_o = loadPacketLane7_o_sm0;
			loadPacketLane8_o = loadPacketLane8_o_sm0;
			 loadPacketLane9_o = loadPacketLane9_o_sm0;
			 loadPacketLane10_o = loadPacketLane10_o_sm0;
			 loadPacketLane11_o = loadPacketLane11_o_sm0;
			 loadPacketLane12_o = loadPacketLane12_o_sm0;
			 loadPacketLane13_o = loadPacketLane13_o_sm0;
			 loadPacketLane14_o = loadPacketLane14_o_sm0;
			 loadPacketLane15_o = loadPacketLane15_o_sm0;
			 loadPacketLane16_o = loadPacketLane16_o_sm0;
			 loadPacketLane17_o = loadPacketLane17_o_sm0;
			 loadPacketLane18_o = loadPacketLane18_o_sm0;
			 loadPacketLane19_o = loadPacketLane19_o_sm0;
			 loadPacketLane20_o = loadPacketLane20_o_sm0;
			 loadPacketLane21_o = loadPacketLane21_o_sm0;
			 loadPacketLane22_o = loadPacketLane22_o_sm0;
			 loadPacketLane23_o = loadPacketLane23_o_sm0;
			 loadPacketLane24_o = loadPacketLane24_o_sm0;
			 loadPacketLane25_o = loadPacketLane25_o_sm0;
			 loadPacketLane26_o = loadPacketLane26_o_sm0;
			 loadPacketLane27_o = loadPacketLane27_o_sm0;
			 loadPacketLane28_o = loadPacketLane28_o_sm0;
			 loadPacketLane29_o = loadPacketLane29_o_sm0;
			 loadPacketLane30_o = loadPacketLane30_o_sm0;
			 loadPacketLane31_o = loadPacketLane31_o_sm0;
			 DDR3OutPacketWorking_o = DDR3OutPacketWorking_sm0;
	end
	1:begin
			loadWarp_o = loadWarp_o_sm1;
			loadPacketValid_o = loadPacketValid_o_sm1;
			loadMask_o = loadMask_o_sm1;		
			loadPacketLane0_o = loadPacketLane0_o_sm1;
			loadPacketLane1_o = loadPacketLane1_o_sm1;
			loadPacketLane2_o = loadPacketLane2_o_sm1;
			loadPacketLane3_o = loadPacketLane3_o_sm1;
			loadPacketLane4_o = loadPacketLane4_o_sm1;
			loadPacketLane5_o = loadPacketLane5_o_sm1;
			loadPacketLane6_o = loadPacketLane6_o_sm1;
			loadPacketLane7_o = loadPacketLane7_o_sm1;
			loadPacketLane8_o = loadPacketLane8_o_sm1;
			 loadPacketLane9_o = loadPacketLane9_o_sm1;
			 loadPacketLane10_o = loadPacketLane10_o_sm1;
			 loadPacketLane11_o = loadPacketLane11_o_sm1;
			 loadPacketLane12_o = loadPacketLane12_o_sm1;
			 loadPacketLane13_o = loadPacketLane13_o_sm1;
			 loadPacketLane14_o = loadPacketLane14_o_sm1;
			 loadPacketLane15_o = loadPacketLane15_o_sm1;
			 loadPacketLane16_o = loadPacketLane16_o_sm1;
			 loadPacketLane17_o = loadPacketLane17_o_sm1;
			 loadPacketLane18_o = loadPacketLane18_o_sm1;
			 loadPacketLane19_o = loadPacketLane19_o_sm1;
			 loadPacketLane20_o = loadPacketLane20_o_sm1;
			 loadPacketLane21_o = loadPacketLane21_o_sm1;
			 loadPacketLane22_o = loadPacketLane22_o_sm1;
			 loadPacketLane23_o = loadPacketLane23_o_sm1;
			 loadPacketLane24_o = loadPacketLane24_o_sm1;
			 loadPacketLane25_o = loadPacketLane25_o_sm1;
			 loadPacketLane26_o = loadPacketLane26_o_sm1;
			 loadPacketLane27_o = loadPacketLane27_o_sm1;
			 loadPacketLane28_o = loadPacketLane28_o_sm1;
			 loadPacketLane29_o = loadPacketLane29_o_sm1;
			 loadPacketLane30_o = loadPacketLane30_o_sm1;
			 loadPacketLane31_o = loadPacketLane31_o_sm1;
			 DDR3OutPacketWorking_o = DDR3OutPacketWorking_sm1;
	end
	2:begin
			loadWarp_o = loadWarp_o_sm2;
			loadPacketValid_o = loadPacketValid_o_sm2;
			loadMask_o = loadMask_o_sm2;		
			loadPacketLane0_o = loadPacketLane0_o_sm2;
			loadPacketLane1_o = loadPacketLane1_o_sm2;
			loadPacketLane2_o = loadPacketLane2_o_sm2;
			loadPacketLane3_o = loadPacketLane3_o_sm2;
			loadPacketLane4_o = loadPacketLane4_o_sm2;
			loadPacketLane5_o = loadPacketLane5_o_sm2;
			loadPacketLane6_o = loadPacketLane6_o_sm2;
			loadPacketLane7_o = loadPacketLane7_o_sm2;
			loadPacketLane8_o = loadPacketLane8_o_sm2;
			 loadPacketLane9_o = loadPacketLane9_o_sm2;
			 loadPacketLane10_o = loadPacketLane10_o_sm2;
			 loadPacketLane11_o = loadPacketLane11_o_sm2;
			 loadPacketLane12_o = loadPacketLane12_o_sm2;
			 loadPacketLane13_o = loadPacketLane13_o_sm2;
			 loadPacketLane14_o = loadPacketLane14_o_sm2;
			 loadPacketLane15_o = loadPacketLane15_o_sm2;
			 loadPacketLane16_o = loadPacketLane16_o_sm2;
			 loadPacketLane17_o = loadPacketLane17_o_sm2;
			 loadPacketLane18_o = loadPacketLane18_o_sm2;
			 loadPacketLane19_o = loadPacketLane19_o_sm2;
			 loadPacketLane20_o = loadPacketLane20_o_sm2;
			 loadPacketLane21_o = loadPacketLane21_o_sm2;
			 loadPacketLane22_o = loadPacketLane22_o_sm2;
			 loadPacketLane23_o = loadPacketLane23_o_sm2;
			 loadPacketLane24_o = loadPacketLane24_o_sm2;
			 loadPacketLane25_o = loadPacketLane25_o_sm2;
			 loadPacketLane26_o = loadPacketLane26_o_sm2;
			 loadPacketLane27_o = loadPacketLane27_o_sm2;
			 loadPacketLane28_o = loadPacketLane28_o_sm2;
			 loadPacketLane29_o = loadPacketLane29_o_sm2;
			 loadPacketLane30_o = loadPacketLane30_o_sm2;
			 loadPacketLane31_o = loadPacketLane31_o_sm2;
			 DDR3OutPacketWorking_o = DDR3OutPacketWorking_sm2;
	end
	3:begin
			loadWarp_o = loadWarp_o_sm3;
			loadPacketValid_o = loadPacketValid_o_sm3;
			loadMask_o = loadMask_o_sm3;		
			loadPacketLane0_o = loadPacketLane0_o_sm3;
			loadPacketLane1_o = loadPacketLane1_o_sm3;
			loadPacketLane2_o = loadPacketLane2_o_sm3;
			loadPacketLane3_o = loadPacketLane3_o_sm3;
			loadPacketLane4_o = loadPacketLane4_o_sm3;
			loadPacketLane5_o = loadPacketLane5_o_sm3;
			loadPacketLane6_o = loadPacketLane6_o_sm3;
			loadPacketLane7_o = loadPacketLane7_o_sm3;
			loadPacketLane8_o = loadPacketLane8_o_sm3;
			 loadPacketLane9_o = loadPacketLane9_o_sm3;
			 loadPacketLane10_o = loadPacketLane10_o_sm3;
			 loadPacketLane11_o = loadPacketLane11_o_sm3;
			 loadPacketLane12_o = loadPacketLane12_o_sm3;
			 loadPacketLane13_o = loadPacketLane13_o_sm3;
			 loadPacketLane14_o = loadPacketLane14_o_sm3;
			 loadPacketLane15_o = loadPacketLane15_o_sm3;
			 loadPacketLane16_o = loadPacketLane16_o_sm3;
			 loadPacketLane17_o = loadPacketLane17_o_sm3;
			 loadPacketLane18_o = loadPacketLane18_o_sm3;
			 loadPacketLane19_o = loadPacketLane19_o_sm3;
			 loadPacketLane20_o = loadPacketLane20_o_sm3;
			 loadPacketLane21_o = loadPacketLane21_o_sm3;
			 loadPacketLane22_o = loadPacketLane22_o_sm3;
			 loadPacketLane23_o = loadPacketLane23_o_sm3;
			 loadPacketLane24_o = loadPacketLane24_o_sm3;
			 loadPacketLane25_o = loadPacketLane25_o_sm3;
			 loadPacketLane26_o = loadPacketLane26_o_sm3;
			 loadPacketLane27_o = loadPacketLane27_o_sm3;
			 loadPacketLane28_o = loadPacketLane28_o_sm3;
			 loadPacketLane29_o = loadPacketLane29_o_sm3;
			 loadPacketLane30_o = loadPacketLane30_o_sm3;
			 loadPacketLane31_o = loadPacketLane31_o_sm3;
			 DDR3OutPacketWorking_o = DDR3OutPacketWorking_sm3;
		end
	endcase
	end
	wire [`SIZE_ADDR - 1 : 0] FirstOneAddr;
	wire [`SIZE_CORE_LOG - 1 : 0] FirstOne;
	always @(*)
	begin
		case(FirstOne)
		0:loadPacketLaneFirstOne_o = loadPacketLane0_o;
		1:loadPacketLaneFirstOne_o = loadPacketLane1_o;
		2:loadPacketLaneFirstOne_o = loadPacketLane2_o;
		3:loadPacketLaneFirstOne_o = loadPacketLane3_o;
		4:loadPacketLaneFirstOne_o = loadPacketLane4_o;
		5:loadPacketLaneFirstOne_o = loadPacketLane5_o;
		6:loadPacketLaneFirstOne_o = loadPacketLane6_o;
		7:loadPacketLaneFirstOne_o = loadPacketLane7_o;
		8:loadPacketLaneFirstOne_o = loadPacketLane8_o;
		9:loadPacketLaneFirstOne_o = loadPacketLane9_o;
		10:loadPacketLaneFirstOne_o = loadPacketLane10_o;
		11:loadPacketLaneFirstOne_o = loadPacketLane11_o;
		12:loadPacketLaneFirstOne_o = loadPacketLane12_o;
		13:loadPacketLaneFirstOne_o = loadPacketLane13_o;
		14:loadPacketLaneFirstOne_o = loadPacketLane14_o;
		15:loadPacketLaneFirstOne_o = loadPacketLane15_o;
		16:loadPacketLaneFirstOne_o = loadPacketLane16_o;
		17:loadPacketLaneFirstOne_o = loadPacketLane17_o;
		18:loadPacketLaneFirstOne_o = loadPacketLane18_o;
		19:loadPacketLaneFirstOne_o = loadPacketLane19_o;
		20:loadPacketLaneFirstOne_o = loadPacketLane20_o;
		21:loadPacketLaneFirstOne_o = loadPacketLane21_o;
		22:loadPacketLaneFirstOne_o = loadPacketLane22_o;
		23:loadPacketLaneFirstOne_o = loadPacketLane23_o;
		24:loadPacketLaneFirstOne_o = loadPacketLane24_o;
		25:loadPacketLaneFirstOne_o = loadPacketLane25_o;
		26:loadPacketLaneFirstOne_o = loadPacketLane26_o;
		27:loadPacketLaneFirstOne_o = loadPacketLane27_o;
		28:loadPacketLaneFirstOne_o = loadPacketLane28_o;
		29:loadPacketLaneFirstOne_o = loadPacketLane29_o;
		30:loadPacketLaneFirstOne_o = loadPacketLane30_o;
		31:loadPacketLaneFirstOne_o = loadPacketLane31_o;
		endcase
	end
	
	
	wire [`SIZE_CORE - 1 :0] Mask;
	assign Mask = loadMask_o;
		wire [`SIZE_CORE-1:0] Pre;
	assign Pre[0] = Mask[0];
	assign Pre[1] = Mask[1] | Mask[0];
	assign Pre[2] = Mask[2] | Mask[1]| Mask[0];
	assign Pre[3] = Mask[3] | Mask[2]| Mask[1]| Mask[0];
	assign Pre[4] = Mask[4] | Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[5] = Mask[5] | Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[6] = Mask[6] | Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[7] = Mask[7] | Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[8] = Mask[8] | Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[9] = Mask[9] | Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[10] = Mask[10] | Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[11] = Mask[11] | Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[12] = Mask[12] | Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[13] = Mask[13] | Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[14] = Mask[14] | Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[15] = Mask[15] | Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[16] = Mask[16] | Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[17] = Mask[17] | Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[18] = Mask[18] | Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[19] = Mask[19] | Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[20] = Mask[20] | Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[21] = Mask[21] | Mask[20]| Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[22] = Mask[22] | Mask[21]| Mask[20]| Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[23] = Mask[23] | Mask[22]| Mask[21]| Mask[20]| Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[24] = Mask[24] | Mask[23]| Mask[22]| Mask[21]| Mask[20]| Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[25] = Mask[25] | Mask[24]| Mask[23]| Mask[22]| Mask[21]| Mask[20]| Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[26] = Mask[26] | Mask[25]| Mask[24]| Mask[23]| Mask[22]| Mask[21]| Mask[20]| Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[27] = Mask[27] | Mask[26]| Mask[25]| Mask[24]| Mask[23]| Mask[22]| Mask[21]| Mask[20]| Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[28] = Mask[28] | Mask[27]| Mask[26]| Mask[25]| Mask[24]| Mask[23]| Mask[22]| Mask[21]| Mask[20]| Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[29] = Mask[29] | Mask[28]| Mask[27]| Mask[26]| Mask[25]| Mask[24]| Mask[23]| Mask[22]| Mask[21]| Mask[20]| Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[30] = Mask[30] | Mask[29]| Mask[28]| Mask[27]| Mask[26]| Mask[25]| Mask[24]| Mask[23]| Mask[22]| Mask[21]| Mask[20]| Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[31] = Mask[31] | Mask[30]| Mask[29]| Mask[28]| Mask[27]| Mask[26]| Mask[25]| Mask[24]| Mask[23]| Mask[22]| Mask[21]| Mask[20]| Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];

	assign FirstOne = 32-Pre[0]-Pre[1]-Pre[2]-Pre[3]-Pre[4]-Pre[5]-Pre[6]-Pre[7]-Pre[8]-Pre[9]-Pre[10]-Pre[11]-Pre[12]-Pre[13]-Pre[14]-Pre[15]-Pre[16]-Pre[17]-Pre[18]-Pre[19]-Pre[20]-Pre[21]-Pre[22]-Pre[23]-Pre[24]-Pre[25]-Pre[26]-Pre[27]-Pre[28]-Pre[29]-Pre[30]-Pre[31];
	
	FirstAddr firstAddr( 
			.addr0(loadPacketLane0_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr1(loadPacketLane1_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr2(loadPacketLane2_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr3(loadPacketLane3_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr4(loadPacketLane4_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr5(loadPacketLane5_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr6(loadPacketLane6_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr7(loadPacketLane7_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr8(loadPacketLane8_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr9(loadPacketLane9_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr10(loadPacketLane10_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr11(loadPacketLane11_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr12(loadPacketLane12_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr13(loadPacketLane13_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr14(loadPacketLane14_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr15(loadPacketLane15_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr16(loadPacketLane16_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr17(loadPacketLane17_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr18(loadPacketLane18_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr19(loadPacketLane19_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr20(loadPacketLane20_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr21(loadPacketLane21_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr22(loadPacketLane22_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr23(loadPacketLane23_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr24(loadPacketLane24_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr25(loadPacketLane25_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr26(loadPacketLane26_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr27(loadPacketLane27_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr28(loadPacketLane28_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr29(loadPacketLane29_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr30(loadPacketLane30_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.addr31(loadPacketLane31_o[`SIZE_DATA + `SIZE_REGFILE_BR - 1 : `SIZE_REGFILE_BR ]),
			.Mask(Mask),
		.FirstOne(FirstOne),
		.FirstOneAddr(FirstOneAddr),
		.outmask(outmask)
		);	
endmodule
