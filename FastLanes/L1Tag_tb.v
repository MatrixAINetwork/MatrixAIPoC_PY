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

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:43:25 05/18/2013
// Design Name:   L1TagUnit
// Module Name:   D:/ISE/LSU1.9/LSU1.8/L1Tag_tb.v
// Project Name:  LSU1.5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: L1TagUnit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module L1Tag_tb;

	// Inputs
	reg reset;
	reg clk;
	reg stall;
	reg [31:0] L1TagWriteAddr;
	reg L1TagWrite;
	reg [4:0] SegNum;
	reg [31:0] Coalesce2L1_o;

	// Outputs
	wire [9:0] Delay;
	wire L1_HIT;

	// Instantiate the Unit Under Test (UUT)
	L1TagUnit uut (
		.reset(reset), 
		.clk(clk), 
		.stall(stall), 
		.L1TagWriteAddr(L1TagWriteAddr), 
		.L1TagWrite(L1TagWrite), 
		.SegNum(SegNum), 
		.Coalesce2L1_o(Coalesce2L1_o), 
		.Delay(Delay), 
		.L1_HIT(L1_HIT)
	);

	initial begin
		// Initialize Inputs
		reset = 0;
		clk = 1;
		stall = 0;
		L1TagWriteAddr = 0;
		L1TagWrite = 0;
		SegNum = 0;
		Coalesce2L1_o = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
	initial fork
		forever #5 clk <= ~clk;
		#20 reset <= 1;
		#30 reset <= 0;
		#101 L1TagWriteAddr <= 32'b10101010_10101010_10101010_10101010;
		#101 L1TagWrite <= 1;
		#111 L1TagWriteAddr <= 32'b10101010_10101010_10101010_11101010;
		#121 L1TagWriteAddr <= 32'b10101010_10101010_10101011_11101010;
		#131 L1TagWriteAddr <= 32'b10101010_10101010_10101111_11101010;
		#91  Coalesce2L1_o <= 32'b10101010_10101010_10101010_10101010;
		#101  Coalesce2L1_o <= 32'b10101010_10101010_10101010_10101010;
		#111  Coalesce2L1_o <= 32'b10101010_10101010_10101010_10101010;
		#151  Coalesce2L1_o <= 32'b10101010_10101010_10101111_11101010;
		#201  Coalesce2L1_o <= 0;
	join
endmodule

