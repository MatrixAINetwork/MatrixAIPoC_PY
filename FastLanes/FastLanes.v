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

module FastLanes(
				input clkX4,
				input reset,
				
				output [`SIZE_SIMULATION-1:0] tot_real_cycle_o,
				output [`SIZE_SIMULATION-1:0] tot_sim_cycle_o,
				output [`SIZE_SIMULATION-1:0] tot_sim_insn_si_o,
				output [`SIZE_SIMULATION-1:0] tot_sim_insn_md_o,
				
				output [`SIZE_PREDEFINED-1:0] ctaid_x_o,
				output [`SIZE_PREDEFINED-1:0] ctaid_y_o,
				output [`SIZE_PREDEFINED-1:0] ctaid_z_o,
				
				output [`SIZE_PC-1:0] issuedPC_o,
				output [`SIZE_CORE-1:0] issuedMask_o,
				
				output [5:0] euqa_o
				
					);

	reg clk;
	//reg clkX4;
	reg [1:0] clkPhase;
	//reg reset;
	
	wire [`SIZE_SM_LOG-1:0] nSM;	//if 4 then 
	wire [`SIZE_GRAN-1:0] granu;
	wire [`SIZE_SM_LOG-1:0] sm;
	
	assign nSM = 2'b11;
	assign granu = 4*30;	//change
	
	//**system parameters
	wire [`SIZE_PREDEFINED-1:0] nctaid_x;
	wire [`SIZE_PREDEFINED-1:0] nctaid_y;
	wire [`SIZE_PREDEFINED-1:0] nctaid_z;	
	wire [`SIZE_PREDEFINED-1:0] ntid_x;
	wire [`SIZE_PREDEFINED-1:0] ntid_y;
	wire [`SIZE_PREDEFINED-1:0] ntid_z;
	wire [`NUM_WARP_LOG-1:0] nctaSM;	//if 4 ,then 4-1 = 2'b11
	wire [`NUM_WARP-1:0] ctaEnMask;
	wire [`SIZE_CORE_LOG-1:0] nlaneSM;	//if 8 ,then 8-1 = 3'b111
	wire [`SIZE_CORE-1:0] simdEnMask;
	
	assign nctaid_x = 3;
	assign nctaid_y = 4;
	assign nctaid_z = 2;	
	assign ntid_x = 8;
	assign ntid_y = 1;
	assign ntid_z = 1;
	assign nctaSM = 2'b11;
	assign ctaEnMask = 4'b1111;
	assign nlaneSM = 3'b111;
	assign simdEnMask = -1;
	
	wire [`SIZE_PREDEFINED-1:0] ctaid_x;
	wire [`SIZE_PREDEFINED-1:0] ctaid_y;
	wire [`SIZE_PREDEFINED-1:0] ctaid_z;
	
	//**simulation reg**
	reg [`SIZE_SIMULATION-1:0] tot_real_cycle;
	reg [`SIZE_SIMULATION-1:0] tot_sim_cycle;
	reg [`SIZE_SIMULATION-1:0] tot_sim_insn_si;
	reg [`SIZE_SIMULATION-1:0] tot_sim_insn_md;
	//reg [`SIZE_SIMULATION-1:0] tot_ipc;// = tot_sim_insn_md / tot_sim_cycle
	//reg [`SIZE_SIMULATION-1:0] simu_eff;// = tot_sim_cycle / tot_real_cycle
	reg [`SIZE_SIMULATION-1:0] tot_sim_si_intu;
	//reg [`SIZE_SIMULATION-1:0] tot_sim_insn_fpu;
	//reg [`SIZE_SIMULATION-1:0] tot_sim_insn_sfu;
	reg [`SIZE_SIMULATION-1:0] tot_sim_si_load;
	reg [`SIZE_SIMULATION-1:0] tot_sim_si_store;
	reg [`SIZE_SIMULATION-1:0] tot_sim_si_bra;
	reg [`SIZE_SIMULATION-1:0] tot_sim_si_sync;
	reg [`SIZE_SIMULATION-1:0] tot_sim_md_intu;
	//reg [`SIZE_SIMULATION-1:0] tot_sim_md_fpu;
	//reg [`SIZE_SIMULATION-1:0] tot_sim_md_sfu;
	reg [`SIZE_SIMULATION-1:0] tot_sim_md_load;
	reg [`SIZE_SIMULATION-1:0] tot_sim_md_store;
	//****

	
	wire stallRun;
	
	wire [`SIZE_SM_LOG-1:0] issuedSM;
	assign issuedSM = sm;
	wire [`NUM_WARP_LOG-1:0] issuedWarp;
	wire [`SIZE_PC-1:0] issuedPC;
	wire [`SIZE_OPCODE-1:0] issuedOpcode;
	wire issuebranch;
	wire issuedPacketValid;
	wire [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
				+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
				:0] issuedPacket;							
	wire [`SIZE_CORE-1:0] issuedMask;
	
	
	
	
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane0;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane1;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane2;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane3;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane4;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane5;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane6;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane7;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane8;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane9;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane10;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane11;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane12;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane13;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane14;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane15;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane16;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane17;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane18;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane19;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane20;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane21;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane22;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane23;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane24;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane25;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane26;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane27;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane28;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane29;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane30;
	wire [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane31;
	//**
	wire [`SIZE_SM_LOG-1:0] fuSM;
	wire [`NUM_WARP_LOG-1:0] fuWarp;
	wire [`SIZE_PC-1:0] fuPC;
	wire [`SIZE_OPCODE-1:0] fuOpcode;
	wire fuPacketValid;
	wire [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
		+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
		:0]fuPacket;						
	wire [`SIZE_CORE-1:0] fuMask;
	wire [3*`SIZE_DATA-1:0] fuPacketLane0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane2;
	wire [3*`SIZE_DATA-1:0] fuPacketLane3;
	wire [3*`SIZE_DATA-1:0] fuPacketLane4;
	wire [3*`SIZE_DATA-1:0] fuPacketLane5;
	wire [3*`SIZE_DATA-1:0] fuPacketLane6;
	wire [3*`SIZE_DATA-1:0] fuPacketLane7;
	wire [3*`SIZE_DATA-1:0] fuPacketLane8;
	wire [3*`SIZE_DATA-1:0] fuPacketLane9;
	wire [3*`SIZE_DATA-1:0] fuPacketLane10;
	wire [3*`SIZE_DATA-1:0] fuPacketLane11;
	wire [3*`SIZE_DATA-1:0] fuPacketLane12;
	wire [3*`SIZE_DATA-1:0] fuPacketLane13;
	wire [3*`SIZE_DATA-1:0] fuPacketLane14;
	wire [3*`SIZE_DATA-1:0] fuPacketLane15;
	wire [3*`SIZE_DATA-1:0] fuPacketLane16;
	wire [3*`SIZE_DATA-1:0] fuPacketLane17;
	wire [3*`SIZE_DATA-1:0] fuPacketLane18;
	wire [3*`SIZE_DATA-1:0] fuPacketLane19;
	wire [3*`SIZE_DATA-1:0] fuPacketLane20;
	wire [3*`SIZE_DATA-1:0] fuPacketLane21;
	wire [3*`SIZE_DATA-1:0] fuPacketLane22;
	wire [3*`SIZE_DATA-1:0] fuPacketLane23;
	wire [3*`SIZE_DATA-1:0] fuPacketLane24;
	wire [3*`SIZE_DATA-1:0] fuPacketLane25;
	wire [3*`SIZE_DATA-1:0] fuPacketLane26;
	wire [3*`SIZE_DATA-1:0] fuPacketLane27;
	wire [3*`SIZE_DATA-1:0] fuPacketLane28;
	wire [3*`SIZE_DATA-1:0] fuPacketLane29;
	wire [3*`SIZE_DATA-1:0] fuPacketLane30;
	wire [3*`SIZE_DATA-1:0] fuPacketLane31;
		//-
	/*wire [`NUM_WARP_LOG-1:0] fuWarp_l1;
	wire fuPacketValid_l1;
	wire [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
		+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
		:0]fuPacket_l1;						
	wire [`SIZE_CORE-1:0] fuMask_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane0_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane1_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane2_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane3_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane4_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane5_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane6_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane7_l1;*/
	//**
	wire [`SIZE_SM_LOG-1:0] intuSM;
	wire [`NUM_WARP_LOG-1:0] intuWarp;
	wire intuPacketValid;
	wire [`SIZE_PC-1:0] intuPC;
	wire [`SIZE_OPCODE-1:0] intuOpcode;
	wire [`SIZE_CORE-1:0] intuMask;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane0;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane1;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane2;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane3;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane4;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane5;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane6;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane7;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane8;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane9;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane10;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane11;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane12;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane13;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane14;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane15;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane16;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane17;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane18;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane19;	
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane20;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane21;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane22;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane23;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane24;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane25;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane26;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane27;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane28;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane29;	
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane30;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane31;
	
	wire load;
	wire store;
	wire [`NUM_WARP_LOG-1:0] ldstWarp;
	wire ldstPacketValid;
	wire [`SIZE_CORE-1:0] ldstMask;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane0;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane2;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane3;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane4;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane5;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane6;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane7;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane8;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane9;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane10;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane11;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane12;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane13;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane14;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane15;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane16;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane17;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane18;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane19;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane20;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane21;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane22;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane23;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane24;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane25;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane26;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane27;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane28;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane29;				
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane30;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane31;
								
	//-
	/*wire load_l1;
	wire store_l1;
	wire [`NUM_WARP_LOG-1:0] ldstWarp_l1;
	wire ldstPacketValid_l1;
	wire [`SIZE_CORE-1:0] ldstMask_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane0_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane1_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane2_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane3_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane4_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane5_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane6_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane7_l1;
	**/					
					
	
	wire [`NUM_WARP_LOG-1:0] loadWarp;
	wire loadPacketValid;
	wire [`SIZE_CORE-1:0] loadMask;					
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane0;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane1;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane2;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane3;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane4;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane5;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane6;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane7;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane8;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane9;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane10;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane11;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane12;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane13;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane14;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane15;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane16;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane17;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane18;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane19;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane20;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane21;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane22;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane23;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane24;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane25;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane26;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane27;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane28;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane29;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane30;
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane31;
	//???
	
	wire freeze;
	
	
	
	//pipeline buffer wires
	wire [`NUM_WARP_LOG-1:0] instWarp_l1;
	wire instPacket0Valid_l1;
	wire instPacket1Valid_l1;
	wire [`SIZE_INSTRUCTION+`SIZE_PC-1:0] instPacket0_l1;
	wire [`SIZE_INSTRUCTION+`SIZE_PC-1:0] instPacket1_l1;
	
	wire [`SIZE_SM_LOG-1:0] issuedSM_l1;
	wire [`NUM_WARP_LOG-1:0] issuedWarp_l1;
	wire issuedPacketValid_l1;
	wire [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
				+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
				:0] issuedPacket_l1;						
	wire [`SIZE_CORE-1:0] issuedMask_l1;
	
	wire [`SIZE_SM_LOG-1:0] fuSM_l1;
	wire [`NUM_WARP_LOG-1:0] fuWarp_l1;
	wire fuPacketValid_l1;
	wire [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
		+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
		:0]fuPacket_l1;						
	wire [`SIZE_CORE-1:0] fuMask_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane0_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane1_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane2_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane3_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane4_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane5_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane6_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane7_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane8_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane9_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane10_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane11_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane12_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane13_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane14_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane15_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane16_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane17_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane18_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane19_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane20_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane21_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane22_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane23_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane24_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane25_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane26_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane27_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane28_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane29_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane30_l1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane31_l1;
	
	wire load_l1;
	wire store_l1;
	wire [`NUM_WARP_LOG-1:0] ldstWarp_l1;
	wire ldstPacketValid_l1;
	wire [`SIZE_CORE-1:0] ldstMask_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane0_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane1_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane2_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane3_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane4_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane5_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane6_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane7_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane8_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane9_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane10_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane11_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane12_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane13_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane14_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane15_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane16_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane17_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane18_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane19_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane20_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane21_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane22_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane23_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane24_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane25_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane26_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane27_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane28_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane29_l1;				
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane30_l1;
	wire [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
					:0]ldstPacketLane31_l1;
	
	
	
	wire reconv;
	
	wire issuedSync;
	wire issuedExit;
	/*~Issue ouput*/
	
	/*Cache wire*/
	wire [`SIZE_INSTRUCTION-1:0] instruction0;
	wire [`SIZE_INSTRUCTION-1:0] instruction1;
	wire [`SIZE_PC-1:0] PC;
	wire [`SIZE_PC-1:0] PCadd1;
	/*~Cache wire*/
	
	wire [`SIZE_CORE-1:0] predMask;
	wire [`SIZE_PC-1:0] branchTarget;
	wire [`SIZE_PC-1:0] branchReconv;
	wire [`SIZE_PC-1:0] branchPC;	
	
	wire pushInStack_stall;
	wire branch;
	wire kernelStall;
	wire kernelDone;
	
	
	
	
	
	wire rdRdy;
	wire wrRdy;
	wire rotateValid;
	wire [512-1:0] rotateDinBundle;
	wire [512-1:0] rotateDoutBundle;	
	wire [`SIZE_SM_LOG+1+`REGFILE_BR_INDEX-1:0] rotateMemOffset;
	wire rotateDone;

	
	/*
	Distributed RAM (Dual Port RAM)
	Depth: 512
	Data Width: 64
	Coe: code.coe
	*/
   IPCore_DisRAM_PyseudoRom #(`ROM_DEPTH, `ROM_DEPTH_LOG, `SIZE_INSTRUCTION)
	//IPCore_DisRAM_ROM
		instRom(
		  .a(PC[`ROM_DEPTH_LOG-1:0]), // .[8 : 0] PC0
		  .d(64'b0), // .[63 : 0] == 64'b0
		  .dpra(PCadd1[`ROM_DEPTH_LOG-1:0]), // .[8 : 0] PC1
		  .clk(clk), // .clk
		  .we(1'b0), // .we		== 1'b0
		  .spo(instruction0), // output [63 : 0] instruction0
		  .dpo(instruction1) // output [63 : 0] instruction1
		);  
	
				
	SMScheduler
		smScheduler(
				.reset(reset),
				.clk(clk),
		
				.stall_i(1'b0),
				
				.nSM_i(nSM),
				.granu_i(granu),
				.swapDone_i(rotateDone),
				.branch_i(branch),
				.issuebranch_i(issuebranch),
				.reconv_i(reconv),
				
				.sm_o(sm),
				.stallRun_o(stallRun)
	);

	FrontEnd_MultiSM
		frontEnd_MultiSM(
				.reset(reset),
				.clk(clk),		
				.clkX4(clkX4),
				.clkPhase(clkPhase),
				
				.sm_i(sm),
				
				.stall_i(stallRun),
				.freeze_i(freeze),
				
				/*system parameters*/
				.nctaid_x_i(nctaid_x),
				.nctaid_y_i(nctaid_y),
				.nctaid_z_i(nctaid_z),	
				.ntid_x_i(ntid_x),
				.ntid_y_i(ntid_y),
				.ntid_z_i(ntid_z),
				.nctaSM_i(nctaSM),	//if 4 _i,then 4-1 = 2'b11
				.ctaEnMask_i(ctaEnMask),
				.nlaneSM_i(nlaneSM),	//if 8 _i,then 8-1 = 3'b111
				.simdEnMask_i(simdEnMask),
				/*~system parameters*/
				
				.fuWarp_i(fuWarp),
				
				/*interface with Cache*/
				.instruction0_i(instruction0),
				.instruction1_i(instruction1),
				/*~interface with Cache*/
				
				/*intu Commit*/
				.intuWarp_i(intuWarp),
				.intuPacketValid_i(intuPacketValid),
				.intuMask_i(intuMask),
				.intuPacketLane0_i(intuPacketLane0),
				/*~intu Commit*/
				
				/*Load Commit*/
				.loadWarp_i(loadWarp),
				.loadPacketValid_i(loadPacketValid),
				.loadMask_i(loadMask),
				.loadPacketLane0_i(loadPacketLane0),
				/*~Load Commit*/
				
				/*OpCol to SIMT_Stack*/
				.issuedWarp_l1_i(issuedWarp_l1),
				.branch_i(branch),
				.predMask_i(predMask),
				.branchTarget_i(branchTarget),
				.branchReconv_i(branchReconv),
				.branchPC_i(branchPC),
				/*~OpCol to SIMT_Stack*/
				
				
				.intuSM_i(intuSM),
				
				
				/*Issue ouput*/
				.issuedWarp_o(issuedWarp),
				.issuedPacketValid_o(issuedPacketValid),
				.issuedPacket_o(issuedPacket),							
				.issuedMask_o(issuedMask),
				
				.reconv_o(reconv),
				
				.issuedSync_o(issuedSync),
				.issuedExit_o(issuedExit),
				/*~Issue ouput*/
				
				/*Cache output*/
				.PC_o(PC),
				.PCadd1_o(PCadd1),
				/*~Cache output*/
				
				.ctaid_x_o(ctaid_x),
				.ctaid_y_o(ctaid_y),
				.ctaid_z_o(ctaid_z),				
				
				.pushInStack_stall_o(pushInStack_stall),
				.kernelStall_o(kernelStall),
				.kernelDone_o(kernelDone)
				
		);
	
				
	IssueToOpcol
		issueToOpcol(	
					.reset(reset),
					.clk(clk),
					
					.issuedSM_i(issuedSM),
					.issuedWarp_i(issuedWarp),
					.issuedPacketValid_i(issuedPacketValid),
					.issuedPacket_i(issuedPacket),							
					.issuedMask_i(issuedMask),
					
					.flush_i(1'b0),
					.flushWarp_i(),
					.stall_i(kernelStall || (~pushInStack_stall && branch)),
					
					.issuedSM_o(issuedSM_l1),
					.issuedWarp_o(issuedWarp_l1),
					.issuedPacketValid_o(issuedPacketValid_l1),
					.issuedPacket_o(issuedPacket_l1),							
					.issuedMask_o(issuedMask_l1)
					);
	
	SpeRegController
		speRegController(
			.reset(reset),//Front-End restarts when current cta exits.
			.clk(clk),
			
			.nctaid_x_i(nctaid_x),
			.nctaid_y_i(nctaid_y),
			.nctaid_z_i(nctaid_z),
			.ntid_x_i(ntid_x),
			.ntid_y_i(ntid_y),
			.ntid_z_i(ntid_z),
			.simdEnMask_i(simdEnMask),
			
			.ctaid_x_i(ctaid_x),
			.ctaid_y_i(ctaid_y),
			.ctaid_z_i(ctaid_z),
			
			.fuWarp_i(fuWarp),
			.predefinedPacketLane0_o(predefinedPacketLane0),
			.predefinedPacketLane1_o(predefinedPacketLane1),
			.predefinedPacketLane2_o(predefinedPacketLane2),
			.predefinedPacketLane3_o(predefinedPacketLane3),
			.predefinedPacketLane4_o(predefinedPacketLane4),
			.predefinedPacketLane5_o(predefinedPacketLane5),
			.predefinedPacketLane6_o(predefinedPacketLane6),
			.predefinedPacketLane7_o(predefinedPacketLane7),
			.predefinedPacketLane8_o(predefinedPacketLane8),
			.predefinedPacketLane9_o(predefinedPacketLane9),
			.predefinedPacketLane10_o(predefinedPacketLane10),
			.predefinedPacketLane11_o(predefinedPacketLane11),
			.predefinedPacketLane12_o(predefinedPacketLane12),
			.predefinedPacketLane13_o(predefinedPacketLane13),
			.predefinedPacketLane14_o(predefinedPacketLane14),
			.predefinedPacketLane15_o(predefinedPacketLane15),
			.predefinedPacketLane16_o(predefinedPacketLane16),
			.predefinedPacketLane17_o(predefinedPacketLane17),
			.predefinedPacketLane18_o(predefinedPacketLane18),
			.predefinedPacketLane19_o(predefinedPacketLane19),
			.predefinedPacketLane20_o(predefinedPacketLane20),
			.predefinedPacketLane21_o(predefinedPacketLane21),
			.predefinedPacketLane22_o(predefinedPacketLane22),
			.predefinedPacketLane23_o(predefinedPacketLane23),
			.predefinedPacketLane24_o(predefinedPacketLane24),
			.predefinedPacketLane25_o(predefinedPacketLane25),
			.predefinedPacketLane26_o(predefinedPacketLane26),
			.predefinedPacketLane27_o(predefinedPacketLane27),
			.predefinedPacketLane28_o(predefinedPacketLane28),
			.predefinedPacketLane29_o(predefinedPacketLane29),
			.predefinedPacketLane30_o(predefinedPacketLane30),
			.predefinedPacketLane31_o(predefinedPacketLane31)			
			);  
			
	OperandCollector_rotate
		operandCollector_rotate(
						.reset(reset),
						.clk(clk),
						.clkX4(clkX4),
						.clkPhase(clkPhase),
						
						.stall_i(1'b0),
						
						.issuedSM_i(issuedSM_l1),
						.issuedWarp_i(issuedWarp_l1),	//set SIMD width
						.issuedPacketValid_i(issuedPacketValid_l1),
						.issuedPacket_i(issuedPacket_l1),
						.issuedMask_i(issuedMask_l1 & simdEnMask),
						

						.predefinedPacketLane0_i(predefinedPacketLane0),
						.predefinedPacketLane1_i(predefinedPacketLane1),
						.predefinedPacketLane2_i(predefinedPacketLane2),
						.predefinedPacketLane3_i(predefinedPacketLane3),
						.predefinedPacketLane4_i(predefinedPacketLane4),
						.predefinedPacketLane5_i(predefinedPacketLane5),
						.predefinedPacketLane6_i(predefinedPacketLane6),
						.predefinedPacketLane7_i(predefinedPacketLane7),
						.predefinedPacketLane8_i(predefinedPacketLane8),
						.predefinedPacketLane9_i(predefinedPacketLane9),
						.predefinedPacketLane10_i(predefinedPacketLane10),
						.predefinedPacketLane11_i(predefinedPacketLane11),
						.predefinedPacketLane12_i(predefinedPacketLane12),
						.predefinedPacketLane13_i(predefinedPacketLane13),
						.predefinedPacketLane14_i(predefinedPacketLane14),
						.predefinedPacketLane15_i(predefinedPacketLane15),
						.predefinedPacketLane16_i(predefinedPacketLane16),
						.predefinedPacketLane17_i(predefinedPacketLane17),
						.predefinedPacketLane18_i(predefinedPacketLane18),
						.predefinedPacketLane19_i(predefinedPacketLane19),
						.predefinedPacketLane20_i(predefinedPacketLane20),
						.predefinedPacketLane21_i(predefinedPacketLane21),
						.predefinedPacketLane22_i(predefinedPacketLane22),
						.predefinedPacketLane23_i(predefinedPacketLane23),
						.predefinedPacketLane24_i(predefinedPacketLane24),
						.predefinedPacketLane25_i(predefinedPacketLane25),
						.predefinedPacketLane26_i(predefinedPacketLane26),
						.predefinedPacketLane27_i(predefinedPacketLane27),
						.predefinedPacketLane28_i(predefinedPacketLane28),
						.predefinedPacketLane29_i(predefinedPacketLane29),
						.predefinedPacketLane30_i(predefinedPacketLane30),
						.predefinedPacketLane31_i(predefinedPacketLane31),
			
						//.intuPacket_i(),
						.intuWarp_i(intuWarp),
						.intuMask_i(intuMask),
						.intuPacketLane0_i(intuPacketLane0),
						.intuPacketLane1_i(intuPacketLane1),
						.intuPacketLane2_i(intuPacketLane2),
						.intuPacketLane3_i(intuPacketLane3),
						.intuPacketLane4_i(intuPacketLane4),
						.intuPacketLane5_i(intuPacketLane5),
						.intuPacketLane6_i(intuPacketLane6),
						.intuPacketLane7_i(intuPacketLane7),
						.intuPacketLane8_i(intuPacketLane8),
						.intuPacketLane9_i(intuPacketLane9),
						.intuPacketLane10_i(intuPacketLane10),
						.intuPacketLane11_i(intuPacketLane11),
						.intuPacketLane12_i(intuPacketLane12),
						.intuPacketLane13_i(intuPacketLane13),
						.intuPacketLane14_i(intuPacketLane14),
						.intuPacketLane15_i(intuPacketLane15),
						.intuPacketLane16_i(intuPacketLane16),
						.intuPacketLane17_i(intuPacketLane17),
						.intuPacketLane18_i(intuPacketLane18),
						.intuPacketLane19_i(intuPacketLane19),
						.intuPacketLane20_i(intuPacketLane20),
						.intuPacketLane21_i(intuPacketLane21),
						.intuPacketLane22_i(intuPacketLane22),
						.intuPacketLane23_i(intuPacketLane23),
						.intuPacketLane24_i(intuPacketLane24),
						.intuPacketLane25_i(intuPacketLane25),
						.intuPacketLane26_i(intuPacketLane26),
						.intuPacketLane27_i(intuPacketLane27),
						.intuPacketLane28_i(intuPacketLane28),
						.intuPacketLane29_i(intuPacketLane29),
						.intuPacketLane30_i(intuPacketLane30),
						.intuPacketLane31_i(intuPacketLane31),
						
						.loadWarp_i(loadWarp),
						.loadMask_i(loadMask),					
						.loadPacketLane0_i(loadPacketLane0),
						.loadPacketLane1_i(loadPacketLane1),
						.loadPacketLane2_i(loadPacketLane2),
						.loadPacketLane3_i(loadPacketLane3),
						.loadPacketLane4_i(loadPacketLane4),
						.loadPacketLane5_i(loadPacketLane5),
						.loadPacketLane6_i(loadPacketLane6),
						.loadPacketLane7_i(loadPacketLane7),
						/*
						.loadPacketLane8_i(loadPacketLane8),
						.loadPacketLane9_i(loadPacketLane9),
						.loadPacketLane10_i(loadPacketLane10),
						.loadPacketLane11_i(loadPacketLane11),
						.loadPacketLane12_i(loadPacketLane12),
						.loadPacketLane13_i(loadPacketLane13),
						.loadPacketLane14_i(loadPacketLane14),
						.loadPacketLane15_i(loadPacketLane15),
						.loadPacketLane16_i(loadPacketLane16),
						.loadPacketLane17_i(loadPacketLane17),
						.loadPacketLane18_i(loadPacketLane18),
						.loadPacketLane19_i(loadPacketLane19),
						.loadPacketLane20_i(loadPacketLane20),
						.loadPacketLane21_i(loadPacketLane21),
						.loadPacketLane22_i(loadPacketLane22),
						.loadPacketLane23_i(loadPacketLane23),
						.loadPacketLane24_i(loadPacketLane24),
						.loadPacketLane25_i(loadPacketLane25),
						.loadPacketLane26_i(loadPacketLane26),
						.loadPacketLane27_i(loadPacketLane27),
						.loadPacketLane28_i(loadPacketLane28),
						.loadPacketLane29_i(loadPacketLane29),
						.loadPacketLane30_i(loadPacketLane30),
						.loadPacketLane31_i(loadPacketLane31),
						*/
						.loadPacketLane8_i(loadPacketLane0), //???
						.loadPacketLane9_i(loadPacketLane0),
						.loadPacketLane10_i(loadPacketLane0),
						.loadPacketLane11_i(loadPacketLane0),
						.loadPacketLane12_i(loadPacketLane0),
						.loadPacketLane13_i(loadPacketLane0),
						.loadPacketLane14_i(loadPacketLane0),
						.loadPacketLane15_i(loadPacketLane0),
						.loadPacketLane16_i(loadPacketLane0),
						.loadPacketLane17_i(loadPacketLane0),
						.loadPacketLane18_i(loadPacketLane0),
						.loadPacketLane19_i(loadPacketLane0),
						.loadPacketLane20_i(loadPacketLane0),
						.loadPacketLane21_i(loadPacketLane0),
						.loadPacketLane22_i(loadPacketLane0),
						.loadPacketLane23_i(loadPacketLane0),
						.loadPacketLane24_i(loadPacketLane0),
						.loadPacketLane25_i(loadPacketLane0),
						.loadPacketLane26_i(loadPacketLane0),
						.loadPacketLane27_i(loadPacketLane0),
						.loadPacketLane28_i(loadPacketLane0),
						.loadPacketLane29_i(loadPacketLane0),
						.loadPacketLane30_i(loadPacketLane0),
						.loadPacketLane31_i(loadPacketLane0),
						
						.fuSM_o(fuSM),
						.fuWarp_o(fuWarp),
						.fuPacketValid_o(fuPacketValid),
						.fuPacket_o(fuPacket),
						
						.fuMask_o(fuMask),
						.fuPacketLane0_o(fuPacketLane0),
						.fuPacketLane1_o(fuPacketLane1),
						.fuPacketLane2_o(fuPacketLane2),
						.fuPacketLane3_o(fuPacketLane3),
						.fuPacketLane4_o(fuPacketLane4),
						.fuPacketLane5_o(fuPacketLane5),
						.fuPacketLane6_o(fuPacketLane6),
						.fuPacketLane7_o(fuPacketLane7),
						.fuPacketLane8_o(fuPacketLane8),
						.fuPacketLane9_o(fuPacketLane9),
						.fuPacketLane10_o(fuPacketLane10),
						.fuPacketLane11_o(fuPacketLane11),
						.fuPacketLane12_o(fuPacketLane12),
						.fuPacketLane13_o(fuPacketLane13),
						.fuPacketLane14_o(fuPacketLane14),
						.fuPacketLane15_o(fuPacketLane15),
						.fuPacketLane16_o(fuPacketLane16),
						.fuPacketLane17_o(fuPacketLane17),
						.fuPacketLane18_o(fuPacketLane18),
						.fuPacketLane19_o(fuPacketLane19),
						.fuPacketLane20_o(fuPacketLane20),
						.fuPacketLane21_o(fuPacketLane21),
						.fuPacketLane22_o(fuPacketLane22),
						.fuPacketLane23_o(fuPacketLane23),
						.fuPacketLane24_o(fuPacketLane24),
						.fuPacketLane25_o(fuPacketLane25),
						.fuPacketLane26_o(fuPacketLane26),
						.fuPacketLane27_o(fuPacketLane27),
						.fuPacketLane28_o(fuPacketLane28),
						.fuPacketLane29_o(fuPacketLane29),
						.fuPacketLane30_o(fuPacketLane30),
						.fuPacketLane31_o(fuPacketLane31),
						
						.branch_o(branch),
						.predMask_o(predMask),
						.branchTarget_o(branchTarget),
						.branchReconv_o(branchReconv),
						.branchPC_o(branchPC),
						
						.rdRdy_i(1'b1),
						.wrRdy_i(1'b1),
						.rotateValid_i(1'b1),
						.mem2oc_o(mem2oc),
						.rotateMemOffset_o(rotateMemOffset),
						.rotateDinBundle_i(rotateDinBundle),
						.rotateDoutBundle_o(rotateDoutBundle),	
						.rotateDone_o(rotateDone)
				);
	
						
	OpcolToExecute
		opcolToExecute(	
					.reset(reset),
					.clk(clk),
					
					.fuSM_i(fuSM),
					.fuWarp_i(fuWarp),
					.fuPacketValid_i(fuPacketValid),
					.fuPacket_i(fuPacket),					
					.fuMask_i(fuMask),
					.fuPacketLane0_i(fuPacketLane0),
					.fuPacketLane1_i(fuPacketLane1),
					.fuPacketLane2_i(fuPacketLane2),
					.fuPacketLane3_i(fuPacketLane3),
					.fuPacketLane4_i(fuPacketLane4),
					.fuPacketLane5_i(fuPacketLane5),
					.fuPacketLane6_i(fuPacketLane6),
					.fuPacketLane7_i(fuPacketLane7),
					.fuPacketLane8_i(fuPacketLane8),
					.fuPacketLane9_i(fuPacketLane9),
					.fuPacketLane10_i(fuPacketLane10),
					.fuPacketLane11_i(fuPacketLane11),
					.fuPacketLane12_i(fuPacketLane12),
					.fuPacketLane13_i(fuPacketLane13),
					.fuPacketLane14_i(fuPacketLane14),
					.fuPacketLane15_i(fuPacketLane15),
					.fuPacketLane16_i(fuPacketLane16),
					.fuPacketLane17_i(fuPacketLane17),
					.fuPacketLane18_i(fuPacketLane18),
					.fuPacketLane19_i(fuPacketLane19),
					.fuPacketLane20_i(fuPacketLane20),
					.fuPacketLane21_i(fuPacketLane21),
					.fuPacketLane22_i(fuPacketLane22),
					.fuPacketLane23_i(fuPacketLane23),
					.fuPacketLane24_i(fuPacketLane24),
					.fuPacketLane25_i(fuPacketLane25),
					.fuPacketLane26_i(fuPacketLane26),
					.fuPacketLane27_i(fuPacketLane27),
					.fuPacketLane28_i(fuPacketLane28),
					.fuPacketLane29_i(fuPacketLane29),
					.fuPacketLane30_i(fuPacketLane30),
					.fuPacketLane31_i(fuPacketLane31),					
				
					.stall_i(kernelStall || (~pushInStack_stall && branch)),
					
					.fuSM_o(fuSM_l1),
					.fuWarp_o(fuWarp_l1),
					.fuPacketValid_o(fuPacketValid_l1),
					.fuPacket_o(fuPacket_l1),					
					.fuMask_o(fuMask_l1),
					.fuPacketLane0_o(fuPacketLane0_l1),
					.fuPacketLane1_o(fuPacketLane1_l1),
					.fuPacketLane2_o(fuPacketLane2_l1),
					.fuPacketLane3_o(fuPacketLane3_l1),
					.fuPacketLane4_o(fuPacketLane4_l1),
					.fuPacketLane5_o(fuPacketLane5_l1),
					.fuPacketLane6_o(fuPacketLane6_l1),
					.fuPacketLane7_o(fuPacketLane7_l1),
					.fuPacketLane8_o(fuPacketLane8_l1),
					.fuPacketLane9_o(fuPacketLane9_l1),
					.fuPacketLane10_o(fuPacketLane10_l1),
					.fuPacketLane11_o(fuPacketLane11_l1),
					.fuPacketLane12_o(fuPacketLane12_l1),
					.fuPacketLane13_o(fuPacketLane13_l1),
					.fuPacketLane14_o(fuPacketLane14_l1),
					.fuPacketLane15_o(fuPacketLane15_l1),
					.fuPacketLane16_o(fuPacketLane16_l1),
					.fuPacketLane17_o(fuPacketLane17_l1),
					.fuPacketLane18_o(fuPacketLane18_l1),
					.fuPacketLane19_o(fuPacketLane19_l1),
					.fuPacketLane20_o(fuPacketLane20_l1),
					.fuPacketLane21_o(fuPacketLane21_l1),
					.fuPacketLane22_o(fuPacketLane22_l1),
					.fuPacketLane23_o(fuPacketLane23_l1),
					.fuPacketLane24_o(fuPacketLane24_l1),
					.fuPacketLane25_o(fuPacketLane25_l1),
					.fuPacketLane26_o(fuPacketLane26_l1),
					.fuPacketLane27_o(fuPacketLane27_l1),
					.fuPacketLane28_o(fuPacketLane28_l1),
					.fuPacketLane29_o(fuPacketLane29_l1),
					.fuPacketLane30_o(fuPacketLane30_l1),
					.fuPacketLane31_o(fuPacketLane31_l1)					
				);
				
			
	Execute
	   execute(
				.reset(reset),
				.clk(clk),
				
				.fuSM_i(fuSM_l1),
				.fuWarp_i(fuWarp_l1),
				.fuPacketValid_i(fuPacketValid_l1),
				.fuPacket_i(fuPacket_l1),					
				.fuMask_i(fuMask_l1),
				.fuPacketLane0_i(fuPacketLane0_l1),
				.fuPacketLane1_i(fuPacketLane1_l1),
				.fuPacketLane2_i(fuPacketLane2_l1),
				.fuPacketLane3_i(fuPacketLane3_l1),
				.fuPacketLane4_i(fuPacketLane4_l1),
				.fuPacketLane5_i(fuPacketLane5_l1),
				.fuPacketLane6_i(fuPacketLane6_l1),
				.fuPacketLane7_i(fuPacketLane7_l1),
				.fuPacketLane8_i(fuPacketLane8_l1),
				.fuPacketLane9_i(fuPacketLane9_l1),
				.fuPacketLane10_i(fuPacketLane10_l1),
				.fuPacketLane11_i(fuPacketLane11_l1),
				.fuPacketLane12_i(fuPacketLane12_l1),
				.fuPacketLane13_i(fuPacketLane13_l1),
				.fuPacketLane14_i(fuPacketLane14_l1),
				.fuPacketLane15_i(fuPacketLane15_l1),
				.fuPacketLane16_i(fuPacketLane16_l1),
				.fuPacketLane17_i(fuPacketLane17_l1),
				.fuPacketLane18_i(fuPacketLane18_l1),
				.fuPacketLane19_i(fuPacketLane19_l1),
				.fuPacketLane20_i(fuPacketLane20_l1),
				.fuPacketLane21_i(fuPacketLane21_l1),
				.fuPacketLane22_i(fuPacketLane22_l1),
				.fuPacketLane23_i(fuPacketLane23_l1),
				.fuPacketLane24_i(fuPacketLane24_l1),
				.fuPacketLane25_i(fuPacketLane25_l1),
				.fuPacketLane26_i(fuPacketLane26_l1),
				.fuPacketLane27_i(fuPacketLane27_l1),
				.fuPacketLane28_i(fuPacketLane28_l1),
				.fuPacketLane29_i(fuPacketLane29_l1),
				.fuPacketLane30_i(fuPacketLane30_l1),
				.fuPacketLane31_i(fuPacketLane31_l1),

				.intuSM_o(intuSM),
				.intuWarp_o(intuWarp),
				.intuPacketValid_o(intuPacketValid),
				.intuMask_o(intuMask),
				.intuPacketLane0_o(intuPacketLane0),
				.intuPacketLane1_o(intuPacketLane1),
				.intuPacketLane2_o(intuPacketLane2),
				.intuPacketLane3_o(intuPacketLane3),
				.intuPacketLane4_o(intuPacketLane4),
				.intuPacketLane5_o(intuPacketLane5),
				.intuPacketLane6_o(intuPacketLane6),
				.intuPacketLane7_o(intuPacketLane7),
				.intuPacketLane8_o(intuPacketLane8),
				.intuPacketLane9_o(intuPacketLane9),
				.intuPacketLane10_o(intuPacketLane10),
				.intuPacketLane11_o(intuPacketLane11),
				.intuPacketLane12_o(intuPacketLane12),
				.intuPacketLane13_o(intuPacketLane13),
				.intuPacketLane14_o(intuPacketLane14),
				.intuPacketLane15_o(intuPacketLane15),
				.intuPacketLane16_o(intuPacketLane16),
				.intuPacketLane17_o(intuPacketLane17),
				.intuPacketLane18_o(intuPacketLane18),
				.intuPacketLane19_o(intuPacketLane19),
				.intuPacketLane20_o(intuPacketLane20),
				.intuPacketLane21_o(intuPacketLane21),
				.intuPacketLane22_o(intuPacketLane22),
				.intuPacketLane23_o(intuPacketLane23),
				.intuPacketLane24_o(intuPacketLane24),
				.intuPacketLane25_o(intuPacketLane25),
				.intuPacketLane26_o(intuPacketLane26),
				.intuPacketLane27_o(intuPacketLane27),
				.intuPacketLane28_o(intuPacketLane28),
				.intuPacketLane29_o(intuPacketLane29),
				.intuPacketLane30_o(intuPacketLane30),
				.intuPacketLane31_o(intuPacketLane31),
				
				.ldstWarp_o(ldstWarp),
				.ldstPacketValid_o(ldstPacketValid),
				.load_o(load),
				.store_o(store),
				.ldstMask_o(ldstMask),
				.ldstPacketLane0_o(ldstPacketLane0),
				.ldstPacketLane1_o(ldstPacketLane1),
				.ldstPacketLane2_o(ldstPacketLane2),
				.ldstPacketLane3_o(ldstPacketLane3),
				.ldstPacketLane4_o(ldstPacketLane4),
				.ldstPacketLane5_o(ldstPacketLane5),
				.ldstPacketLane6_o(ldstPacketLane6),
				.ldstPacketLane7_o(ldstPacketLane7),	
				.ldstPacketLane8_o(ldstPacketLane8),
				.ldstPacketLane9_o(ldstPacketLane9),	
				.ldstPacketLane10_o(ldstPacketLane10),
				.ldstPacketLane11_o(ldstPacketLane11),
				.ldstPacketLane12_o(ldstPacketLane12),
				.ldstPacketLane13_o(ldstPacketLane13),
				.ldstPacketLane14_o(ldstPacketLane14),
				.ldstPacketLane15_o(ldstPacketLane15),
				.ldstPacketLane16_o(ldstPacketLane16),
				.ldstPacketLane17_o(ldstPacketLane17),	
				.ldstPacketLane18_o(ldstPacketLane18),
				.ldstPacketLane19_o(ldstPacketLane19),
				.ldstPacketLane20_o(ldstPacketLane20),
				.ldstPacketLane21_o(ldstPacketLane21),
				.ldstPacketLane22_o(ldstPacketLane22),
				.ldstPacketLane23_o(ldstPacketLane23),
				.ldstPacketLane24_o(ldstPacketLane24),
				.ldstPacketLane25_o(ldstPacketLane25),
				.ldstPacketLane26_o(ldstPacketLane26),
				.ldstPacketLane27_o(ldstPacketLane27),	
				.ldstPacketLane28_o(ldstPacketLane28),
				.ldstPacketLane29_o(ldstPacketLane29),
				.ldstPacketLane30_o(ldstPacketLane30),
				.ldstPacketLane31_o(ldstPacketLane31)		
				);
				
	ExecuteToLSU
		executeToLSU(
					.reset(reset),
					.clk(clk),
					
					.load_i(load),
					.store_i(store),
					.ldstWarp_i(ldstWarp),
					.ldstPacketValid_i(ldstPacketValid),
					.ldstMask_i(ldstMask),
					.ldstPacketLane0_i(ldstPacketLane0),
					.ldstPacketLane1_i(ldstPacketLane1),
					.ldstPacketLane2_i(ldstPacketLane2),
					.ldstPacketLane3_i(ldstPacketLane3),
					.ldstPacketLane4_i(ldstPacketLane4),
					.ldstPacketLane5_i(ldstPacketLane5),
					.ldstPacketLane6_i(ldstPacketLane6),
					.ldstPacketLane7_i(ldstPacketLane7),
					.ldstPacketLane8_i(ldstPacketLane8),
					.ldstPacketLane9_i(ldstPacketLane9),
					.ldstPacketLane10_i(ldstPacketLane10),
					.ldstPacketLane11_i(ldstPacketLane11),
					.ldstPacketLane12_i(ldstPacketLane12),
					.ldstPacketLane13_i(ldstPacketLane13),
					.ldstPacketLane14_i(ldstPacketLane14),
					.ldstPacketLane15_i(ldstPacketLane15),
					.ldstPacketLane16_i(ldstPacketLane16),
					.ldstPacketLane17_i(ldstPacketLane17),
					.ldstPacketLane18_i(ldstPacketLane18),
					.ldstPacketLane19_i(ldstPacketLane19),
					.ldstPacketLane20_i(ldstPacketLane20),
					.ldstPacketLane21_i(ldstPacketLane21),
					.ldstPacketLane22_i(ldstPacketLane22),
					.ldstPacketLane23_i(ldstPacketLane23),
					.ldstPacketLane24_i(ldstPacketLane24),
					.ldstPacketLane25_i(ldstPacketLane25),
					.ldstPacketLane26_i(ldstPacketLane26),
					.ldstPacketLane27_i(ldstPacketLane27),
					.ldstPacketLane28_i(ldstPacketLane28),
					.ldstPacketLane29_i(ldstPacketLane29),
					.ldstPacketLane30_i(ldstPacketLane30),
					.ldstPacketLane31_i(ldstPacketLane31),
					
					.stall_i(kernelStall || (~pushInStack_stall && branch)),
					
					
					.load_o(load_l1),
					.store_o(store_l1),
					.ldstWarp_o(ldstWarp_l1),
					.ldstPacketValid_o(ldstPacketValid_l1),
					.ldstMask_o(ldstMask_l1),
					.ldstPacketLane0_o(ldstPacketLane0_l1),
					.ldstPacketLane1_o(ldstPacketLane1_l1),
					.ldstPacketLane2_o(ldstPacketLane2_l1),
					.ldstPacketLane3_o(ldstPacketLane3_l1),
					.ldstPacketLane4_o(ldstPacketLane4_l1),
					.ldstPacketLane5_o(ldstPacketLane5_l1),
					.ldstPacketLane6_o(ldstPacketLane6_l1),
					.ldstPacketLane7_o(ldstPacketLane7_l1),
					.ldstPacketLane8_o(ldstPacketLane8_l1),
					.ldstPacketLane9_o(ldstPacketLane9_l1),
					.ldstPacketLane10_o(ldstPacketLane10_l1),
					.ldstPacketLane11_o(ldstPacketLane11_l1),
					.ldstPacketLane12_o(ldstPacketLane12_l1),
					.ldstPacketLane13_o(ldstPacketLane13_l1),
					.ldstPacketLane14_o(ldstPacketLane14_l1),
					.ldstPacketLane15_o(ldstPacketLane15_l1),
					.ldstPacketLane16_o(ldstPacketLane16_l1),
					.ldstPacketLane17_o(ldstPacketLane17_l1),
					.ldstPacketLane18_o(ldstPacketLane18_l1),
					.ldstPacketLane19_o(ldstPacketLane19_l1),
					.ldstPacketLane20_o(ldstPacketLane20_l1),
					.ldstPacketLane21_o(ldstPacketLane21_l1),
					.ldstPacketLane22_o(ldstPacketLane22_l1),
					.ldstPacketLane23_o(ldstPacketLane23_l1),
					.ldstPacketLane24_o(ldstPacketLane24_l1),
					.ldstPacketLane25_o(ldstPacketLane25_l1),
					.ldstPacketLane26_o(ldstPacketLane26_l1),
					.ldstPacketLane27_o(ldstPacketLane27_l1),
					.ldstPacketLane28_o(ldstPacketLane28_l1),
					.ldstPacketLane29_o(ldstPacketLane29_l1),
					.ldstPacketLane30_o(ldstPacketLane30_l1),
					.ldstPacketLane31_o(ldstPacketLane31_l1)
					);
	
	LoadStoreUnit
	   loadStoreUnit(
					.reset(reset),
					.clk(clk),
					
					.stall_i(kernelStall || (~pushInStack_stall && branch)),
					
					.load_i(load_l1),
					.store_i(store_l1),
					.ldstWarp_i(ldstWarp_l1),
					.ldstPacketValid_i(ldstPacketValid_l1),
					.ldstMask_i(ldstMask_l1),
					.ldstPacketLane0_i(ldstPacketLane0_l1),
					.ldstPacketLane1_i(ldstPacketLane1_l1),
					.ldstPacketLane2_i(ldstPacketLane2_l1),
					.ldstPacketLane3_i(ldstPacketLane3_l1),
					.ldstPacketLane4_i(ldstPacketLane4_l1),
					.ldstPacketLane5_i(ldstPacketLane5_l1),
					.ldstPacketLane6_i(ldstPacketLane6_l1),
					.ldstPacketLane7_i(ldstPacketLane7_l1),
										
					
					.loadWarp_o(loadWarp),
					.loadPacketValid_o(loadPacketValid),
					.loadMask_o(loadMask),					
					.loadPacketLane0_o(loadPacketLane0),
					.loadPacketLane1_o(loadPacketLane1),
					.loadPacketLane2_o(loadPacketLane2),
					.loadPacketLane3_o(loadPacketLane3),
					.loadPacketLane4_o(loadPacketLane4),
					.loadPacketLane5_o(loadPacketLane5),
					.loadPacketLane6_o(loadPacketLane6),
					.loadPacketLane7_o(loadPacketLane7),
					
					.freeze_o(freeze)
					
					//output
					);
	

  
  
  
  //****Simulation Signal****
	wire [`SIZE_CORE_LOG+1-1:0] issuedMask_tot;
	wire [`SIZE_CORE_LOG+1-1:0] intuMask_tot;
	wire [`SIZE_CORE_LOG+1-1:0] ldstMask_tot;
	assign issuedMask_tot = issuedMask[0] + issuedMask[1] + issuedMask[2] + issuedMask[3]
							+ issuedMask[4] + issuedMask[5] + issuedMask[6] + issuedMask[7];
							
	assign intuMask_tot = intuMask[0] + intuMask[1] + intuMask[2] + intuMask[3]
							+ intuMask[4] + intuMask[5] + intuMask[6] + intuMask[7];
							
	assign ldstMask_tot = ldstMask[0] + ldstMask[1] + ldstMask[2] + ldstMask[3]
							+ ldstMask[4] + ldstMask[5] + ldstMask[6] + ldstMask[7];						
	
  
  
  
  
  

  
  
  
  //**clock X 4 operation**
  always@(posedge clkX4) begin
	if(reset) begin
		clkPhase <= 2'b00;
	end
	else begin
		clkPhase <= clkPhase + 1;
	end
  end
  
  always@(*) begin
	if(clkPhase[1] == 1'b0) clk = 1;	// clkX4 = 2'b00 or 2'b01
	else clk = 0;							// clkX4 = 2'b10 or 2'b11
  end
  
  //********
	assign tot_real_cycle_o = tot_real_cycle;
	assign tot_sim_cycle_o = tot_sim_cycle;
	assign tot_sim_insn_si_o = tot_sim_insn_si;
	assign tot_sim_insn_md_o = tot_sim_insn_md;
				
	assign ctaid_x_o = ctaid_x;
	assign ctaid_y_o = ctaid_y;
	assign ctaid_z_o = ctaid_z;
				
	assign issuedPC_o = issuedPC;
	assign issuedMask_o = issuedMask;
	
	wire [31:0] ddd;
	assign d = 768;
	assign euqa_o = (intuPacketLane0[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane1[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane2[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane3[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane4[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane5[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane6[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane7[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane8[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane9[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane10[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane11[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane12[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane13[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane14[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane15[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane16[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane17[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane18[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane19[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane20[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane21[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane22[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane23[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane24[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane25[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane26[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane27[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane28[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane29[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane30[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d)
		+ (intuPacketLane31[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG] == d);
		
endmodule
