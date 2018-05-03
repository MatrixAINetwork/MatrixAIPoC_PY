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
// Create Date:   10:43:07 05/16/2013
// Design Name:   DDR3_OutPacket
// Module Name:   D:/ISE/LSU1.8/LSU1.8/DDR3_OutPacket_tb.v
// Project Name:  LSU1.5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: DDR3_OutPacket
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module DDR3_OutPacket_tb;

	// Inputs
	reg clk;
	reg reset;
	reg stall_i;
	reg [1023:0] InfoRamAddr_i;
	reg [31:0] lane_mask_i;
	reg [1:0] RAM2DDR3_ldstWarp_i;
	reg [4:0] RAM2DDR3_ldstReg_i;
	reg load_i;
	reg [511:0] dout_i;
	reg rdy;

	// Outputs
	wire [4:0] loadWarp_o;
	wire loadPacketValid_o;
	wire [31:0] loadMask_o;
	wire [36:0] loadPacketLane0_o;
	wire [36:0] loadPacketLane1_o;
	wire [36:0] loadPacketLane2_o;
	wire [36:0] loadPacketLane3_o;
	wire [36:0] loadPacketLane4_o;
	wire [36:0] loadPacketLane5_o;
	wire [36:0] loadPacketLane6_o;
	wire [36:0] loadPacketLane7_o;
	wire [36:0] loadPacketLane8_o;
	wire [36:0] loadPacketLane9_o;
	wire [36:0] loadPacketLane10_o;
	wire [36:0] loadPacketLane11_o;
	wire [36:0] loadPacketLane12_o;
	wire [36:0] loadPacketLane13_o;
	wire [36:0] loadPacketLane14_o;
	wire [36:0] loadPacketLane15_o;
	wire [36:0] loadPacketLane16_o;
	wire [36:0] loadPacketLane17_o;
	wire [36:0] loadPacketLane18_o;
	wire [36:0] loadPacketLane19_o;
	wire [36:0] loadPacketLane20_o;
	wire [36:0] loadPacketLane21_o;
	wire [36:0] loadPacketLane22_o;
	wire [36:0] loadPacketLane23_o;
	wire [36:0] loadPacketLane24_o;
	wire [36:0] loadPacketLane25_o;
	wire [36:0] loadPacketLane26_o;
	wire [36:0] loadPacketLane27_o;
	wire [36:0] loadPacketLane28_o;
	wire [36:0] loadPacketLane29_o;
	wire [36:0] loadPacketLane30_o;
	wire [36:0] loadPacketLane31_o;

	// Instantiate the Unit Under Test (UUT)
	DDR3_OutPacket uut (
		.clk(clk), 
		.reset(reset), 
		.stall_i(stall_i), 
		.InfoRamAddr_i(InfoRamAddr_i), 
		.lane_mask_i(lane_mask_i), 
		.RAM2DDR3_ldstWarp_i(RAM2DDR3_ldstWarp_i), 
		.RAM2DDR3_ldstReg_i(RAM2DDR3_ldstReg_i), 
		.load_i(load_i), 
		.dout_i(dout_i), 
		.rdy(rdy), 
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
		InfoRamAddr_i = 0;
		lane_mask_i = 0;
		RAM2DDR3_ldstWarp_i = 0;
		RAM2DDR3_ldstReg_i = 0;
		load_i = 0;
		dout_i = 0;
		rdy = 0;


		mask = 32'b10010000_00000011_10000001_01100000;
		addr = 32'b00000000_00100010_11001100_010_00000;
		data = 32'b00000000_00000000_00000000_00000000;
		warp = 2'b10;
		Reg = 5'b01001;
		valid = 0;
		// Wait 100 ns for global reset to finish
		//#100;
        
		// Add stimulus here
	end
	
	
	initial fork
	forever #5 clk <= ~clk;
	#20 reset <= 1;
	#30 reset <= 0;
	
	#40 load_i <= 1;
	#40 InfoRamAddr_i <= {addr,0,0,addr+4,0,0,0,0,0,0,0,0,0,0,addr+8,addr+12,addr+16,
									0,0,0,0,0,0,addr + 20, 0,addr+24,addr+28,0,0,0,0,0};
									
	#40 lane_mask_i <= 32'b10010000_00000011_10000001_01100000;
	#40 RAM2DDR3_ldstWarp_i <= 2'b10;
	#40 RAM2DDR3_ldstReg_i <= 5'b01001;					
									
	#50 load_i <= 0;
	#50 InfoRamAddr_i <= 0;
	#50 lane_mask_i <= 0; 
	#50 RAM2DDR3_ldstWarp_i <= 0;
	#50 RAM2DDR3_ldstReg_i <= 0;

	
	#200 dout_i <= {data,data+1,data+2,data+3,data+4,data+5,data+6,data+7,data+8,data+9,
								data+10,data+11,data+12,data+13,data+14,data+15};

	
	#240 rdy <= 1;
	#250 rdy <= 0;
	
	join

endmodule

