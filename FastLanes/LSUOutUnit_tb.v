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
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:00:19 05/16/2013
// Design Name:   LSUOutUnit
// Module Name:   D:/ISE/LSU1.8/LSU1.8/LSUOutUnit_tb.v
// Project Name:  LSU1.5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: LSUOutUnit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module LSUOutUnit_tb;

	// Inputs
	reg clk;
	reg reset;
	reg stall_i;
	reg RAM_Out;
	reg [41:0] InfoRamInfo_o;
	reg [1023:0] InfoRamAddr_o;
	reg [1023:0] InfoRamData_o;

	// Outputs
	wire [1023:0] InfoRamAddr_o_o;
	wire [31:0] lane_mask_o;
	wire [27:0] RAM2DDR3_addr;
	wire [63:0] RAM2DDR3_mask;
	wire [511:0] RAM2DDR3_din;
	wire RAM2DDR3_we_o;
	wire [1:0] RAM2DDR3_ldstWarp_o;
	wire [4:0] RAM2DDR3_ldstReg_o;
	wire load_o;
	wire store_o;
	wire LSUOut_working;

	// Instantiate the Unit Under Test (UUT)
	LSUOutUnit uut (
		.clk(clk), 
		.reset(reset), 
		.stall_i(stall_i), 
		.RAM_Out(RAM_Out), 
		.InfoRamInfo_o(InfoRamInfo_o), 
		.InfoRamAddr_o(InfoRamAddr_o), 
		.InfoRamData_o(InfoRamData_o), 
		.DDR3_rdy(DDR3_rdy),				//read ready
		.DDR3_w_rdy(DDR3_w_rdy),
		.InfoRamAddr_o_o(InfoRamAddr_o_o), 
		.lane_mask_o(lane_mask_o), 
		.RAM2DDR3_addr_o(RAM2DDR3_addr), 
		.RAM2DDR3_mask_o(RAM2DDR3_mask), 
		.RAM2DDR3_din_o(RAM2DDR3_din), 
		.RAM2DDR3_we_o(RAM2DDR3_we), 
		.RAM2DDR3_ldstWarp_o(RAM2DDR3_ldstWarp_o), 
		.RAM2DDR3_ldstReg_o(RAM2DDR3_ldstReg_o), 
		.load_o(load_o), 
		.store_o(store_o), 
		.LSUOut_working(LSUOut_working)
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
			wire [`SIZE_CORE - 1 :0 ] lane_mask;
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
			
			
	DDR3_OutPacket	DDR3_OutPacket(
			.clk(clk),
			.reset(reset),
			.stall_i(stall_i),
			
			.InfoRamAddr_i(InfoRamAddr_o_o),
			.lane_mask_i(lane_mask_o),
			.RAM2DDR3_ldstWarp_i(RAM2DDR3_ldstWarp_o),
			.RAM2DDR3_ldstReg_i(RAM2DDR3_ldstReg_o),
			.load_i(load_o),
			.dout_i(DDR3_dout),
			.rdy(DDR3_rdy),				//read ready
			
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
			.loadPacketLane31_o(loadPacketLane31_o)
	);








	reg [31:0] addr;
	reg [31:0] mask;
	reg [31:0] data;
	reg [4:0] Reg;
	reg [1:0] warp;
	reg valid;
	initial begin
		// Initialize Inputs
		clk = 1;
		reset = 0;
		stall_i = 0;
		RAM_Out = 0;
		InfoRamInfo_o = 0;
		InfoRamAddr_o = 0;
		InfoRamData_o = 0;
		
		mask = 32'b10010000_00000011_10000001_01100000;
		addr = 32'b00000000_00100010_11001100_010_00000;
		data = 32'b00000000_00000000_00000000_00000000;
		warp = 2'b10;
		Reg = 5'b01001;
		valid = 0;
		// Wait 100 ns for global reset to finish
		#100;
	end
      
	initial fork
	forever #5 clk <= ~clk;
	#20 reset <= 1;
	#30 reset <= 0;
	
	
	#40 RAM_Out <= 1;
	#40 InfoRamInfo_o <= {mask,warp,Reg,3'b101};
	#40 InfoRamAddr_o <= {addr,0,0,addr+4,0,0,0,0,0,0,0,0,0,0,addr+8,addr+12,addr+16,
									0,0,0,0,0,0,addr + 20, 0,addr+24,addr+28,0,0,0,0,0};
	#40 InfoRamData_o <= {data,data+1,data+2,data+3,data+4,data+5,data+6,data+7,data+8,data+9,
								data+10,data+11,data+12,data+13,data+14,data+15,data+16,data+17,data+18,
								data+19,data+20,data+21,data+22,data+23,data+24,data+25,data+26,data+27,
								data+28,data+29,data+30,data+31};
	#50 RAM_Out <= 0; 
	
	#1040 RAM_Out <= 1;
	#1040 InfoRamInfo_o <= {mask,warp,Reg,3'b110};
	#1040 InfoRamAddr_o <= {addr,0,0,addr+4,0,0,0,0,0,0,0,0,0,0,addr+8,addr+12,addr+16,
									0,0,0,0,0,0,addr + 20, 0,addr+24,addr+28,0,0,0,0,0};
	#1040 InfoRamData_o <= 1024'b0;
	#1050 RAM_Out <= 0; 
	join
endmodule

