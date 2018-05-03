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

module LoadStoreUnit(
					input reset,
					input clk,
					
					//input stall_i,	//Only stall the upper part of this module
					
					input load_i,
					input store_i,
					
					input stall_i,
					
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
					
					output [`NUM_WARP_LOG-1:0] loadWarp_o,
					output loadPacketValid_o,
					output [`SIZE_CORE-1:0] loadMask_o,					
					output [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane0_o,
					output [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane1_o,
					output [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane2_o,
					output [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane3_o,
					output [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane4_o,
					output [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane5_o,
					output [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane6_o,
					output [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane7_o,
					
					output freeze_o
					
					//output
					);
	
	wire stall;	// freeze thus stall
	assign stall = stall_i;//freeze_o;//??? 
	
	wire load_l0;
	wire store_l0;
	wire [`LDST_SPACE_LOG-1:0] ldstSpace_l0;
	wire [`LDST_TYPES_LOG-1:0] ldstSize_l0;
	wire [`NUM_WARP_LOG-1:0] warp_l0;
	wire [`SIZE_CORE-1:0] mask_l0;
	
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr0_l0;
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr1_l0;
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr2_l0;
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr3_l0;
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr4_l0;
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr5_l0;
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr6_l0;
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr7_l0;

	wire [`SIZE_REGFILE_BR-1:0] loadReg_l0;
	
	wire [`SIZE_DATA-1:0] storeData0_l0;
	wire [`SIZE_DATA-1:0] storeData1_l0;
	wire [`SIZE_DATA-1:0] storeData2_l0;
	wire [`SIZE_DATA-1:0] storeData3_l0;
	wire [`SIZE_DATA-1:0] storeData4_l0;
	wire [`SIZE_DATA-1:0] storeData5_l0;
	wire [`SIZE_DATA-1:0] storeData6_l0;
	wire [`SIZE_DATA-1:0] storeData7_l0;	

	
	assign load_l0 = load_i;
	assign store_l0 = store_i;
	assign warp_l0 = ldstWarp_i;
	assign packetValid_l0 = ldstPacketValid_i;
	assign mask_l0 = ldstMask_i;
	
	assign addr0_l0 = ldstPacketLane0_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
	assign addr1_l0 = ldstPacketLane1_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
	assign addr2_l0 = ldstPacketLane2_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
	assign addr3_l0 = ldstPacketLane3_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
	assign addr4_l0 = ldstPacketLane4_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
	assign addr5_l0 = ldstPacketLane5_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
	assign addr6_l0 = ldstPacketLane6_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
	assign addr7_l0 = ldstPacketLane7_i[`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];
	
	assign loadReg_l0 = ldstPacketLane0_i[`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG];//only need lane0
	assign ldstSpace_l0 = ldstSpace_i;
	assign ldstSize_l0 = ldstPacketLane0_i[`LDST_TYPES_LOG-1:0];
	
	assign storeData0_l0 = ldstPacketLane0_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
	assign storeData1_l0 = ldstPacketLane1_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
	assign storeData2_l0 = ldstPacketLane2_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
	assign storeData3_l0 = ldstPacketLane3_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
	assign storeData4_l0 = ldstPacketLane4_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
	assign storeData5_l0 = ldstPacketLane5_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
	assign storeData6_l0 = ldstPacketLane6_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
	assign storeData7_l0 = ldstPacketLane7_i[`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
									:`LDST_SPACE_LOG+`LDST_TYPES_LOG];
	
	
	wire load_l1;
	wire store_l1;
	wire [`LDST_SPACE_LOG-1:0] ldstSpace_l1;
	wire [`LDST_TYPES_LOG-1:0] ldstSize_l1;
	wire [`NUM_WARP_LOG-1:0] warp_l1;
	wire packetValid_l1;
	wire [`SIZE_CORE-1:0] mask_l1;
	
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr0_l1;
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr1_l1;
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr2_l1;
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr3_l1;
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr4_l1;
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr5_l1;
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr6_l1;
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr7_l1;

	wire [`SIZE_REGFILE_BR-1:0] loadReg_l1;
	
	wire [`SIZE_DATA-1:0] storeData0_l1;
	wire [`SIZE_DATA-1:0] storeData1_l1;
	wire [`SIZE_DATA-1:0] storeData2_l1;
	wire [`SIZE_DATA-1:0] storeData3_l1;
	wire [`SIZE_DATA-1:0] storeData4_l1;
	wire [`SIZE_DATA-1:0] storeData5_l1;
	wire [`SIZE_DATA-1:0] storeData6_l1;
	wire [`SIZE_DATA-1:0] storeData7_l1;	
	
	wire [`SIZE_CORE_LOG-1:0] sizeSeg_l1;
	
	
	Coalesce
		coalesce(
				.reset(reset),
				.clk(clk),
				
				.stall_i(stall),
				
				.load_i(load_l0),
				.store_i(store_l0),
				.ldstSpace_i(ldstSpace_l0),
				.ldstSize_i(ldstSize_l0),
				.warp_i(warp_l0),
				.packetValid_i(packetValid_l0),
				.mask_i(mask_l0),
				.addr0_i(addr0_l0),
				.addr1_i(addr1_l0),
				.addr2_i(addr2_l0),
				.addr3_i(addr3_l0),
				.addr4_i(addr4_l0),
				.addr5_i(addr5_l0),
				.addr6_i(addr6_l0),
				.addr7_i(addr7_l0),
				.loadReg_i(loadReg_l0),
				.storeData0_i(storeData0_l0),
				.storeData1_i(storeData1_l0),
				.storeData2_i(storeData2_l0),
				.storeData3_i(storeData3_l0),
				.storeData4_i(storeData4_l0),
				.storeData5_i(storeData5_l0),
				.storeData6_i(storeData6_l0),
				.storeData7_i(storeData7_l0),
				
				.load_o(load_l1),
				.store_o(store_l1),
				.ldstSpace_o(ldstSpace_l1),
				.ldstSize_o(ldstSize_l1),
				.warp_o(warp_l1),
				.packetValid_o(packetValid_l1),
				.mask_o(mask_l1),
				.addr0_o(addr0_l1),
				.addr1_o(addr1_l1),
				.addr2_o(addr2_l1),
				.addr3_o(addr3_l1),
				.addr4_o(addr4_l1),
				.addr5_o(addr5_l1),
				.addr6_o(addr6_l1),
				.addr7_o(addr7_l1),
				.loadReg_o(loadReg_l1),
				.storeData0_o(storeData0_l1),
				.storeData1_o(storeData1_l1),
				.storeData2_o(storeData2_l1),
				.storeData3_o(storeData3_l1),
				.storeData4_o(storeData4_l1),
				.storeData5_o(storeData5_l1),
				.storeData6_o(storeData6_l1),
				.storeData7_o(storeData7_l1),
				
				.sizeSeg_o(sizeSeg_l1)
			);
	
	
	
	
	wire load_mafifo;
	wire store_mafifo;
	wire [`LDST_SPACE_LOG-1:0] ldstSpace_mafifo;
	wire [`LDST_TYPES_LOG-1:0] ldstSize_mafifo;
	wire [`NUM_WARP_LOG-1:0] warp_mafifo;
	wire packetValid_mafifo;
	wire [`SIZE_CORE-1:0] mask_mafifo;
	
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr0_mafifo;
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr1_mafifo;
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr2_mafifo;
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr3_mafifo;
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr4_mafifo;
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr5_mafifo;
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr6_mafifo;
	wire [`SIZE_MEM_BYTES_LOG-1:0] addr7_mafifo;

	wire [`SIZE_REGFILE_BR-1:0] loadReg_mafifo;
	
	wire [`SIZE_DATA-1:0] storeData0_mafifo;
	wire [`SIZE_DATA-1:0] storeData1_mafifo;
	wire [`SIZE_DATA-1:0] storeData2_mafifo;
	wire [`SIZE_DATA-1:0] storeData3_mafifo;
	wire [`SIZE_DATA-1:0] storeData4_mafifo;
	wire [`SIZE_DATA-1:0] storeData5_mafifo;
	wire [`SIZE_DATA-1:0] storeData6_mafifo;
	wire [`SIZE_DATA-1:0] storeData7_mafifo;	
	
	wire [`SIZE_CORE_LOG-1:0] sizeSeg_mafifo;
	
	wire busy_clip;	
	wire popValid_mafifo;
	wire full_mafifo;
	wire empty_mafifo;
	wire mafifo;//useless
	
	wire push_en_l1;
	assign push_en_l1 = (load_l1 || store_l1) && packetValid_l1;
	//Only push & pop when (load || store) == 1 
	MemAccessFIFO
	 memAccessFIFO(
					.reset(reset),
					.clk(clk),
					
					.stall_i(stall),
				
				.sizeSeg_i(sizeSeg_l1),
				.load_i(load_l1),
				.store_i(store_l1),
				.valid_i(1'b1),//useless
				//.ldstSpace_i(ldstSpace_l1),
				//.ldstSize_i(ldstSize_l1),
				.warp_i(warp_l1),
				.packetValid_i(packetValid_l1),
				.mask_i(mask_l1),
				.addr0_i(addr0_l1),
				.addr1_i(addr1_l1),
				.addr2_i(addr2_l1),
				.addr3_i(addr3_l1),
				.addr4_i(addr4_l1),
				.addr5_i(addr5_l1),
				.addr6_i(addr6_l1),
				.addr7_i(addr7_l1),
				.loadReg_i(loadReg_l1),
				.storeData0_i(storeData0_l1),
				.storeData1_i(storeData1_l1),
				.storeData2_i(storeData2_l1),
				.storeData3_i(storeData3_l1),
				.storeData4_i(storeData4_l1),
				.storeData5_i(storeData5_l1),
				.storeData6_i(storeData6_l1),
				.storeData7_i(storeData7_l1),
				
				.sizeSeg_o(sizeSeg_mafifo),
				.load_o(load_mafifo),
				.store_o(store_mafifo),
				.valid_o(valid_mafifo),//useless
				//.ldstSpace_o(ldstSpace_mafifo),
				//.ldstSize_o(ldstSize_mafifo),
				.warp_o(warp_mafifo),
				.packetValid_o(packetValid_mafifo),
				.mask_o(mask_mafifo),
				.addr0_o(addr0_mafifo),
				.addr1_o(addr1_mafifo),
				.addr2_o(addr2_mafifo),
				.addr3_o(addr3_mafifo),
				.addr4_o(addr4_mafifo),
				.addr5_o(addr5_mafifo),
				.addr6_o(addr6_mafifo),
				.addr7_o(addr7_mafifo),
				.loadReg_o(loadReg_mafifo),
				.storeData0_o(storeData0_mafifo),
				.storeData1_o(storeData1_mafifo),
				.storeData2_o(storeData2_mafifo),
				.storeData3_o(storeData3_mafifo),
				.storeData4_o(storeData4_mafifo),
				.storeData5_o(storeData5_mafifo),
				.storeData6_o(storeData6_mafifo),
				.storeData7_o(storeData7_mafifo),	
					
					.push_en_i(push_en_l1),//push, only when valid
					.pop_en_i(~busy_clip),
					
					.popValid_o(popValid_mafifo),			  
					.full_o(full_mafifo),
					.empty_o(empty_mafifo)	
				);
	
	
	wire freeze_clip;
	
	wire valid_clip;
	wire [`NUM_WARP_LOG-1:0] warp_clip;
	wire packetValid_clip;
	wire [`SIZE_CORE-1:0] mask_clip;

	wire [`SIZE_REGFILE_BR-1:0] loadReg_clip;
	
	wire [`SIZE_DATA-1:0] loadData0_clip;
	wire [`SIZE_DATA-1:0] loadData1_clip;
	wire [`SIZE_DATA-1:0] loadData2_clip;
	wire [`SIZE_DATA-1:0] loadData3_clip;
	wire [`SIZE_DATA-1:0] loadData4_clip;
	wire [`SIZE_DATA-1:0] loadData5_clip;
	wire [`SIZE_DATA-1:0] loadData6_clip;
	wire [`SIZE_DATA-1:0] loadData7_clip;

	
	MemAccessClip
		globalMemAccessClip(
					.reset(reset),
					.clk(clk),
					
					.stall_i(1'b0),
					
					.load_i(load_mafifo),
					.store_i(store_mafifo),
					
					.valid_i(packetValid_mafifo),
					
					.warp_i(warp_mafifo),
					.packetValid_i(packetValid_mafifo),
					.mask_i(mask_mafifo),
					.addr0_i(addr0_mafifo),
					.addr1_i(addr1_mafifo),
					.addr2_i(addr2_mafifo),
					.addr3_i(addr3_mafifo),
					.addr4_i(addr4_mafifo),
					.addr5_i(addr5_mafifo),
					.addr6_i(addr6_mafifo),
					.addr7_i(addr7_mafifo),
					.loadReg_i(loadReg_mafifo),
					.storeData0_i(storeData0_mafifo),
					.storeData1_i(storeData1_mafifo),
					.storeData2_i(storeData2_mafifo),
					.storeData3_i(storeData3_mafifo),
					.storeData4_i(storeData4_mafifo),
					.storeData5_i(storeData5_mafifo),
					.storeData6_i(storeData6_mafifo),
					.storeData7_i(storeData7_mafifo),
					
					.sizeSeg_i(sizeSeg_mafifo),
				
					.freeze_o(freeze_clip),
					.busy_o(busy_clip),
					
					.loadValid_o(loadValid_clip),
					.warp_o(warp_clip),
					.packetValid_o(packetValid_clip),
					.mask_o(mask_clip),
					.loadReg_o(loadReg_clip),
					.loadData0_o(loadData0_clip),
					.loadData1_o(loadData1_clip),
					.loadData2_o(loadData2_clip),
					.loadData3_o(loadData3_clip),
					.loadData4_o(loadData4_clip),
					.loadData5_o(loadData5_clip),
					.loadData6_o(loadData6_clip),
					.loadData7_o(loadData7_clip)				
				);
	
	
	assign freeze_o = freeze_clip;
	
	assign loadWarp_o = warp_clip;
	assign loadPacketValid_o = loadValid_clip;
	assign loadMask_o = mask_clip;
	assign loadPacketLane0_o = {
								loadData0_clip,
								loadReg_clip
								};
	assign loadPacketLane1_o = {
								loadData1_clip,
								loadReg_clip
								};
	assign loadPacketLane2_o = {
								loadData2_clip,
								loadReg_clip
								};
	assign loadPacketLane3_o = {
								loadData3_clip,
								loadReg_clip
								};
	assign loadPacketLane4_o = {
								loadData4_clip,
								loadReg_clip
								};
	assign loadPacketLane5_o = {
								loadData5_clip,
								loadReg_clip
								};
	assign loadPacketLane6_o = {
								loadData6_clip,
								loadReg_clip
								};
	assign loadPacketLane7_o = {
								loadData7_clip,
								loadReg_clip
								};
	
	
endmodule
					