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
`define SIZE_RAM 32
`define SIZE_RAM_LOG 5
`define DRAMDelay 400
`define SIZE_SM_LOG 2
module LSU(
			input reset,
			input clk,
					
			//input stall_i,	//Only stall the upper part of this module
					
			input load_i,
			input store_i,
			input DDR3_rdy,
			input DDR3_w_rdy,
			input [`SIZE_SM_LOG-1:0] sm_i,		
			input stall_i,
			input DDR3OutPacketWorking_i,
			input [`NUM_WARP_LOG-1:0] ldstWarp_i,
			input ldstPacketValid_i,
			input [`SIZE_CORE-1:0] ldstMask_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane0_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane1_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane2_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane3_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane4_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane5_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane6_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane7_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane8_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane9_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane10_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane11_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane12_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane13_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane14_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane15_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane16_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane17_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane18_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane19_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane20_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane21_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane22_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane23_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane24_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane25_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane26_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane27_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane28_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane29_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane30_i,
			input [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane31_i,

			output reg [`SIZE_CORE * `SIZE_ADDR - 1 :0 ] InfoRamAddr_o_o,
			output reg [`SIZE_CORE - 1 : 0 ] lane_mask_o,		
			output reg [27:0] RAM2DDR3_addr_o,
			output reg [63:0] RAM2DDR3_mask_o,
			output reg [511:0] RAM2DDR3_din_o,
			output reg RAM2DDR3_we_o,
			output reg [`NUM_WARP_LOG - 1 :0] RAM2DDR3_ldstWarp_o,
			output reg [`SIZE_REGFILE_BR - 1 :0] RAM2DDR3_ldstReg_o,
			output reg load_o,
			output reg store_o,
			output reg stall_input//不能给输入信�//外面stall

					//output
					);
	wire [`SIZE_ADDR-1:0] addr0_i;
	wire [`SIZE_ADDR-1:0] addr1_i;
	wire [`SIZE_ADDR-1:0] addr2_i;
	wire [`SIZE_ADDR-1:0] addr3_i;
	wire [`SIZE_ADDR-1:0] addr4_i;
	wire [`SIZE_ADDR-1:0] addr5_i;
	wire [`SIZE_ADDR-1:0] addr6_i;
	wire [`SIZE_ADDR-1:0] addr7_i;
	wire [`SIZE_ADDR-1:0] addr8_i;
	wire [`SIZE_ADDR-1:0] addr9_i;
	wire [`SIZE_ADDR-1:0] addr10_i;
	wire [`SIZE_ADDR-1:0] addr11_i;
	wire [`SIZE_ADDR-1:0] addr12_i;
	wire [`SIZE_ADDR-1:0] addr13_i;
	wire [`SIZE_ADDR-1:0] addr14_i;
	wire [`SIZE_ADDR-1:0] addr15_i;
	wire [`SIZE_ADDR-1:0] addr16_i;
	wire [`SIZE_ADDR-1:0] addr17_i;
	wire [`SIZE_ADDR-1:0] addr18_i;
	wire [`SIZE_ADDR-1:0] addr19_i;
	wire [`SIZE_ADDR-1:0] addr20_i;
	wire [`SIZE_ADDR-1:0] addr21_i;
	wire [`SIZE_ADDR-1:0] addr22_i;
	wire [`SIZE_ADDR-1:0] addr23_i;
	wire [`SIZE_ADDR-1:0] addr24_i;
	wire [`SIZE_ADDR-1:0] addr25_i;
	wire [`SIZE_ADDR-1:0] addr26_i;
	wire [`SIZE_ADDR-1:0] addr27_i;
	wire [`SIZE_ADDR-1:0] addr28_i;
	wire [`SIZE_ADDR-1:0] addr29_i;
	wire [`SIZE_ADDR-1:0] addr30_i;
	wire [`SIZE_ADDR-1:0] addr31_i;

	wire [`SIZE_DATA-1:0] storeData0_i;
	wire [`SIZE_DATA-1:0] storeData1_i;
	wire [`SIZE_DATA-1:0] storeData2_i;
	wire [`SIZE_DATA-1:0] storeData3_i;
	wire [`SIZE_DATA-1:0] storeData4_i;
	wire [`SIZE_DATA-1:0] storeData5_i;
	wire [`SIZE_DATA-1:0] storeData6_i;
	wire [`SIZE_DATA-1:0] storeData7_i;
	wire [`SIZE_DATA-1:0] storeData8_i;
	wire [`SIZE_DATA-1:0] storeData9_i;
	wire [`SIZE_DATA-1:0] storeData10_i;
	wire [`SIZE_DATA-1:0] storeData11_i;
	wire [`SIZE_DATA-1:0] storeData12_i;
	wire [`SIZE_DATA-1:0] storeData13_i;
	wire [`SIZE_DATA-1:0] storeData14_i;
	wire [`SIZE_DATA-1:0] storeData15_i;
	wire [`SIZE_DATA-1:0] storeData16_i;
	wire [`SIZE_DATA-1:0] storeData17_i;
	wire [`SIZE_DATA-1:0] storeData18_i;
	wire [`SIZE_DATA-1:0] storeData19_i;
	wire [`SIZE_DATA-1:0] storeData20_i;
	wire [`SIZE_DATA-1:0] storeData21_i;
	wire [`SIZE_DATA-1:0] storeData22_i;
	wire [`SIZE_DATA-1:0] storeData23_i;
	wire [`SIZE_DATA-1:0] storeData24_i;
	wire [`SIZE_DATA-1:0] storeData25_i;
	wire [`SIZE_DATA-1:0] storeData26_i;
	wire [`SIZE_DATA-1:0] storeData27_i;
	wire [`SIZE_DATA-1:0] storeData28_i;
	wire [`SIZE_DATA-1:0] storeData29_i;
	wire [`SIZE_DATA-1:0] storeData30_i;
	wire [`SIZE_DATA-1:0] storeData31_i;
	
	wire [`SIZE_REGFILE_BR-1:0] ldstReg_i;
	
		assign addr0_i = ldstPacketLane0_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr1_i = ldstPacketLane1_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr2_i = ldstPacketLane2_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr3_i = ldstPacketLane3_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr4_i = ldstPacketLane4_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr5_i = ldstPacketLane5_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr6_i = ldstPacketLane6_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr7_i = ldstPacketLane7_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr8_i = ldstPacketLane8_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr9_i = ldstPacketLane9_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr10_i = ldstPacketLane10_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr11_i = ldstPacketLane11_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr12_i = ldstPacketLane12_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr13_i = ldstPacketLane13_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr14_i = ldstPacketLane14_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr15_i = ldstPacketLane15_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr16_i = ldstPacketLane16_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr17_i = ldstPacketLane17_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr18_i = ldstPacketLane18_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr19_i = ldstPacketLane19_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr20_i = ldstPacketLane20_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr21_i = ldstPacketLane21_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr22_i = ldstPacketLane22_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr23_i = ldstPacketLane23_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr24_i = ldstPacketLane24_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr25_i = ldstPacketLane25_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr26_i = ldstPacketLane26_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr27_i = ldstPacketLane27_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr28_i = ldstPacketLane28_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr29_i = ldstPacketLane29_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr30_i = ldstPacketLane30_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign addr31_i = ldstPacketLane31_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		
		assign storeData0_i = ldstPacketLane0_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData1_i = ldstPacketLane1_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData2_i = ldstPacketLane2_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData3_i = ldstPacketLane3_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData4_i = ldstPacketLane4_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData5_i = ldstPacketLane5_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData6_i = ldstPacketLane6_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData7_i = ldstPacketLane7_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData8_i = ldstPacketLane8_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData9_i = ldstPacketLane9_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData10_i = ldstPacketLane10_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData11_i = ldstPacketLane11_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData12_i = ldstPacketLane12_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData13_i = ldstPacketLane13_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData14_i = ldstPacketLane14_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData15_i = ldstPacketLane15_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData16_i = ldstPacketLane16_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData17_i = ldstPacketLane17_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData18_i = ldstPacketLane18_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData19_i = ldstPacketLane19_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData20_i = ldstPacketLane20_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData21_i = ldstPacketLane21_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData22_i = ldstPacketLane22_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData23_i = ldstPacketLane23_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData24_i = ldstPacketLane24_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData25_i = ldstPacketLane25_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData26_i = ldstPacketLane26_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData27_i = ldstPacketLane27_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData28_i = ldstPacketLane28_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData29_i = ldstPacketLane29_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData30_i = ldstPacketLane30_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
		assign storeData31_i = ldstPacketLane31_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:`LDST_SPACE_LOG+`LDST_TYPES_LOG];

		
		
	assign ldstReg_i = ldstPacketLane0_i[`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];//only need lane0
	
	wire [1:0] ldstSpace_i;
	assign ldstSpace_i = ldstPacketLane0_i[`LDST_SPACE_LOG + `LDST_TYPES_LOG - 1: `LDST_TYPES_LOG];

	wire ldst_global_i;
	wire ldst_shared_i;
 
 
	assign ldst_global_i = (ldstSpace_i == 2'b00)? 1'b1:1'b0;
	assign ldst_shared_i = (ldstSpace_i == 2'b01)? 1'b1:1'b0;
	
	// 00 = L1, 01 = L2, 10 = DRAM  , load

	wire [`SIZE_CORE * `SIZE_ADDR - 1 : 0] GlobalAddrPacket_o,GlobalAddrPacket_o_sm0,GlobalAddrPacket_o_sm1,
														GlobalAddrPacket_o_sm2,GlobalAddrPacket_o_sm3;
	wire [`SIZE_CORE * `SIZE_DATA - 1 : 0] GlobalStoreDataPacket_o,GlobalStoreDataPacket_o_sm0,GlobalStoreDataPacket_o_sm1,
														GlobalStoreDataPacket_o_sm2,GlobalStoreDataPacket_o_sm3; 
	wire [`SIZE_CORE + `NUM_WARP_LOG + `SIZE_REGFILE_BR + 2 : 0] GlobalInfoPacket_o,GlobalInfoPacket_o_sm0,GlobalInfoPacket_o_sm1,
														GlobalInfoPacket_o_sm2,GlobalInfoPacket_o_sm3;
	reg [`SIZE_ADDR - 1 : 0] Coalesce2L1_o;
	reg [`SIZE_CORE_LOG - 1 : 0] SegNum;
	
	reg RAM_Out;
	wire RAM_Out_sm0,RAM_Out_sm1,RAM_Out_sm2,RAM_Out_sm3;
	reg [`SIZE_ADDR - 1 : 0] FIFOAddrOut;
	wire [`SIZE_CORE_LOG - 1 : 0] SegNum_sm0,SegNum_sm1,SegNum_sm2,SegNum_sm3;
	wire [`SIZE_ADDR - 1 : 0 ] Coalesce2L1_o_sm0,Coalesce2L1_o_sm1,Coalesce2L1_o_sm2,Coalesce2L1_o_sm3;

	wire  FIFOIn_sm0,FIFOIn_sm1,FIFOIn_sm2,FIFOIn_sm3;	
	wire global_Tag2FIFO_sm0,global_Tag2FIFO_sm1,global_Tag2FIFO_sm2,global_Tag2FIFO_sm3;
	wire shared_Tag2FIFO_sm0,shared_Tag2FIFO_sm1,shared_Tag2FIFO_sm2,shared_Tag2FIFO_sm3;
	wire [`SIZE_ADDR - 1 : 0 ] FIFOAddrIn_sm0,FIFOAddrIn_sm1,FIFOAddrIn_sm2,FIFOAddrIn_sm3;
	assign FIFOIn_sm0 = CoalesceWorking_sm0;
	assign FIFOIn_sm1 = CoalesceWorking_sm1;
	assign FIFOIn_sm2 = CoalesceWorking_sm2;
	assign FIFOIn_sm3 = CoalesceWorking_sm3;
	assign FIFOAddrIn_sm0 = Coalesce2L1_o_sm0;
	assign FIFOAddrIn_sm1 = Coalesce2L1_o_sm1;
	assign FIFOAddrIn_sm2 = Coalesce2L1_o_sm2;
	assign FIFOAddrIn_sm3 = Coalesce2L1_o_sm3;
	assign global_Tag2FIFO_sm0 = ldst_global_Co2Tag_sm0;
	assign global_Tag2FIFO_sm1 = ldst_global_Co2Tag_sm1;
	assign global_Tag2FIFO_sm2 = ldst_global_Co2Tag_sm2;
	assign global_Tag2FIFO_sm3 = ldst_global_Co2Tag_sm3;	
	assign shared_Tag2FIFO_sm0 = ldst_shared_Co2Tag_sm0;
	assign shared_Tag2FIFO_sm1 = ldst_shared_Co2Tag_sm1;
	assign shared_Tag2FIFO_sm2 = ldst_shared_Co2Tag_sm2;
	assign shared_Tag2FIFO_sm3 = ldst_shared_Co2Tag_sm3;
	
				
	wire [1:0] FIFO_Out_Type_sm0;		
	wire [9:0] L1Delay_sm0;
	wire [`SIZE_ADDR - 1 :0] L1TagWriteAddr_sm0;
	wire [`SIZE_ADDR - 1 :0] FIFOAddrOut_sm0;
	wire [1:0] FIFO_Out_Type_sm1;		
	wire [9:0] L1Delay_sm1;
	wire [`SIZE_ADDR - 1 :0] L1TagWriteAddr_sm1;
	wire [`SIZE_ADDR - 1 :0] FIFOAddrOut_sm1;
	wire [1:0] FIFO_Out_Type_sm2;		
	wire [9:0] L1Delay_sm2;
	wire [`SIZE_ADDR - 1 :0] L1TagWriteAddr_sm2;
	wire [`SIZE_ADDR - 1 :0] FIFOAddrOut_sm2;
	wire [1:0] FIFO_Out_Type_sm3;		
	wire [9:0] L1Delay_sm3;
	wire [`SIZE_ADDR - 1 :0] L1TagWriteAddr_sm3;
	wire [`SIZE_ADDR - 1 :0] FIFOAddrOut_sm3;
	
	wire [`SIZE_CORE - 1 : 0] lane_mask_o_sm3;
	wire [`SIZE_CORE * `SIZE_ADDR - 1 :0 ] InfoRamAddr_o_o_sm3;
	wire [27:0] RAM2DDR3_addr_o_sm3;
	wire [63:0] RAM2DDR3_mask_o_sm3;
	wire [511:0] RAM2DDR3_din_o_sm3;
	wire RAM2DDR3_we_o_sm3;
	wire [`NUM_WARP_LOG - 1 : 0 ]RAM2DDR3_ldstWarp_o_sm3;
	wire [`SIZE_REGFILE_BR - 1 : 0 ] RAM2DDR3_ldstReg_o_sm3;
	wire load_o_sm3;
	wire store_o_sm3;
	wire LSUOut_working_sm3;
		
	wire [9:0] L2Delay;
	wire load_o_sm0;
	wire store_o_sm0;
	wire LSUOut_working_sm0;
	wire load_o_sm1;
	wire store_o_sm1;
	wire LSUOut_working_sm1;
	wire load_o_sm2;
	wire store_o_sm2;
	wire LSUOut_working_sm2;
    always @(*)
	begin
	case(sm_i)
	0:begin
	//input signals
			InfoRamAddr_o_o <= InfoRamAddr_o_o_sm0;
			lane_mask_o <= lane_mask_o_sm0;		
			RAM2DDR3_addr_o <= RAM2DDR3_addr_o_sm0;
			RAM2DDR3_mask_o <= RAM2DDR3_mask_o_sm0;
			RAM2DDR3_din_o <= RAM2DDR3_din_o_sm0;
			RAM2DDR3_we_o <= RAM2DDR3_we_o_sm0;
			RAM2DDR3_ldstWarp_o <= RAM2DDR3_ldstWarp_o_sm0;
			RAM2DDR3_ldstReg_o <= RAM2DDR3_ldstReg_o_sm0;
			load_o <= load_o_sm0;
			store_o <= store_o_sm0;
			stall_input <= stall_input_sm0;
	//inside signals
	//output signals
			
	end
	1:begin
			InfoRamAddr_o_o <= InfoRamAddr_o_o_sm1;
			lane_mask_o <= lane_mask_o_sm1;		
			RAM2DDR3_addr_o <= RAM2DDR3_addr_o_sm1;
			RAM2DDR3_mask_o <= RAM2DDR3_mask_o_sm1;
			RAM2DDR3_din_o <= RAM2DDR3_din_o_sm1;
			RAM2DDR3_we_o <= RAM2DDR3_we_o_sm1;
			RAM2DDR3_ldstWarp_o <= RAM2DDR3_ldstWarp_o_sm1;
			RAM2DDR3_ldstReg_o <= RAM2DDR3_ldstReg_o_sm1;
			load_o <= load_o_sm1;
			store_o <= store_o_sm1;
			stall_input <= stall_input_sm1;
	end
	2:begin
			InfoRamAddr_o_o <= InfoRamAddr_o_o_sm2;
			lane_mask_o <= lane_mask_o_sm2;		
			RAM2DDR3_addr_o <= RAM2DDR3_addr_o_sm2;
			RAM2DDR3_mask_o <= RAM2DDR3_mask_o_sm2;
			RAM2DDR3_din_o <= RAM2DDR3_din_o_sm2;
			RAM2DDR3_we_o <= RAM2DDR3_we_o_sm2;
			RAM2DDR3_ldstWarp_o <= RAM2DDR3_ldstWarp_o_sm2;
			RAM2DDR3_ldstReg_o <= RAM2DDR3_ldstReg_o_sm2;
			load_o <= load_o_sm2;
			store_o <= store_o_sm2;
			stall_input <= stall_input_sm2;
	end
	3:begin
			InfoRamAddr_o_o <= InfoRamAddr_o_o_sm3;
			lane_mask_o <= lane_mask_o_sm3;		
			RAM2DDR3_addr_o <= RAM2DDR3_addr_o_sm3;
			RAM2DDR3_mask_o <= RAM2DDR3_mask_o_sm3;
			RAM2DDR3_din_o <= RAM2DDR3_din_o_sm3;
			RAM2DDR3_we_o <= RAM2DDR3_we_o_sm3;
			RAM2DDR3_ldstWarp_o <= RAM2DDR3_ldstWarp_o_sm3;
			RAM2DDR3_ldstReg_o <= RAM2DDR3_ldstReg_o_sm3;
			load_o <= load_o_sm3;
			store_o <= store_o_sm3;
			stall_input <= stall_input_sm3;
	end
	endcase
	end
	
	Coalesce 
		coalesce_sm0( 
			.reset(reset),
			.clk(clk),
			.stall(stall_i | ~ldst_global_i | InfoRamFull_sm0 | (sm_i != 0)),
					 
			.load_i(load_i),
			.store_i(store_i),
			.ldst_global_i(ldst_global_i),
			.ldst_shared_i(ldst_shared_i),
			.ldstMask_i(ldstMask_i),
			.ldstWarp_i(ldstWarp_i),
			.ldstPacketValid_i(ldstPacketValid_i),
			.ldstReg_i(ldstReg_i),
			.addr0_i(addr0_i),
			.addr1_i(addr1_i),
			.addr2_i(addr2_i),
			.addr3_i(addr3_i),
			.addr4_i(addr4_i),
			.addr5_i(addr5_i),
			.addr6_i(addr6_i),
			.addr7_i(addr7_i),
			.addr8_i(addr8_i),
			.addr9_i(addr9_i),
			.addr10_i(addr10_i),
			.addr11_i(addr11_i),
			.addr12_i(addr12_i),
			.addr13_i(addr13_i),
			.addr14_i(addr14_i),
			.addr15_i(addr15_i),
			.addr16_i(addr16_i),
			.addr17_i(addr17_i),
			.addr18_i(addr18_i),
			.addr19_i(addr19_i),
			.addr20_i(addr20_i),
			.addr21_i(addr21_i),
			.addr22_i(addr22_i),
			.addr23_i(addr23_i),
			.addr24_i(addr24_i),
			.addr25_i(addr25_i),
			.addr26_i(addr26_i),
			.addr27_i(addr27_i),
			.addr28_i(addr28_i),
			.addr29_i(addr29_i),
			.addr30_i(addr30_i),
			.addr31_i(addr31_i),

			.storeData0_i(storeData0_i),
			.storeData1_i(storeData1_i),
			.storeData2_i(storeData2_i),
			.storeData3_i(storeData3_i),
			.storeData4_i(storeData4_i),
			.storeData5_i(storeData5_i),
			.storeData6_i(storeData6_i),
			.storeData7_i(storeData7_i),
			.storeData8_i(storeData8_i),
			.storeData9_i(storeData9_i),
			.storeData10_i(storeData10_i),
			.storeData11_i(storeData11_i),
			.storeData12_i(storeData12_i),
			.storeData13_i(storeData13_i),
			.storeData14_i(storeData14_i),
			.storeData15_i(storeData15_i),
			.storeData16_i(storeData16_i),
			.storeData17_i(storeData17_i),
			.storeData18_i(storeData18_i),
			.storeData19_i(storeData19_i),
			.storeData20_i(storeData20_i),
			.storeData21_i(storeData21_i),
			.storeData22_i(storeData22_i),
			.storeData23_i(storeData23_i),
			.storeData24_i(storeData24_i),
			.storeData25_i(storeData25_i),
			.storeData26_i(storeData26_i),
			.storeData27_i(storeData27_i),
			.storeData28_i(storeData28_i),
			.storeData29_i(storeData29_i),
			.storeData30_i(storeData30_i),
			.storeData31_i(storeData31_i),
			//----------------
			.GlobalAddrPacket_o(GlobalAddrPacket_o_sm0),
			.GlobalStoreDataPacket_o(GlobalStoreDataPacket_o_sm0),
			.GlobalInfoPacket_o(GlobalInfoPacket_o_sm0),
			.Coalesce2L1_o(Coalesce2L1_o_sm0),
			.SegNum(SegNum_sm0),
			.ldst_global_o(ldst_global_Co2Tag_sm0),
			.ldst_shared_o(ldst_shared_Co2Tag_sm0),
			.stall_input(stall_input_sm0),  //不能给输入信�
			.working(CoalesceWorking_sm0)
			);
	Coalesce
		coalesce_sm1( 
			.reset(reset),
			.clk(clk),
			.stall(stall_i | ~ldst_global_i | InfoRamFull_sm1 | (sm_i != 1)),
					 
			.load_i(load_i),
			.store_i(store_i),
			.ldst_global_i(ldst_global_i),
			.ldst_shared_i(ldst_shared_i),
			.ldstMask_i(ldstMask_i),
			.ldstWarp_i(ldstWarp_i),
			.ldstPacketValid_i(ldstPacketValid_i),
			.ldstReg_i(ldstReg_i),
			.addr0_i(addr0_i),
			.addr1_i(addr1_i),
			.addr2_i(addr2_i),
			.addr3_i(addr3_i),
			.addr4_i(addr4_i),
			.addr5_i(addr5_i),
			.addr6_i(addr6_i),
			.addr7_i(addr7_i),
			.addr8_i(addr8_i),
			.addr9_i(addr9_i),
			.addr10_i(addr10_i),
			.addr11_i(addr11_i),
			.addr12_i(addr12_i),
			.addr13_i(addr13_i),
			.addr14_i(addr14_i),
			.addr15_i(addr15_i),
			.addr16_i(addr16_i),
			.addr17_i(addr17_i),
			.addr18_i(addr18_i),
			.addr19_i(addr19_i),
			.addr20_i(addr20_i),
			.addr21_i(addr21_i),
			.addr22_i(addr22_i),
			.addr23_i(addr23_i),
			.addr24_i(addr24_i),
			.addr25_i(addr25_i),
			.addr26_i(addr26_i),
			.addr27_i(addr27_i),
			.addr28_i(addr28_i),
			.addr29_i(addr29_i),
			.addr30_i(addr30_i),
			.addr31_i(addr31_i),

			.storeData0_i(storeData0_i),
			.storeData1_i(storeData1_i),
			.storeData2_i(storeData2_i),
			.storeData3_i(storeData3_i),
			.storeData4_i(storeData4_i),
			.storeData5_i(storeData5_i),
			.storeData6_i(storeData6_i),
			.storeData7_i(storeData7_i),
			.storeData8_i(storeData8_i),
			.storeData9_i(storeData9_i),
			.storeData10_i(storeData10_i),
			.storeData11_i(storeData11_i),
			.storeData12_i(storeData12_i),
			.storeData13_i(storeData13_i),
			.storeData14_i(storeData14_i),
			.storeData15_i(storeData15_i),
			.storeData16_i(storeData16_i),
			.storeData17_i(storeData17_i),
			.storeData18_i(storeData18_i),
			.storeData19_i(storeData19_i),
			.storeData20_i(storeData20_i),
			.storeData21_i(storeData21_i),
			.storeData22_i(storeData22_i),
			.storeData23_i(storeData23_i),
			.storeData24_i(storeData24_i),
			.storeData25_i(storeData25_i),
			.storeData26_i(storeData26_i),
			.storeData27_i(storeData27_i),
			.storeData28_i(storeData28_i),
			.storeData29_i(storeData29_i),
			.storeData30_i(storeData30_i),
			.storeData31_i(storeData31_i),
			//----------------
			.GlobalAddrPacket_o(GlobalAddrPacket_o_sm1),
			.GlobalStoreDataPacket_o(GlobalStoreDataPacket_o_sm1),
			.GlobalInfoPacket_o(GlobalInfoPacket_o_sm1),
			.Coalesce2L1_o(Coalesce2L1_o_sm1),
			.SegNum(SegNum_sm1),
			.ldst_global_o(ldst_global_Co2Tag_sm1),
			.ldst_shared_o(ldst_shared_Co2Tag_sm1),
			.stall_input(stall_input_sm1),  //不能给输入信�
			.working(CoalesceWorking_sm1)
			);


	Coalesce
		coalesce_sm2( 
			.reset(reset),
			.clk(clk),
			.stall(stall_i | ~ldst_global_i | InfoRamFull_sm2 |(sm_i != 2)),
					 
			.load_i(load_i),
			.store_i(store_i),
			.ldst_global_i(ldst_global_i),
			.ldst_shared_i(ldst_shared_i),
			.ldstMask_i(ldstMask_i),
			.ldstWarp_i(ldstWarp_i),
			.ldstPacketValid_i(ldstPacketValid_i),
			.ldstReg_i(ldstReg_i),
			.addr0_i(addr0_i),
			.addr1_i(addr1_i),
			.addr2_i(addr2_i),
			.addr3_i(addr3_i),
			.addr4_i(addr4_i),
			.addr5_i(addr5_i),
			.addr6_i(addr6_i),
			.addr7_i(addr7_i),
			.addr8_i(addr8_i),
			.addr9_i(addr9_i),
			.addr10_i(addr10_i),
			.addr11_i(addr11_i),
			.addr12_i(addr12_i),
			.addr13_i(addr13_i),
			.addr14_i(addr14_i),
			.addr15_i(addr15_i),
			.addr16_i(addr16_i),
			.addr17_i(addr17_i),
			.addr18_i(addr18_i),
			.addr19_i(addr19_i),
			.addr20_i(addr20_i),
			.addr21_i(addr21_i),
			.addr22_i(addr22_i),
			.addr23_i(addr23_i),
			.addr24_i(addr24_i),
			.addr25_i(addr25_i),
			.addr26_i(addr26_i),
			.addr27_i(addr27_i),
			.addr28_i(addr28_i),
			.addr29_i(addr29_i),
			.addr30_i(addr30_i),
			.addr31_i(addr31_i),

			.storeData0_i(storeData0_i),
			.storeData1_i(storeData1_i),
			.storeData2_i(storeData2_i),
			.storeData3_i(storeData3_i),
			.storeData4_i(storeData4_i),
			.storeData5_i(storeData5_i),
			.storeData6_i(storeData6_i),
			.storeData7_i(storeData7_i),
			.storeData8_i(storeData8_i),
			.storeData9_i(storeData9_i),
			.storeData10_i(storeData10_i),
			.storeData11_i(storeData11_i),
			.storeData12_i(storeData12_i),
			.storeData13_i(storeData13_i),
			.storeData14_i(storeData14_i),
			.storeData15_i(storeData15_i),
			.storeData16_i(storeData16_i),
			.storeData17_i(storeData17_i),
			.storeData18_i(storeData18_i),
			.storeData19_i(storeData19_i),
			.storeData20_i(storeData20_i),
			.storeData21_i(storeData21_i),
			.storeData22_i(storeData22_i),
			.storeData23_i(storeData23_i),
			.storeData24_i(storeData24_i),
			.storeData25_i(storeData25_i),
			.storeData26_i(storeData26_i),
			.storeData27_i(storeData27_i),
			.storeData28_i(storeData28_i),
			.storeData29_i(storeData29_i),
			.storeData30_i(storeData30_i),
			.storeData31_i(storeData31_i),
			//----------------
			.GlobalAddrPacket_o(GlobalAddrPacket_o_sm2),
			.GlobalStoreDataPacket_o(GlobalStoreDataPacket_o_sm2),
			.GlobalInfoPacket_o(GlobalInfoPacket_o_sm2),
			.Coalesce2L1_o(Coalesce2L1_o_sm2),
			.SegNum(SegNum_sm2),
			.ldst_global_o(ldst_global_Co2Tag_sm2),
			.ldst_shared_o(ldst_shared_Co2Tag_sm2),
			.stall_input(stall_input_sm2),  //不能给输入信�
			.working(CoalesceWorking_sm2)
			);


	Coalesce 
		coalesce_sm3( 
			.reset(reset),
			.clk(clk),
			.stall(stall_i | ~ldst_global_i | InfoRamFull_sm3 |(sm_i != 3)),
					 
			.load_i(load_i),
			.store_i(store_i),
			.ldst_global_i(ldst_global_i),
			.ldst_shared_i(ldst_shared_i),
			.ldstMask_i(ldstMask_i),
			.ldstWarp_i(ldstWarp_i),
			.ldstPacketValid_i(ldstPacketValid_i),
			.ldstReg_i(ldstReg_i),
			.addr0_i(addr0_i),
			.addr1_i(addr1_i),
			.addr2_i(addr2_i),
			.addr3_i(addr3_i),
			.addr4_i(addr4_i),
			.addr5_i(addr5_i),
			.addr6_i(addr6_i),
			.addr7_i(addr7_i),
			.addr8_i(addr8_i),
			.addr9_i(addr9_i),
			.addr10_i(addr10_i),
			.addr11_i(addr11_i),
			.addr12_i(addr12_i),
			.addr13_i(addr13_i),
			.addr14_i(addr14_i),
			.addr15_i(addr15_i),
			.addr16_i(addr16_i),
			.addr17_i(addr17_i),
			.addr18_i(addr18_i),
			.addr19_i(addr19_i),
			.addr20_i(addr20_i),
			.addr21_i(addr21_i),
			.addr22_i(addr22_i),
			.addr23_i(addr23_i),
			.addr24_i(addr24_i),
			.addr25_i(addr25_i),
			.addr26_i(addr26_i),
			.addr27_i(addr27_i),
			.addr28_i(addr28_i),
			.addr29_i(addr29_i),
			.addr30_i(addr30_i),
			.addr31_i(addr31_i),

			.storeData0_i(storeData0_i),
			.storeData1_i(storeData1_i),
			.storeData2_i(storeData2_i),
			.storeData3_i(storeData3_i),
			.storeData4_i(storeData4_i),
			.storeData5_i(storeData5_i),
			.storeData6_i(storeData6_i),
			.storeData7_i(storeData7_i),
			.storeData8_i(storeData8_i),
			.storeData9_i(storeData9_i),
			.storeData10_i(storeData10_i),
			.storeData11_i(storeData11_i),
			.storeData12_i(storeData12_i),
			.storeData13_i(storeData13_i),
			.storeData14_i(storeData14_i),
			.storeData15_i(storeData15_i),
			.storeData16_i(storeData16_i),
			.storeData17_i(storeData17_i),
			.storeData18_i(storeData18_i),
			.storeData19_i(storeData19_i),
			.storeData20_i(storeData20_i),
			.storeData21_i(storeData21_i),
			.storeData22_i(storeData22_i),
			.storeData23_i(storeData23_i),
			.storeData24_i(storeData24_i),
			.storeData25_i(storeData25_i),
			.storeData26_i(storeData26_i),
			.storeData27_i(storeData27_i),
			.storeData28_i(storeData28_i),
			.storeData29_i(storeData29_i),
			.storeData30_i(storeData30_i),
			.storeData31_i(storeData31_i),
			//----------------
			.GlobalAddrPacket_o(GlobalAddrPacket_o_sm3),
			.GlobalStoreDataPacket_o(GlobalStoreDataPacket_o_sm3),
			.GlobalInfoPacket_o(GlobalInfoPacket_o_sm3),
			.Coalesce2L1_o(Coalesce2L1_o_sm3),
			.SegNum(SegNum_sm3),
			.ldst_global_o(ldst_global_Co2Tag_sm3),
			.ldst_shared_o(ldst_shared_Co2Tag_sm3),
			.stall_input(stall_input_sm3),  //不能给输入信�
			.working(CoalesceWorking_sm3)
			);			
			/*wire [`SIZE_ADDR * `SIZE_CORE - 1 : 0] SharedAddrPacket_o;
			wire [`SIZE_DATA * `SIZE_CORE - 1 : 0] SharedStoreDataPacket_o;
			wire [`SIZE_CORE + `NUM_WARP_LOG + `SIZE_REGFILE_BR + 2 : 0] SharedInfoPacket_o;
			wire [9 : 0] BankConflictDelay;
			wire BankConflictOut;
	BankConflict BankConflict( 
			.reset(reset),
			.clk(clk),
			.stall(stall_i | ~ldst_Shared_i),
					
			.load_i(load_i),
			.store_i(store_i),			

			.ldstMask_i(ldstMask_i),
			.ldstWarp_i(ldstWarp_i),
			.ldstPacketValid_i(ldstPacketValid_i),
			.addr0_i(addr0_i),
			.addr1_i(addr1_i),
			.addr2_i(addr2_i),
			.addr3_i(addr3_i),
			.addr4_i(addr4_i),
			.addr5_i(addr5_i),
			.addr6_i(addr6_i),
			.addr7_i(addr7_i),
			.addr8_i(addr8_i),
			.addr9_i(addr9_i),
			.addr10_i(addr10_i),
			.addr11_i(addr11_i),
			.addr12_i(addr12_i),
			.addr13_i(addr13_i),
			.addr14_i(addr14_i),
			.addr15_i(addr15_i),
			.addr16_i(addr16_i),
			.addr17_i(addr17_i),
			.addr18_i(addr18_i),
			.addr19_i(addr19_i),
			.addr20_i(addr20_i),
			.addr21_i(addr21_i),
			.addr22_i(addr22_i),
			.addr23_i(addr23_i),
			.addr24_i(addr24_i),
			.addr25_i(addr25_i),
			.addr26_i(addr26_i),
			.addr27_i(addr27_i),
			.addr28_i(addr28_i),
			.addr29_i(addr29_i),
			.addr30_i(addr30_i),
			.addr31_i(addr31_i),

			.storeData0_i(storeData0_i),
			.storeData1_i(storeData1_i),
			.storeData2_i(storeData2_i),
			.storeData3_i(storeData3_i),
			.storeData4_i(storeData4_i),
			.storeData5_i(storeData5_i),
			.storeData6_i(storeData6_i),
			.storeData7_i(storeData7_i),
			.storeData8_i(storeData8_i),
			.storeData9_i(storeData9_i),
			.storeData10_i(storeData10_i),
			.storeData11_i(storeData11_i),
			.storeData12_i(storeData12_i),
			.storeData13_i(storeData13_i),
			.storeData14_i(storeData14_i),
			.storeData15_i(storeData15_i),
			.storeData16_i(storeData16_i),
			.storeData17_i(storeData17_i),
			.storeData18_i(storeData18_i),
			.storeData19_i(storeData19_i),
			.storeData20_i(storeData20_i),
			.storeData21_i(storeData21_i),
			.storeData22_i(storeData22_i),
			.storeData23_i(storeData23_i),
			.storeData24_i(storeData24_i),
			.storeData25_i(storeData25_i),
			.storeData26_i(storeData26_i),
			.storeData27_i(storeData27_i),
			.storeData28_i(storeData28_i),
			.storeData29_i(storeData29_i),
			.storeData30_i(storeData30_i),
			.storeData31_i(storeData31_i),

			//----------------
			
			.SharedAddrPacket_o(SharedAddrPacket_o),
			.SharedStoreDataPacket_o(SharedStoreDataPacket_o),
			.SharedInfoPacket_o(SharedInfoPacket_o),
			.Delay(BankConflictDelay),
			.BankConflictOut(BankConflictOut)
			);*/

	L1TagUnit 
	L1_sm0(
		.reset(reset),
		.clk(clk),
		.stall( stall_i | (sm_i != 0)),
		
		.L1TagWrite(RAM_Out_sm0),
		.L1TagWriteAddr(FIFOAddrOut_sm0),
		.SegNum(SegNum_sm0),		
		.Coalesce2L1_o(Coalesce2L1_o_sm0),
		
		.Delay(L1Delay_sm0),
		.L1_HIT(L1_HIT_sm0)
		);
		

	L1TagUnit 
	L1_sm1(
		.reset(reset),
		.clk(clk),
		.stall( stall_i | (sm_i != 1)),
		
		.L1TagWrite(RAM_Out_sm1),
		.L1TagWriteAddr(FIFOAddrOut_sm1),
		.SegNum(SegNum_sm1),		
		.Coalesce2L1_o(Coalesce2L1_o_sm1),
		
		.Delay(L1Delay_sm1),
		.L1_HIT(L1_HIT_sm1)
		);	
		

	
	L1TagUnit 
	L1_sm2(
		.reset(reset),
		.clk(clk),
		.stall( stall_i | (sm_i != 2)),
		
		.L1TagWrite(RAM_Out_sm2),
		.L1TagWriteAddr(FIFOAddrOut_sm2),
		.SegNum(SegNum_sm2),		
		.Coalesce2L1_o(Coalesce2L1_o_sm2),
		
		.Delay(L1Delay_sm2),
		.L1_HIT(L1_HIT_sm2)
		);	
		

	L1TagUnit 
	L1_sm3(
		.reset(reset),
		.clk(clk),
		.stall( stall_i | (sm_i != 3)),
		
		.L1TagWrite(RAM_Out_sm3),
		.L1TagWriteAddr(FIFOAddrOut_sm3),
		.SegNum(SegNum_sm3),		
		.Coalesce2L1_o(Coalesce2L1_o_sm3),
		
		.Delay(L1Delay_sm3),
		.L1_HIT(L1_HIT_sm3)
		);	
		


	
	always @(*)
	begin
		case(sm_i)
		0:begin
			RAM_Out = RAM_Out_sm0;
			FIFOAddrOut = FIFOAddrOut_sm0;
			SegNum = SegNum_sm0;
			Coalesce2L1_o = Coalesce2L1_o_sm0;
			end
		1:begin
			RAM_Out = RAM_Out_sm1;
			FIFOAddrOut = FIFOAddrOut_sm1;
			SegNum = SegNum_sm1;
			Coalesce2L1_o = Coalesce2L1_o_sm1;
			end
		2:begin
			RAM_Out = RAM_Out_sm2;
			FIFOAddrOut = FIFOAddrOut_sm2;
			SegNum = SegNum_sm2;
			Coalesce2L1_o = Coalesce2L1_o_sm2;
			end
		3:begin
			RAM_Out = RAM_Out_sm3;
			FIFOAddrOut = FIFOAddrOut_sm3;
			SegNum = SegNum_sm3;
			Coalesce2L1_o = Coalesce2L1_o_sm3;
			end
		
	endcase
	end
	L2TagUnit L2(
		.reset(reset),
		.clk(clk),
		.stall(stall_i),
		
		.L2TagWrite(RAM_Out),
		.L2TagWriteAddr(FIFOAddrOut),	
		.SegNum(SegNum),		
		.Coalesce2L1_o(Coalesce2L1_o),
		
		.Delay(L2Delay),
		.L2_HIT(L2_HIT)
		);
		
		
		
		
		
		
		wire [9:0] DRAMDelay;
		assign DRAMDelay =  `DRAMDelay;
		wire [9:0] SharedDelay;
		assign SharedDelay = 1;
		
	wire [`SIZE_RAM_LOG - 1:0] RAM_Addr_RAM2FIFO_sm0;
	wire [15:0] count_sm0;
	wire [`SIZE_RAM_LOG - 1:0] RAM_Addr_L1FIFO_o_sm0;
	wire [15:0] L1HeadOutTime_sm0;
	wire [`SIZE_ADDR - 1 :0] L1FIFOAddrOut_sm0;
	wire [`SIZE_ADDR - 1 :0] L2FIFOAddrOut_sm0;
	wire [`SIZE_ADDR - 1 :0] DRAMFIFOAddrOut_sm0;
	wire [`SIZE_ADDR - 1 :0] SharedFIFOAddrOut_sm0;
		
	MemAccessFIFO 
	L1FIFO_sm0(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i | (sm_i != 0)),
			
			.i(L1_HIT_sm0 & global_Tag2FIFO_sm0),
			.RAM_Addr_i(RAM_Addr_RAM2FIFO_sm0),
			.Delay(L1Delay_sm0),
			.count(count_sm0),			
			.o(RAM_Out_sm0 &(FIFO_Out_Type_sm0 == 2'b00) ),
			.FIFOIn(FIFOIn_sm0),
			.FIFOAddrIn(FIFOAddrIn_sm0),
			.FIFOAddrOut(L1FIFOAddrOut_sm0),
			
			.RAM_Addr_o(RAM_Addr_L1FIFO_o_sm0),
			.HeadOutTime(L1HeadOutTime_sm0),	
			.full(L1FIFO_full_sm0)
			);
			
	wire [`SIZE_RAM_LOG - 1:0] RAM_Addr_RAM2FIFO_sm1;
	wire [15:0] count_sm1;
	wire [`SIZE_RAM_LOG - 1:0] RAM_Addr_L1FIFO_o_sm1;
	wire [15:0] L1HeadOutTime_sm1;
	wire [`SIZE_ADDR - 1 :0] L1FIFOAddrOut_sm1;
	wire [`SIZE_ADDR - 1 :0] L2FIFOAddrOut_sm1;
	wire [`SIZE_ADDR - 1 :0] DRAMFIFOAddrOut_sm1;
	wire [`SIZE_ADDR - 1 :0] SharedFIFOAddrOut_sm1;
		
	MemAccessFIFO 
	L1FIFO_sm1(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i | (sm_i != 1)),
			
			.i(L1_HIT_sm1 & global_Tag2FIFO_sm1),
			.RAM_Addr_i(RAM_Addr_RAM2FIFO_sm1),
			.Delay(L1Delay_sm1),
			.count(count_sm1),			
			.o(RAM_Out_sm1 &(FIFO_Out_Type_sm1 == 2'b00) ),
			.FIFOIn(FIFOIn_sm1),
			.FIFOAddrIn(FIFOAddrIn_sm1),
			.FIFOAddrOut(L1FIFOAddrOut_sm1),
			
			.RAM_Addr_o(RAM_Addr_L1FIFO_o_sm1),
			.HeadOutTime(L1HeadOutTime_sm1),	
			.full(L1FIFO_full_sm1)
			);			
	wire [`SIZE_RAM_LOG - 1:0] RAM_Addr_RAM2FIFO_sm2;
	wire [15:0] count_sm2;
	wire [`SIZE_RAM_LOG - 1:0] RAM_Addr_L1FIFO_o_sm2;
	wire [15:0] L1HeadOutTime_sm2;
	wire [`SIZE_ADDR - 1 :0] L1FIFOAddrOut_sm2;
	wire [`SIZE_ADDR - 1 :0] L2FIFOAddrOut_sm2;
	wire [`SIZE_ADDR - 1 :0] DRAMFIFOAddrOut_sm2;
	wire [`SIZE_ADDR - 1 :0] SharedFIFOAddrOut_sm2;
		
	MemAccessFIFO 
	L1FIFO_sm2(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i | (sm_i != 2)),
			
			.i(L1_HIT_sm2 & global_Tag2FIFO_sm2),
			.RAM_Addr_i(RAM_Addr_RAM2FIFO_sm2),
			.Delay(L1Delay_sm2),
			.count(count_sm2),			
			.o(RAM_Out_sm2 &(FIFO_Out_Type_sm2 == 2'b00) ),
			.FIFOIn(FIFOIn_sm2),
			.FIFOAddrIn(FIFOAddrIn_sm2),
			.FIFOAddrOut(L1FIFOAddrOut_sm2),
			
			.RAM_Addr_o(RAM_Addr_L1FIFO_o_sm2),
			.HeadOutTime(L1HeadOutTime_sm2),	
			.full(L1FIFO_full_sm2)
			);

	wire [`SIZE_RAM_LOG - 1:0] RAM_Addr_RAM2FIFO_sm3;
	wire [15:0] count_sm3;
	wire [`SIZE_RAM_LOG - 1:0] RAM_Addr_L1FIFO_o_sm3;
	wire [15:0] L1HeadOutTime_sm3;
	wire [`SIZE_ADDR - 1 :0] L1FIFOAddrOut_sm3;
	wire [`SIZE_ADDR - 1 :0] L2FIFOAddrOut_sm3;
	wire [`SIZE_ADDR - 1 :0] DRAMFIFOAddrOut_sm3;
	wire [`SIZE_ADDR - 1 :0] SharedFIFOAddrOut_sm3;
		
	MemAccessFIFO 
	L1FIFO_sm3(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i | (sm_i != 3)),
			
			.i(L1_HIT_sm3 & global_Tag2FIFO_sm3),
			.RAM_Addr_i(RAM_Addr_RAM2FIFO_sm3),
			.Delay(L1Delay_sm3),
			.count(count_sm3),			
			.o(RAM_Out_sm3 &(FIFO_Out_Type_sm3 == 2'b00) ),
			.FIFOIn(FIFOIn_sm3),
			.FIFOAddrIn(FIFOAddrIn_sm3),
			.FIFOAddrOut(L1FIFOAddrOut_sm3),
			
			.RAM_Addr_o(RAM_Addr_L1FIFO_o_sm3),
			.HeadOutTime(L1HeadOutTime_sm3),	
			.full(L1FIFO_full_sm3)
			);
			
	wire [`SIZE_RAM_LOG - 1:0] RAM_Addr_L2FIFO_o_sm0;
	wire [15:0] L2HeadOutTime_sm0;
	wire [9:0] L2Delay_sm0;
	MemAccessFIFO 
	L2FIFO_sm0(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i | (sm_i != 0)),
			
			.i(L2_HIT & global_Tag2FIFO_sm0 & ~L1_HIT_sm0),
			.RAM_Addr_i(RAM_Addr_RAM2FIFO_sm0),
			.Delay(L2Delay),
			.count(count_sm0),			
			.o(RAM_Out_sm0 &(FIFO_Out_Type_sm0 == 2'b01)),
			.FIFOIn(FIFOIn_sm0),
			.FIFOAddrIn(FIFOAddrIn_sm0),
			.FIFOAddrOut(L2FIFOAddrOut_sm0),
			
			.RAM_Addr_o(RAM_Addr_L2FIFO_o_sm0),
			.HeadOutTime(L2HeadOutTime_sm0),	
			.full(L2FIFO_full_sm0)
			);
	wire [`SIZE_RAM_LOG - 1:0] RAM_Addr_L2FIFO_o_sm1;
	wire [15:0] L2HeadOutTime_sm1;
	wire [9:0] L2Delay_sm1;
	MemAccessFIFO 
	L2FIFO_sm1(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i | (sm_i != 1)),
			
			.i(L2_HIT & global_Tag2FIFO_sm1 & ~L1_HIT_sm1),
			.RAM_Addr_i(RAM_Addr_RAM2FIFO_sm1),
			.Delay(L2Delay),
			.count(count_sm1),			
			.o(RAM_Out_sm1 &(FIFO_Out_Type_sm1 == 2'b01)),
			.FIFOIn(FIFOIn_sm1),
			.FIFOAddrIn(FIFOAddrIn_sm1),
			.FIFOAddrOut(L2FIFOAddrOut_sm1),
			
			.RAM_Addr_o(RAM_Addr_L2FIFO_o_sm1),
			.HeadOutTime(L2HeadOutTime_sm1),	
			.full(L2FIFO_full_sm1)
			);

	wire [`SIZE_RAM_LOG - 1:0] RAM_Addr_L2FIFO_o_sm2;
	wire [15:0] L2HeadOutTime_sm2;
	wire [9:0] L2Delay_sm2;
	MemAccessFIFO 
	L2FIFO_sm2(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i | (sm_i != 2)),
			
			.i(L2_HIT & global_Tag2FIFO_sm2 & ~L1_HIT_sm2),
			.RAM_Addr_i(RAM_Addr_RAM2FIFO_sm2),
			.Delay(L2Delay),
			.count(count_sm2),			
			.o(RAM_Out_sm2 &(FIFO_Out_Type_sm2 == 2'b01)),
			.FIFOIn(FIFOIn_sm2),
			.FIFOAddrIn(FIFOAddrIn_sm2),
			.FIFOAddrOut(L2FIFOAddrOut_sm2),
			
			.RAM_Addr_o(RAM_Addr_L2FIFO_o_sm2),
			.HeadOutTime(L2HeadOutTime_sm2),	
			.full(L2FIFO_full_sm2)
			);

	wire [`SIZE_RAM_LOG - 1:0] RAM_Addr_L2FIFO_o_sm3;
	wire [15:0] L2HeadOutTime_sm3;
	wire [9:0] L2Delay_sm3;
	MemAccessFIFO 
	L2FIFO_sm3(
			.clk(clk),
			.reset(reset), 
			.stall_i(stall_i | (sm_i != 3)),
			
			.i(L2_HIT & global_Tag2FIFO_sm3 & ~L1_HIT_sm3),
			.RAM_Addr_i(RAM_Addr_RAM2FIFO_sm3),
			.Delay(L2Delay),
			.count(count_sm3),			
			.o(RAM_Out_sm3 &(FIFO_Out_Type_sm3 == 2'b01)),
			.FIFOIn(FIFOIn_sm3),
			.FIFOAddrIn(FIFOAddrIn_sm3),
			.FIFOAddrOut(L2FIFOAddrOut_sm3),
			
			.RAM_Addr_o(RAM_Addr_L2FIFO_o_sm3),
			.HeadOutTime(L2HeadOutTime_sm3),	
			.full(L2FIFO_full_sm3)
			);			
			
		
	wire [`SIZE_RAM_LOG - 1:0] RAM_Addr_DRAMFIFO_o_sm0;
	wire [15:0] DRAMHeadOutTime_sm0;
	MemAccessFIFO 
	DramFIFO_sm0(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i | (sm_i != 0)),
			
			.i(~L1_HIT_sm0 & ~L2_HIT & global_Tag2FIFO_sm0),
			.RAM_Addr_i(RAM_Addr_RAM2FIFO_sm0),
			.Delay(DRAMDelay),
			.count(count_sm0),			
			.o(RAM_Out_sm0 &(FIFO_Out_Type_sm0 == 2'b10)),
			.FIFOIn(FIFOIn_sm0),
			.FIFOAddrIn(FIFOAddrIn_sm0),
			.FIFOAddrOut(DRAMFIFOAddrOut_sm0),
			
			.RAM_Addr_o(RAM_Addr_DRAMFIFO_o_sm0),
			.HeadOutTime(DRAMHeadOutTime_sm0),	
			.full(DRAMFIFO_full_sm0)
			);
			
	wire [`SIZE_RAM_LOG - 1:0] RAM_Addr_DRAMFIFO_o_sm1;
	wire [15:0] DRAMHeadOutTime_sm1;
	MemAccessFIFO 
	DramFIFO_sm1(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i | (sm_i != 1)),
			
			.i(~L1_HIT_sm1 & ~L2_HIT & global_Tag2FIFO_sm1),
			.RAM_Addr_i(RAM_Addr_RAM2FIFO_sm1),
			.Delay(DRAMDelay),
			.count(count_sm1),			
			.o(RAM_Out_sm1 &(FIFO_Out_Type_sm1 == 2'b10)),
			.FIFOIn(FIFOIn_sm1),
			.FIFOAddrIn(FIFOAddrIn_sm1),
			.FIFOAddrOut(DRAMFIFOAddrOut_sm1),
			
			.RAM_Addr_o(RAM_Addr_DRAMFIFO_o_sm1),
			.HeadOutTime(DRAMHeadOutTime_sm1),	
			.full(DRAMFIFO_full_sm1)
			);

	wire [`SIZE_RAM_LOG - 1:0] RAM_Addr_DRAMFIFO_o_sm2;
	wire [15:0] DRAMHeadOutTime_sm2;
	MemAccessFIFO 
	DramFIFO_sm2(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i | (sm_i != 2)),
			
			.i(~L1_HIT_sm2 & ~L2_HIT & global_Tag2FIFO_sm2),
			.RAM_Addr_i(RAM_Addr_RAM2FIFO_sm2),
			.Delay(DRAMDelay),
			.count(count_sm2),			
			.o(RAM_Out_sm2 &(FIFO_Out_Type_sm2 == 2'b10)),
			.FIFOIn(FIFOIn_sm2),
			.FIFOAddrIn(FIFOAddrIn_sm2),
			.FIFOAddrOut(DRAMFIFOAddrOut_sm2),
			
			.RAM_Addr_o(RAM_Addr_DRAMFIFO_o_sm2),
			.HeadOutTime(DRAMHeadOutTime_sm2),	
			.full(DRAMFIFO_full_sm2)
			);

	wire [`SIZE_RAM_LOG - 1:0] RAM_Addr_DRAMFIFO_o_sm3;
	wire [15:0] DRAMHeadOutTime_sm3;
	MemAccessFIFO 
	DramFIFO_sm3(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i | (sm_i != 3)),
			
			.i(~L1_HIT_sm3 & ~L2_HIT & global_Tag2FIFO_sm3),
			.RAM_Addr_i(RAM_Addr_RAM2FIFO_sm3),
			.Delay(DRAMDelay),
			.count(count_sm3),
			.o(RAM_Out_sm3 &(FIFO_Out_Type_sm3 == 2'b10)),
			.FIFOIn(FIFOIn_sm3),
			.FIFOAddrIn(FIFOAddrIn_sm3),
			.FIFOAddrOut(DRAMFIFOAddrOut_sm3),
			
			.RAM_Addr_o(RAM_Addr_DRAMFIFO_o_sm3),
			.HeadOutTime(DRAMHeadOutTime_sm3),	
			.full(DRAMFIFO_full_sm3)
			);			
	
	wire [`SIZE_RAM_LOG - 1:0] RAM_Addr_SharedFIFO_o_sm0;
	wire [15:0] SharedHeadOutTime_sm0;
	MemAccessFIFO 
	SharedFIFO_sm0(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i| (sm_i != 0)),
			
			.i(Shared_Tag2FIFO_sm0),
			.RAM_Addr_i(RAM_Addr_RAM2FIFO_sm0),
			.Delay(SharedDelay),
			.count(count_sm0),			
			.o(RAM_Out_sm0 &(FIFO_Out_Type_sm0 == 2'b11)),
			.FIFOIn(FIFOIn_sm0),
			.FIFOAddrIn(FIFOAddrIn_sm0),
			.FIFOAddrOut(SharedFIFOAddrOut_sm0),
			
			.RAM_Addr_o(RAM_Addr_SharedFIFO_o_sm0),
			.HeadOutTime(SharedHeadOutTime_sm0),	
			.full(SharedFIFO_full_sm0)
			);
	wire [`SIZE_RAM_LOG - 1:0] RAM_Addr_SharedFIFO_o_sm1;
	wire [15:0] SharedHeadOutTime_sm1;
	MemAccessFIFO 
	SharedFIFO_sm1(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i| (sm_i != 1)),
			
			.i(Shared_Tag2FIFO_sm1),
			.RAM_Addr_i(RAM_Addr_RAM2FIFO_sm1),
			.Delay(SharedDelay),
			.count(count_sm1),			
			.o(RAM_Out_sm1 &(FIFO_Out_Type_sm1 == 2'b11)),
			.FIFOIn(FIFOIn_sm1),
			.FIFOAddrIn(FIFOAddrIn_sm1),
			.FIFOAddrOut(SharedFIFOAddrOut_sm1),
			
			.RAM_Addr_o(RAM_Addr_SharedFIFO_o_sm1),
			.HeadOutTime(SharedHeadOutTime_sm1),	
			.full(SharedFIFO_full_sm1)
			);
	wire [`SIZE_RAM_LOG - 1:0] RAM_Addr_SharedFIFO_o_sm2;
	wire [15:0] SharedHeadOutTime_sm2;
	MemAccessFIFO 
	SharedFIFO_sm2(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i| (sm_i != 2)),
			
			.i(Shared_Tag2FIFO_sm2),
			.RAM_Addr_i(RAM_Addr_RAM2FIFO_sm2),
			.Delay(SharedDelay),
			.count(count_sm2),			
			.o(RAM_Out_sm2 &(FIFO_Out_Type_sm2 == 2'b11)),
			.FIFOIn(FIFOIn_sm2),
			.FIFOAddrIn(FIFOAddrIn_sm2),
			.FIFOAddrOut(SharedFIFOAddrOut_sm2),
			
			.RAM_Addr_o(RAM_Addr_SharedFIFO_o_sm2),
			.HeadOutTime(SharedHeadOutTime_sm2),	
			.full(SharedFIFO_full_sm2)
			);
	wire [`SIZE_RAM_LOG - 1:0] RAM_Addr_SharedFIFO_o_sm3;
	wire [15:0] SharedHeadOutTime_sm3;
	MemAccessFIFO 
	SharedFIFO_sm3(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i| (sm_i != 3)),
			
			.i(Shared_Tag2FIFO_sm3),
			.RAM_Addr_i(RAM_Addr_RAM2FIFO_sm3),
			.Delay(SharedDelay),
			.count(count_sm3),			
			.o(RAM_Out_sm3 &(FIFO_Out_Type_sm3 == 2'b11)),
			.FIFOIn(FIFOIn_sm3),
			.FIFOAddrIn(FIFOAddrIn_sm3),
			.FIFOAddrOut(SharedFIFOAddrOut_sm3),
			
			.RAM_Addr_o(RAM_Addr_SharedFIFO_o_sm3),
			.HeadOutTime(SharedHeadOutTime_sm3),	
			.full(SharedFIFO_full_sm3)
			);
			
			
			
			
wire [15:0] L1HeadInTime_sm0;
wire [15:0] L2HeadInTime_sm0;
wire [15:0] DRAMHeadInTime_sm0;
wire [15:0] SharedHeadInTime_sm0;
			
wire [`SIZE_RAM_LOG - 1:0] RAM_Out_Addr_sm0;
TimeCheck 
timeCheck_sm0(
			.clk(clk),
			.reset(reset),
			.stall(stall_i | (sm_i != 0)),
			.DDR3_n_rdy(DDR3_n_rdy_sm0),
			
			.LSUOut_working(LSUOut_working_sm0),
			.RAM_Addr_L1(RAM_Addr_L1FIFO_o_sm0),
			.L1HeadOutTime(L1HeadOutTime_sm0),
			.L1HeadInTime(L1HeadInTime_sm0),
			.L1FIFOAddrOut(L1FIFOAddrOut_sm0),
			
			.RAM_Addr_L2(RAM_Addr_L2FIFO_o_sm0),
			.L2HeadOutTime(L2HeadOutTime_sm0),
			.L2HeadInTime(L2HeadInTime_sm0),
			.L2FIFOAddrOut(L2FIFOAddrOut_sm0),
			
			.RAM_Addr_DRAM(RAM_Addr_DRAMFIFO_o_sm0),
			.DRAMHeadOutTime(DRAMHeadOutTime_sm0),
			.DRAMHeadInTime(DRAMHeadInTime_sm0),
			.DRAMFIFOAddrOut(DRAMFIFOAddrOut_sm0),
			
			.RAM_Addr_Shared(RAM_Addr_SharedFIFO_o_sm0),
			.SharedHeadOutTime(SharedHeadOutTime_sm0),
			.SharedHeadInTime(SharedHeadInTime_sm0),
			.SharedFIFOAddrOut(SharedFIFOAddrOut_sm0),
					
			.FIFO_Out_Type(FIFO_Out_Type_sm0),
			.RAM_Out_Addr(RAM_Out_Addr_sm0),
			.FIFOAddrOut(FIFOAddrOut_sm0),
			.RAM_Out(RAM_Out_sm0),
			.count(count_sm0)
			);



wire [15:0] L1HeadInTime_sm1;
wire [15:0] L2HeadInTime_sm1;
wire [15:0] DRAMHeadInTime_sm1;
wire [15:0] SharedHeadInTime_sm1;
			
wire [`SIZE_RAM_LOG - 1:0] RAM_Out_Addr_sm1;
TimeCheck 
timeCheck_sm1(
			.clk(clk),
			.reset(reset),
			.stall(stall_i | (sm_i != 1)),
			.DDR3_n_rdy(DDR3_n_rdy_sm1),
			
			.LSUOut_working(LSUOut_working_sm1),
			.RAM_Addr_L1(RAM_Addr_L1FIFO_o_sm1),
			.L1HeadOutTime(L1HeadOutTime_sm1),
			.L1HeadInTime(L1HeadInTime_sm1),
			.L1FIFOAddrOut(L1FIFOAddrOut_sm1),
			
			.RAM_Addr_L2(RAM_Addr_L2FIFO_o_sm1),
			.L2HeadOutTime(L2HeadOutTime_sm1),
			.L2HeadInTime(L2HeadInTime_sm1),
			.L2FIFOAddrOut(L2FIFOAddrOut_sm1),
			
			.RAM_Addr_DRAM(RAM_Addr_DRAMFIFO_o_sm1),
			.DRAMHeadOutTime(DRAMHeadOutTime_sm1),
			.DRAMHeadInTime(DRAMHeadInTime_sm1),
			.DRAMFIFOAddrOut(DRAMFIFOAddrOut_sm1),
			
			.RAM_Addr_Shared(RAM_Addr_SharedFIFO_o_sm1),
			.SharedHeadOutTime(SharedHeadOutTime_sm1),
			.SharedHeadInTime(SharedHeadInTime_sm1),
			.SharedFIFOAddrOut(SharedFIFOAddrOut_sm1),
					
			.FIFO_Out_Type(FIFO_Out_Type_sm1),
			.RAM_Out_Addr(RAM_Out_Addr_sm1),
			.FIFOAddrOut(FIFOAddrOut_sm1),
			.RAM_Out(RAM_Out_sm1),
			.count(count_sm1)
			);
			
			
wire [15:0] L1HeadInTime_sm2;
wire [15:0] L2HeadInTime_sm2;
wire [15:0] DRAMHeadInTime_sm2;
wire [15:0] SharedHeadInTime_sm2;
			
wire [`SIZE_RAM_LOG - 1:0] RAM_Out_Addr_sm2;
TimeCheck 
timeCheck_sm2(
			.clk(clk),
			.reset(reset),
			.stall(stall_i | (sm_i != 2)),
			.DDR3_n_rdy(DDR3_n_rdy_sm2),
			
			.LSUOut_working(LSUOut_working_sm2),
			.RAM_Addr_L1(RAM_Addr_L1FIFO_o_sm2),
			.L1HeadOutTime(L1HeadOutTime_sm2),
			.L1HeadInTime(L1HeadInTime_sm2),
			.L1FIFOAddrOut(L1FIFOAddrOut_sm2),
			
			.RAM_Addr_L2(RAM_Addr_L2FIFO_o_sm2),
			.L2HeadOutTime(L2HeadOutTime_sm2),
			.L2HeadInTime(L2HeadInTime_sm2),
			.L2FIFOAddrOut(L2FIFOAddrOut_sm2),
			
			.RAM_Addr_DRAM(RAM_Addr_DRAMFIFO_o_sm2),
			.DRAMHeadOutTime(DRAMHeadOutTime_sm2),
			.DRAMHeadInTime(DRAMHeadInTime_sm2),
			.DRAMFIFOAddrOut(DRAMFIFOAddrOut_sm2),
			
			.RAM_Addr_Shared(RAM_Addr_SharedFIFO_o_sm2),
			.SharedHeadOutTime(SharedHeadOutTime_sm2),
			.SharedHeadInTime(SharedHeadInTime_sm2),
			.SharedFIFOAddrOut(SharedFIFOAddrOut_sm2),
					
			.FIFO_Out_Type(FIFO_Out_Type_sm2),
			.RAM_Out_Addr(RAM_Out_Addr_sm2),
			.FIFOAddrOut(FIFOAddrOut_sm2),
			.RAM_Out(RAM_Out_sm2),
			.count(count_sm2)
			);
			
			
wire [15:0] L1HeadInTime_sm3;
wire [15:0] L2HeadInTime_sm3;
wire [15:0] DRAMHeadInTime_sm3;
wire [15:0] SharedHeadInTime_sm3;
			
wire [`SIZE_RAM_LOG - 1:0] RAM_Out_Addr_sm3;
TimeCheck 
timeCheck_sm3(
			.clk(clk),
			.reset(reset),
			.stall(stall_i | (sm_i != 3)),
			.DDR3_n_rdy(DDR3_n_rdy_sm3),
			
			.LSUOut_working(LSUOut_working_sm3),
			.RAM_Addr_L1(RAM_Addr_L1FIFO_o_sm3),
			.L1HeadOutTime(L1HeadOutTime_sm3),
			.L1HeadInTime(L1HeadInTime_sm3),
			.L1FIFOAddrOut(L1FIFOAddrOut_sm3),
			
			.RAM_Addr_L2(RAM_Addr_L2FIFO_o_sm3),
			.L2HeadOutTime(L2HeadOutTime_sm3),
			.L2HeadInTime(L2HeadInTime_sm3),
			.L2FIFOAddrOut(L2FIFOAddrOut_sm3),
			
			.RAM_Addr_DRAM(RAM_Addr_DRAMFIFO_o_sm3),
			.DRAMHeadOutTime(DRAMHeadOutTime_sm3),
			.DRAMHeadInTime(DRAMHeadInTime_sm3),
			.DRAMFIFOAddrOut(DRAMFIFOAddrOut_sm3),
			
			.RAM_Addr_Shared(RAM_Addr_SharedFIFO_o_sm3),
			.SharedHeadOutTime(SharedHeadOutTime_sm3),
			.SharedHeadInTime(SharedHeadInTime_sm3),
			.SharedFIFOAddrOut(SharedFIFOAddrOut_sm3),
					
			.FIFO_Out_Type(FIFO_Out_Type_sm3),
			.RAM_Out_Addr(RAM_Out_Addr_sm3),
			.FIFOAddrOut(FIFOAddrOut_sm3),
			.RAM_Out(RAM_Out_sm3),
			.count(count_sm3)
			);
		
	wire [`SIZE_CORE + `NUM_WARP_LOG + `SIZE_REGFILE_BR + 2 : 0] InfoRamInfo_o_sm0;
	wire [`SIZE_CORE * `SIZE_ADDR - 1 :0 ] InfoRamAddr_o_sm0;
	wire [`SIZE_CORE * `SIZE_DATA - 1 :0 ] InfoRamData_o_sm0;
	InfoRAM 
	infoRAM_sm0(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i | (sm_i != 0)),
			
			.RAM_Out_Addr(RAM_Out_Addr_sm0),
			.InfoRamInfo_i(GlobalInfoPacket_o_sm0),
			.InfoRamAddr_i(GlobalAddrPacket_o_sm0),
			.InfoRamData_i(GlobalStoreDataPacket_o_sm0),
			.RAM_Write(CoalesceWorking_sm0),
			.RAM_Out(RAM_Out_sm0),
			
			.addr_write(RAM_Addr_RAM2FIFO_sm0),
			.InfoRamFull(InfoRamFull_sm0),
			.InfoRamInfo_o(InfoRamInfo_o_sm0),
			.InfoRamAddr_o(InfoRamAddr_o_sm0),
			.InfoRamData_o(InfoRamData_o_sm0)
			);		
	wire [`SIZE_CORE + `NUM_WARP_LOG + `SIZE_REGFILE_BR + 2:0] InfoRamInfo_o_sm1;
	wire [`SIZE_CORE * `SIZE_ADDR - 1 :0 ] InfoRamAddr_o_sm1;
	wire [`SIZE_CORE * `SIZE_DATA - 1 :0 ] InfoRamData_o_sm1;
	InfoRAM 
	infoRAM_sm1(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i | (sm_i != 1)),
			
			.RAM_Out_Addr(RAM_Out_Addr_sm1),
			.InfoRamInfo_i(GlobalInfoPacket_o_sm1),
			.InfoRamAddr_i(GlobalAddrPacket_o_sm1),
			.InfoRamData_i(GlobalStoreDataPacket_o_sm1),
			.RAM_Write(CoalesceWorking_sm1),
			.RAM_Out(RAM_Out_sm1),
			
			.addr_write(RAM_Addr_RAM2FIFO_sm1),
			.InfoRamFull(InfoRamFull_sm1),
			.InfoRamInfo_o(InfoRamInfo_o_sm1),
			.InfoRamAddr_o(InfoRamAddr_o_sm1),
			.InfoRamData_o(InfoRamData_o_sm1)
			);	
	wire [`SIZE_CORE + `NUM_WARP_LOG + `SIZE_REGFILE_BR + 2:0] InfoRamInfo_o_sm2;
	wire [`SIZE_CORE * `SIZE_ADDR - 1 :0 ] InfoRamAddr_o_sm2;
	wire [`SIZE_CORE * `SIZE_DATA - 1 :0 ] InfoRamData_o_sm2;
	InfoRAM 
	infoRAM_sm2(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i | (sm_i != 2)),
			
			.RAM_Out_Addr(RAM_Out_Addr_sm2),
			.InfoRamInfo_i(GlobalInfoPacket_o_sm2),
			.InfoRamAddr_i(GlobalAddrPacket_o_sm2),
			.InfoRamData_i(GlobalStoreDataPacket_o_sm2),
			.RAM_Write(CoalesceWorking_sm2),
			.RAM_Out(RAM_Out_sm2),
			
			.addr_write(RAM_Addr_RAM2FIFO_sm2),
			.InfoRamFull(InfoRamFull_sm2),
			.InfoRamInfo_o(InfoRamInfo_o_sm2),
			.InfoRamAddr_o(InfoRamAddr_o_sm2),
			.InfoRamData_o(InfoRamData_o_sm2)
			);	
			
	wire [`SIZE_CORE + `NUM_WARP_LOG + `SIZE_REGFILE_BR + 2:0] InfoRamInfo_o_sm3;
	wire [`SIZE_CORE * `SIZE_ADDR - 1 :0 ] InfoRamAddr_o_sm3;
	wire [`SIZE_CORE * `SIZE_DATA - 1 :0 ] InfoRamData_o_sm3;
	InfoRAM 
	infoRAM_sm3(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i | (sm_i != 3)),
			
			.RAM_Out_Addr(RAM_Out_Addr_sm3),
			.InfoRamInfo_i(GlobalInfoPacket_o_sm3),
			.InfoRamAddr_i(GlobalAddrPacket_o_sm3),
			.InfoRamData_i(GlobalStoreDataPacket_o_sm3),
			.RAM_Write(CoalesceWorking_sm3),
			.RAM_Out(RAM_Out_sm3),
			
			.addr_write(RAM_Addr_RAM2FIFO_sm3),
			.InfoRamFull(InfoRamFull_sm3),
			.InfoRamInfo_o(InfoRamInfo_o_sm3),
			.InfoRamAddr_o(InfoRamAddr_o_sm3),
			.InfoRamData_o(InfoRamData_o_sm3)
			);	

	
			
	StallControl 
	stallControl_sm0(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i | (sm_i != 0)),
			.DDR3_rdy(DDR3_rdy),
			.DDR3_w_rdy(DDR3_w_rdy),
			.LSUOut2DDR3_en(load_o_sm0 | store_o_sm0),
			.SAME_i(LSUOutSAME_sm0),
			
			.DDR3_n_rdy(DDR3_n_rdy_sm0)
			);
	StallControl 
	stallControl_sm1(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i | (sm_i != 1)),
			.DDR3_rdy(DDR3_rdy),
			.DDR3_w_rdy(DDR3_w_rdy),
			.LSUOut2DDR3_en(load_o_sm1 | store_o_sm1),
			.SAME_i(LSUOutSAME_sm0),
			
			.DDR3_n_rdy(DDR3_n_rdy_sm1)
			);
	StallControl 
	stallControl_sm2(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i | (sm_i != 2)),
			.DDR3_rdy(DDR3_rdy),
			.DDR3_w_rdy(DDR3_w_rdy),
			.LSUOut2DDR3_en(load_o_sm2 | store_o_sm2),
			.SAME_i(LSUOutSAME_sm0),
			
			.DDR3_n_rdy(DDR3_n_rdy_sm2)
			);
	StallControl 
	stallControl_sm3(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i | (sm_i != 3)),
			.DDR3_rdy(DDR3_rdy),
			.DDR3_w_rdy(DDR3_w_rdy),
			.LSUOut2DDR3_en(load_o_sm3 | store_o_sm3),
			.SAME_i(LSUOutSAME_sm0),
			
			.DDR3_n_rdy(DDR3_n_rdy_sm3)
			);
			
			
	wire [`SIZE_CORE - 1 : 0] lane_mask_o_sm0;
	wire [`SIZE_CORE * `SIZE_ADDR - 1 :0 ] InfoRamAddr_o_o_sm0;
	wire [27:0] RAM2DDR3_addr_o_sm0;
	wire [63:0] RAM2DDR3_mask_o_sm0;
	wire [511:0] RAM2DDR3_din_o_sm0;
	wire RAM2DDR3_we_o_sm0;
	wire [`NUM_WARP_LOG - 1 : 0 ]RAM2DDR3_ldstWarp_o_sm0;
	wire [`SIZE_REGFILE_BR - 1 : 0 ] RAM2DDR3_ldstReg_o_sm0;

	
	LSUOutUnit 
	LSUOutUnit_sm0(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i | (sm_i != 0)),
			
			.DDR3OutPacketWorking_i(DDR3OutPacketWorking_i),
			.RAM_Out(RAM_Out_sm0),
			.InfoRamInfo_o(InfoRamInfo_o_sm0),
			.InfoRamAddr_o(InfoRamAddr_o_sm0),
			.InfoRamData_o(InfoRamData_o_sm0),
			.DDR3_rdy(DDR3_rdy),
			.DDR3_w_rdy(DDR3_w_rdy),
			.DDR3_n_rdy(DDR3_n_rdy_sm0),
			
			.lane_mask_o(lane_mask_o_sm0),
			.InfoRamAddr_o_o(InfoRamAddr_o_o_sm0),
			.RAM2DDR3_addr_o(RAM2DDR3_addr_o_sm0),
			.RAM2DDR3_mask_o(RAM2DDR3_mask_o_sm0),
			.RAM2DDR3_din_o(RAM2DDR3_din_o_sm0), 
			.RAM2DDR3_we_o(RAM2DDR3_we_o_sm0),
			.RAM2DDR3_ldstWarp_o(RAM2DDR3_ldstWarp_o_sm0),
			.RAM2DDR3_ldstReg_o(RAM2DDR3_ldstReg_o_sm0),
			.load_o(load_o_sm0),
			.store_o(store_o_sm0),
			.LSUOut_working(LSUOut_working_sm0),
			.SAME(LSUOutSAME_sm0)
    );
	
	wire [`SIZE_CORE - 1 : 0] lane_mask_o_sm1;
	wire [`SIZE_CORE * `SIZE_ADDR - 1 :0 ] InfoRamAddr_o_o_sm1;
	wire [27:0] RAM2DDR3_addr_o_sm1;
	wire [63:0] RAM2DDR3_mask_o_sm1;
	wire [511:0] RAM2DDR3_din_o_sm1;
	wire RAM2DDR3_we_o_sm1;
	wire [`NUM_WARP_LOG - 1 : 0 ]RAM2DDR3_ldstWarp_o_sm1;
	wire [`SIZE_REGFILE_BR - 1 : 0 ] RAM2DDR3_ldstReg_o_sm1;

	LSUOutUnit 
	LSUOutUnit_sm1(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i | (sm_i != 1)),
			
			.DDR3OutPacketWorking_i(DDR3OutPacketWorking_i),
			.RAM_Out(RAM_Out_sm1),
			.InfoRamInfo_o(InfoRamInfo_o_sm1),
			.InfoRamAddr_o(InfoRamAddr_o_sm1),
			.InfoRamData_o(InfoRamData_o_sm1),
			.DDR3_rdy(DDR3_rdy),
			.DDR3_w_rdy(DDR3_w_rdy),
			.DDR3_n_rdy(DDR3_n_rdy_sm1),
			
			.lane_mask_o(lane_mask_o_sm1),
			.InfoRamAddr_o_o(InfoRamAddr_o_o_sm1),
			.RAM2DDR3_addr_o(RAM2DDR3_addr_o_sm1),
			.RAM2DDR3_mask_o(RAM2DDR3_mask_o_sm1),
			.RAM2DDR3_din_o(RAM2DDR3_din_o_sm1), 
			.RAM2DDR3_we_o(RAM2DDR3_we_o_sm1),
			.RAM2DDR3_ldstWarp_o(RAM2DDR3_ldstWarp_o_sm1),
			.RAM2DDR3_ldstReg_o(RAM2DDR3_ldstReg_o_sm1),
			.load_o(load_o_sm1),
			.store_o(store_o_sm1),
			.LSUOut_working(LSUOut_working_sm1),
			.SAME(LSUOutSAME_sm1)
    );
	
	wire [`SIZE_CORE - 1 : 0] lane_mask_o_sm2;
	wire [`SIZE_CORE * `SIZE_ADDR - 1 :0 ] InfoRamAddr_o_o_sm2;
	wire [27:0] RAM2DDR3_addr_o_sm2;
	wire [63:0] RAM2DDR3_mask_o_sm2;
	wire [511:0] RAM2DDR3_din_o_sm2;
	wire RAM2DDR3_we_o_sm2;
	wire [`NUM_WARP_LOG - 1 : 0 ]RAM2DDR3_ldstWarp_o_sm2;
	wire [`SIZE_REGFILE_BR - 1 : 0 ] RAM2DDR3_ldstReg_o_sm2;

	LSUOutUnit 
	LSUOutUnit_sm2(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i | (sm_i != 2)),
			
			.DDR3OutPacketWorking_i(DDR3OutPacketWorking_i),
			.RAM_Out(RAM_Out_sm2),
			.InfoRamInfo_o(InfoRamInfo_o_sm2),
			.InfoRamAddr_o(InfoRamAddr_o_sm2),
			.InfoRamData_o(InfoRamData_o_sm2),
			.DDR3_rdy(DDR3_rdy),
			.DDR3_w_rdy(DDR3_w_rdy),
			.DDR3_n_rdy(DDR3_n_rdy_sm2),
			
			.lane_mask_o(lane_mask_o_sm2),
			.InfoRamAddr_o_o(InfoRamAddr_o_o_sm2),
			.RAM2DDR3_addr_o(RAM2DDR3_addr_o_sm2),
			.RAM2DDR3_mask_o(RAM2DDR3_mask_o_sm2),
			.RAM2DDR3_din_o(RAM2DDR3_din_o_sm2), 
			.RAM2DDR3_we_o(RAM2DDR3_we_o_sm2),
			.RAM2DDR3_ldstWarp_o(RAM2DDR3_ldstWarp_o_sm2),
			.RAM2DDR3_ldstReg_o(RAM2DDR3_ldstReg_o_sm2),
			.load_o(load_o_sm2),
			.store_o(store_o_sm2),
			.LSUOut_working(LSUOut_working_sm2),
			.SAME(LSUOutSAME_sm2)
    );
	

	LSUOutUnit 
	LSUOutUnit_sm3(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i | (sm_i != 3)),
			
			.DDR3OutPacketWorking_i(DDR3OutPacketWorking_i),
			.RAM_Out(RAM_Out_sm3),
			.InfoRamInfo_o(InfoRamInfo_o_sm3),
			.InfoRamAddr_o(InfoRamAddr_o_sm3),
			.InfoRamData_o(InfoRamData_o_sm3),
			.DDR3_rdy(DDR3_rdy),
			.DDR3_w_rdy(DDR3_w_rdy),
			.DDR3_n_rdy(DDR3_n_rdy_sm3),
			
			.lane_mask_o(lane_mask_o_sm3),
			.InfoRamAddr_o_o(InfoRamAddr_o_o_sm3),
			.RAM2DDR3_addr_o(RAM2DDR3_addr_o_sm3),
			.RAM2DDR3_mask_o(RAM2DDR3_mask_o_sm3),
			.RAM2DDR3_din_o(RAM2DDR3_din_o_sm3), 
			.RAM2DDR3_we_o(RAM2DDR3_we_o_sm3),
			.RAM2DDR3_ldstWarp_o(RAM2DDR3_ldstWarp_o_sm3),
			.RAM2DDR3_ldstReg_o(RAM2DDR3_ldstReg_o_sm3),
			.load_o(load_o_sm3),
			.store_o(store_o_sm3),
			.LSUOut_working(LSUOut_working_sm3),
			.SAME(LSUOutSAME_sm3)
    );
endmodule
