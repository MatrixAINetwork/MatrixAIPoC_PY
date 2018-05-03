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

//not configurable yet!!!
module SpeRegController(
		input reset,
		input clk,		
		
		//**Simulator System Parameters**
		input [`SIZE_PREDEFINED-1:0] nctaid_x_i,	//max cta id
		input [`SIZE_PREDEFINED-1:0] nctaid_y_i,
		input [`SIZE_PREDEFINED-1:0] nctaid_z_i,
		input [`SIZE_PREDEFINED-1:0] ntid_x_i,	//max t id
		input [`SIZE_PREDEFINED-1:0] ntid_y_i,
		input [`SIZE_PREDEFINED-1:0] ntid_z_i,
		input [`SIZE_CORE-1:0] simdEnMask_i,
		//**
		
		input [`SIZE_PREDEFINED-1:0] ctaid_x_i,
		input [`SIZE_PREDEFINED-1:0] ctaid_y_i,
		input [`SIZE_PREDEFINED-1:0] ctaid_z_i,
		
		
		input [`NUM_WARP_LOG-1:0] fuWarp_i,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane0_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane1_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane2_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane3_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane4_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane5_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane6_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane7_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane8_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane9_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane10_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane11_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane12_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane13_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane14_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane15_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane16_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane17_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane18_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane19_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane20_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane21_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane22_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane23_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane24_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane25_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane26_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane27_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane28_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane29_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane30_o,
		output [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane31_o
		
		);
		
		//******Predfined Registers******
	wire [`SIZE_PREDEFINED-1:0] ntid_x;
	wire [`SIZE_PREDEFINED-1:0] ntid_y;
	wire [`SIZE_PREDEFINED-1:0] ntid_z;
	assign ntid_x = ntid_x_i;
	assign ntid_y = ntid_y_i;
	assign ntid_z = ntid_z_i;
	
	wire [`SIZE_PREDEFINED-1:0] tid_x [`SIZE_CORE-1:0];
	wire [`SIZE_PREDEFINED-1:0] tid_y [`SIZE_CORE-1:0];
	wire [`SIZE_PREDEFINED-1:0] tid_z [`SIZE_CORE-1:0];
	
	//need to be modified after post-DAC?
	assign tid_x[0] = 0;
	assign tid_y[0] = 0;	//not configurable yet ?
	assign tid_z[0] = 0;			
	
	assign tid_x[1] = 1;
	assign tid_y[1] = 0;
	assign tid_z[1] = 0;
	
	assign tid_x[2] = 2;
	assign tid_y[2] = 0;
	assign tid_z[2] = 0;
	
	assign tid_x[3] = 3;
	assign tid_y[3] = 0;
	assign tid_z[3] = 0;
	
	assign tid_x[4] = 4;
	assign tid_y[4] = 0;
	assign tid_z[4] = 0;
	
	assign tid_x[5] = 5;
	assign tid_y[5] = 0;
	assign tid_z[5] = 0;
	
	assign tid_x[6] = 6;
	assign tid_y[6] = 0;
	assign tid_z[6] = 0;
	
	assign tid_x[7] = 7;
	assign tid_y[7] = 0;
	assign tid_z[7] = 0;
	
	assign tid_x[8] = 8;
	assign tid_y[8] = 0;
	assign tid_z[8] = 0;
	
	assign tid_x[9] = 9;
	assign tid_y[9] = 0;
	assign tid_z[9] = 0;
	
	assign tid_x[10] = 10;
	assign tid_y[10] = 0;	//not configurable yet ?
	assign tid_z[10] = 0;			
	
	assign tid_x[11] = 11;
	assign tid_y[11] = 0;
	assign tid_z[11] = 0;
	
	assign tid_x[12] = 12;
	assign tid_y[12] = 0;
	assign tid_z[12] = 0;
	
	assign tid_x[13] = 13;
	assign tid_y[13] = 0;
	assign tid_z[13] = 0;
	
	assign tid_x[14] = 14;
	assign tid_y[14] = 0;
	assign tid_z[14] = 0;
	
	assign tid_x[15] = 15;
	assign tid_y[15] = 0;
	assign tid_z[15] = 0;
	
	assign tid_x[16] = 16;
	assign tid_y[16] = 0;
	assign tid_z[16] = 0;
	
	assign tid_x[17] = 17;
	assign tid_y[17] = 0;
	assign tid_z[17] = 0;
	
	assign tid_x[18] = 18;
	assign tid_y[18] = 0;
	assign tid_z[18] = 0;
	
	assign tid_x[19] = 19;
	assign tid_y[19] = 0;
	assign tid_z[19] = 0;
	
	assign tid_x[20] = 20;
	assign tid_y[20] = 0;	//not configurable yet ?
	assign tid_z[20] = 0;			
	
	assign tid_x[21] = 21;
	assign tid_y[21] = 0;
	assign tid_z[21] = 0;
	
	assign tid_x[22] = 22;
	assign tid_y[22] = 0;
	assign tid_z[22] = 0;
	
	assign tid_x[23] = 23;
	assign tid_y[23] = 0;
	assign tid_z[23] = 0;
	
	assign tid_x[24] = 24;
	assign tid_y[24] = 0;
	assign tid_z[24] = 0;
	
	assign tid_x[25] = 25;
	assign tid_y[25] = 0;
	assign tid_z[25] = 0;
	
	assign tid_x[26] = 26;
	assign tid_y[26] = 0;
	assign tid_z[26] = 0;
	
	assign tid_x[27] = 27;
	assign tid_y[27] = 0;
	assign tid_z[27] = 0;
	
	assign tid_x[28] = 28;
	assign tid_y[28] = 0;
	assign tid_z[28] = 0;
	
	assign tid_x[29] = 29;
	assign tid_y[29] = 0;
	assign tid_z[29] = 0;
	
	assign tid_x[30] = 30;
	assign tid_y[30] = 0;	
	assign tid_z[30] = 0;			
	
	assign tid_x[31] = 31;
	assign tid_y[31] = 0;
	assign tid_z[31] = 0;
	

	
	assign predefinedPacketLane0_o = {
										tid_x[0],
										tid_y[0],
										tid_z[0],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
	
	assign predefinedPacketLane1_o = {
										tid_x[1],
										tid_y[1],
										tid_z[1],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
	
	assign predefinedPacketLane2_o = {
										tid_x[2],
										tid_y[2],
										tid_z[2],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
										
	assign predefinedPacketLane3_o = {
										tid_x[3],
										tid_y[3],
										tid_z[3],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
										
	assign predefinedPacketLane4_o = {
										tid_x[4],
										tid_y[4],
										tid_z[4],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};									
	
	assign predefinedPacketLane5_o = {
										tid_x[5],
										tid_y[5],
										tid_z[5],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
	
	assign predefinedPacketLane6_o = {
										tid_x[6],
										tid_y[6],
										tid_z[6],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
										
	assign predefinedPacketLane7_o = {
										tid_x[7],
										tid_y[7],
										tid_z[7],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
	
	assign predefinedPacketLane8_o = {
										tid_x[8],
										tid_y[8],
										tid_z[8],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
										
	assign predefinedPacketLane9_o = {
										tid_x[9],
										tid_y[9],
										tid_z[9],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
										
	assign predefinedPacketLane10_o = {
										tid_x[10],
										tid_y[10],
										tid_z[10],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
	
	assign predefinedPacketLane11_o = {
										tid_x[11],
										tid_y[11],
										tid_z[11],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
	
	assign predefinedPacketLane12_o = {
										tid_x[12],
										tid_y[12],
										tid_z[12],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
										
	assign predefinedPacketLane13_o = {
										tid_x[13],
										tid_y[13],
										tid_z[13],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
										
	assign predefinedPacketLane14_o = {
										tid_x[14],
										tid_y[14],
										tid_z[14],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};									
	
	assign predefinedPacketLane15_o = {
										tid_x[15],
										tid_y[15],
										tid_z[15],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
	
	assign predefinedPacketLane16_o = {
										tid_x[16],
										tid_y[16],
										tid_z[16],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
										
	assign predefinedPacketLane17_o = {
										tid_x[17],
										tid_y[17],
										tid_z[17],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
	
	assign predefinedPacketLane18_o = {
										tid_x[18],
										tid_y[18],
										tid_z[18],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
										
	assign predefinedPacketLane19_o = {
										tid_x[19],
										tid_y[19],
										tid_z[19],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
	
	assign predefinedPacketLane20_o = {
										tid_x[20],
										tid_y[20],
										tid_z[20],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
	
	assign predefinedPacketLane21_o = {
										tid_x[21],
										tid_y[21],
										tid_z[21],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
	
	assign predefinedPacketLane22_o = {
										tid_x[22],
										tid_y[22],
										tid_z[22],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
										
	assign predefinedPacketLane23_o = {
										tid_x[23],
										tid_y[23],
										tid_z[23],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
										
	assign predefinedPacketLane24_o = {
										tid_x[24],
										tid_y[24],
										tid_z[24],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};									
	
	assign predefinedPacketLane25_o = {
										tid_x[25],
										tid_y[25],
										tid_z[25],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
	
	assign predefinedPacketLane26_o = {
										tid_x[26],
										tid_y[26],
										tid_z[26],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
										
	assign predefinedPacketLane27_o = {
										tid_x[27],
										tid_y[27],
										tid_z[27],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
	
	assign predefinedPacketLane28_o = {
										tid_x[28],
										tid_y[28],
										tid_z[28],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
										
	assign predefinedPacketLane29_o = {
										tid_x[29],
										tid_y[29],
										tid_z[29],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};

	assign predefinedPacketLane30_o = {
										tid_x[30],
										tid_y[30],
										tid_z[30],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
										
	assign predefinedPacketLane31_o = {
										tid_x[31],
										tid_y[31],
										tid_z[31],
										ntid_x,
										ntid_y,
										ntid_z,
										ctaid_x_i,
										ctaid_y_i,
										ctaid_z_i,
										nctaid_x_i,
										nctaid_y_i,
										nctaid_z_i										
										};
		
endmodule