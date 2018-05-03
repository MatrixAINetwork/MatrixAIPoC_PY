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
module TestBench;
			reg reset;
			reg clk;
					
			//reg stall_i,	//Only stall the upper part of this module
					
			reg load_i;
			reg store_i;
			reg stall_i;
 
			reg [`NUM_WARP_LOG-1:0] ldstWarp_i;
			reg ldstPacketValid_i;
			reg [`SIZE_CORE-1:0] ldstMask_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane0_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane1_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane2_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane3_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane4_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane5_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane6_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane7_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane8_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane9_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane10_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane11_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane12_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane13_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane14_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane15_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane16_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane17_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane18_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane19_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane20_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane21_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane22_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane23_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane24_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane25_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane26_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane27_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane28_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane29_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane30_i;
			reg [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1:0]ldstPacketLane31_i;

			wire [`SIZE_CORE + `NUM_WARP_LOG + `SIZE_REGFILE_BR + 2:0] InfoRamInfo_o;
			wire [`SIZE_CORE * `SIZE_ADDR - 1 :0 ] InfoRamAddr_o;
			wire [`SIZE_CORE * `SIZE_DATA - 1 :0 ] InfoRamData_o;
			wire stall_input;//不能给输入信�
			wire FIFO_full; //外面stall
	
	
	
	initial begin
		clk = 1;
		reset = 1;
		stall_i = 0;
		ldstPacketLane0_i = 0;
		ldstPacketLane1_i = 0;
		ldstPacketLane2_i = 0;
		ldstPacketLane3_i = 0;
		ldstPacketLane4_i = 0;
		ldstPacketLane5_i = 0;
		ldstPacketLane6_i = 0;
		ldstPacketLane7_i = 0;
		ldstPacketLane8_i = 0;
		ldstPacketLane9_i = 0;
		ldstPacketLane10_i = 0;
		ldstPacketLane11_i = 0;
		ldstPacketLane12_i = 0;
		ldstPacketLane13_i = 0;
		ldstPacketLane14_i = 0;
		ldstPacketLane15_i = 0;
		ldstPacketLane16_i = 0;
		ldstPacketLane17_i = 0;
		ldstPacketLane18_i = 0;
		ldstPacketLane19_i = 0;
		ldstPacketLane20_i = 0;
		ldstPacketLane21_i = 0;
		ldstPacketLane22_i = 0;
		ldstPacketLane23_i = 0;
		ldstPacketLane24_i = 0;
		ldstPacketLane25_i = 0;
		ldstPacketLane26_i = 0;
		ldstPacketLane27_i = 0;
		ldstPacketLane28_i = 0;
		ldstPacketLane29_i = 0;
		ldstPacketLane30_i = 0;
		ldstPacketLane31_i = 0;
		
	end
	reg [1:0] sm_i;
	initial fork 
		forever # 5 clk <= ~clk;
		#20 reset <= 0;
		#20 sm_i <= 0 ;
		#30 load_i <= 0;
		#30 store_i <= 0;
		#41 store_i <= 1;
		#51 store_i <= 0;
		
		#7000 sm_i <= 1;
		#8001 load_i <= 1;
		#8500 load_i <= 0;

		#40 ldstWarp_i <= 25;
		#40 ldstPacketValid_i <= 1; 
		#40 ldstMask_i <= 32'b00001111_00001111_00001111_00001111;
	#40 ldstPacketLane0_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000001_00000000,2'b00,2'b00};
	#40 ldstPacketLane1_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane2_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane3_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane4_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane5_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane6_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane7_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane8_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane9_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane10_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane11_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane12_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane13_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane14_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane15_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane16_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane17_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane18_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane19_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane20_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane21_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane22_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane23_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane24_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane25_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane26_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane27_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane28_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane29_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane30_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};
	#40 ldstPacketLane31_i <= { 32'b00000000_01010101_10101010_11111100,5'b10101,
					32'b00000000_00000000_00000000_00000000,2'b00,2'b00};

		
	join
 
	
	
	wire [`SIZE_CORE - 1 : 0 ] lane_mask;		
	wire [27:0] RAM2DDR3_addr;
	wire [63:0] RAM2DDR3_mask;
	wire [511:0] RAM2DDR3_din;
	wire RAM2DDR3_we;
	wire [`NUM_WARP_LOG - 1 :0] RAM2DDR3_ldstWarp;
	wire [`SIZE_REGFILE_BR - 1 :0] RAM2DDR3_ldstReg;
	wire load;
	wire [`SIZE_ADDR * `SIZE_CORE - 1 : 0 ] InfoRamAddr_o_o;
	
	
	LSU LSU(
			.reset(reset),
			.clk(clk),
					
			//reg stall_i,	//Only stall the upper part of this module
					
			.load_i(load_i),
			.store_i(store_i),
					
			.stall_i(stall_i),
			.DDR3_rdy(DDR3_rdy),
			.DDR3_w_rdy(DDR3_w_rdy),
			.sm_i(sm_i),
			.ldstWarp_i(ldstWarp_i),
			.ldstPacketValid_i(ldstPacketValid_i),
			.ldstMask_i(ldstMask_i),
			.ldstPacketLane0_i(ldstPacketLane0_i),
			.ldstPacketLane1_i(ldstPacketLane1_i),
			.ldstPacketLane2_i(ldstPacketLane2_i),
			.ldstPacketLane3_i(ldstPacketLane3_i),
			.ldstPacketLane4_i(ldstPacketLane4_i),
			.ldstPacketLane5_i(ldstPacketLane5_i),
			.ldstPacketLane6_i(ldstPacketLane6_i),
			.ldstPacketLane7_i(ldstPacketLane7_i),
			.ldstPacketLane8_i(ldstPacketLane8_i),
			.ldstPacketLane9_i(ldstPacketLane9_i),
			.ldstPacketLane10_i(ldstPacketLane10_i),
			.ldstPacketLane11_i(ldstPacketLane11_i),
			.ldstPacketLane12_i(ldstPacketLane12_i),
			.ldstPacketLane13_i(ldstPacketLane13_i),
			.ldstPacketLane14_i(ldstPacketLane14_i),
			.ldstPacketLane15_i(ldstPacketLane15_i),
			.ldstPacketLane16_i(ldstPacketLane16_i),
			.ldstPacketLane17_i(ldstPacketLane17_i),
			.ldstPacketLane18_i(ldstPacketLane18_i),
			.ldstPacketLane19_i(ldstPacketLane19_i),
			.ldstPacketLane20_i(ldstPacketLane20_i),
			.ldstPacketLane21_i(ldstPacketLane21_i),
			.ldstPacketLane22_i(ldstPacketLane22_i),
			.ldstPacketLane23_i(ldstPacketLane23_i),
			.ldstPacketLane24_i(ldstPacketLane24_i),
			.ldstPacketLane25_i(ldstPacketLane25_i),
			.ldstPacketLane26_i(ldstPacketLane26_i),
			.ldstPacketLane27_i(ldstPacketLane27_i),
			.ldstPacketLane28_i(ldstPacketLane28_i),
			.ldstPacketLane29_i(ldstPacketLane29_i),
			.ldstPacketLane30_i(ldstPacketLane30_i),
			.ldstPacketLane31_i(ldstPacketLane31_i),


					
			.InfoRamAddr_o_o(InfoRamAddr_o_o),		
			.lane_mask_o(lane_mask),		
			.RAM2DDR3_addr_o(RAM2DDR3_addr),
			.RAM2DDR3_mask_o(RAM2DDR3_mask),
			.RAM2DDR3_din_o(RAM2DDR3_din),
			.RAM2DDR3_we_o(RAM2DDR3_we),
			.RAM2DDR3_ldstWarp_o(RAM2DDR3_ldstWarp),
			.RAM2DDR3_ldstReg_o(RAM2DDR3_ldstReg),
			.load_o(load),
			.stall_input(stall_input)//不能给输入信�
				//output
	);
	wire [511:0] DDR3_dout;
	wire  rdy;				//read ready
	wire  w_rdy;			//write ready
	DDR3_substitute DDR3_substitute(
			.clk(clk),
			.reset(reset),
			
			.addr(RAM2DDR3_addr),		//Read address
			.mask(RAM2DDR3_mask),
			.din(RAM2DDR3_din),
			.we(RAM2DDR3_we),				//write enable
					
			.dout(DDR3_dout),
			.rdy(DDR3_rdy),				//read ready
			.w_rdy(DDR3_w_rdy),			//write ready
			
			.initDone(DDR3_initDone)			//initDone <= 0 after reset; initDone <= 1 when initialization is done
	);
				wire [`SIZE_REGFILE_BR - 1 : 0] loadWarp_o;
			wire loadPacketValid_o;
			wire [`SIZE_CORE - 1 : 0] loadMask_o;					
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane0_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane1_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane2_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane3_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane4_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane5_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane6_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane7_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane8_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane9_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane10_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane11_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane12_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane13_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane14_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane15_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane16_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane17_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane18_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane19_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane20_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane21_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane22_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane23_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane24_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane25_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane26_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane27_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane28_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane29_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane30_o;
			wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane31_o;
	

	

	DDR3_OutPacket_multiSM
	DDR3_OutPacket_multiSM(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i),
			
			.InfoRamAddr_i(InfoRamAddr_o_o),
			.lane_mask_i(lane_mask),
			.RAM2DDR3_ldstWarp_i(RAM2DDR3_ldstWarp),
			.RAM2DDR3_ldstReg_i(RAM2DDR3_ldstReg),
			.load_i(load & (sm_i == 0)),
			.dout_i(DDR3_dout),
			.rdy(DDR3_rdy),				//read ready
			.sm_i(sm_i),
			
			.loadWarp_o(loadWarp_o),
			.loadPacketValid_o(loadPacketValid_o),
			.loadMask_o(loadMask_o),					
			.loadPacketLane0_o(loadPacketLane0_o),
			.loadPacketLane1_o(loadPacketLane1_o),
			.loadPacketLane2_o(loadPacketLane2_o),
			.loadPacketLane3_o(loadPacketLane3_o),
			.loadPacketLane4_o(loadPacketLane4_o),
			.loadPacketLane5_o(loadPacketLane5_o),
			.loadPacketLane6_o(loadPacketLane6_o),
			.loadPacketLane7_o(loadPacketLane7_o),
			.loadPacketLane8_o(loadPacketLane8_o),
			.loadPacketLane9_o(loadPacketLane9_o),
			.loadPacketLane10_o(loadPacketLane10_o),
			.loadPacketLane11_o(loadPacketLane11_o),
			.loadPacketLane12_o(loadPacketLane12_o),
			.loadPacketLane13_o(loadPacketLane13_o),
			.loadPacketLane14_o(loadPacketLane14_o),
			.loadPacketLane15_o(loadPacketLane15_o),
			.loadPacketLane16_o(loadPacketLane16_o),
			.loadPacketLane17_o(loadPacketLane17_o),
			.loadPacketLane18_o(loadPacketLane18_o),
			.loadPacketLane19_o(loadPacketLane19_o),
			.loadPacketLane20_o(loadPacketLane20_o),
			.loadPacketLane21_o(loadPacketLane21_o),
			.loadPacketLane22_o(loadPacketLane22_o),
			.loadPacketLane23_o(loadPacketLane23_o),
			.loadPacketLane24_o(loadPacketLane24_o),
			.loadPacketLane25_o(loadPacketLane25_o),
			.loadPacketLane26_o(loadPacketLane26_o),
			.loadPacketLane27_o(loadPacketLane27_o),
			.loadPacketLane28_o(loadPacketLane28_o),
			.loadPacketLane29_o(loadPacketLane29_o),
			.loadPacketLane30_o(loadPacketLane30_o),
			.loadPacketLane31_o(loadPacketLane31_o),
			.loadPacketLaneFirstOne_o(loadPacketLaneFirstOne_o)
	);
	
endmodule 