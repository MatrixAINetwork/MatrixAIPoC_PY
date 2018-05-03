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
// Create Date:   22:01:53 05/18/2013
// Design Name:   MemAccessFIFO
// Module Name:   D:/ISE/LSU1.9/LSU1.8/FIFO_tb.v
// Project Name:  LSU1.5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MemAccessFIFO
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FIFO_tb;

	// Inputs
	reg clk;
	reg reset;
	reg stall_i;
	reg i;
	reg [4:0] RAM_Addr_i;
	reg [9:0] Delay;
	reg [15:0] count;
	reg o;
	reg FIFOIn;

	// Outputs
	wire [4:0] RAM_Addr_o;
	wire [15:0] HeadOutTime;
	wire [15:0] HeadInTime;
	wire full;

	// Instantiate the Unit Under Test (UUT)
	MemAccessFIFO uut (
		.clk(clk), 
		.reset(reset), 
		.stall_i(stall_i), 
		.i(i), 
		.RAM_Addr_i(RAM_Addr_i), 
		.Delay(Delay), 
		.count(count), 
		.o(o), 
		.FIFOIn(FIFOIn), 
		.RAM_Addr_o(RAM_Addr_o), 
		.HeadOutTime(HeadOutTime), 
		.HeadInTime(HeadInTime), 
		.full(full)
	);

	initial begin
		// Initialize Inputs
		clk = 1;
		reset = 0;
		stall_i = 0;
		i = 0;
		RAM_Addr_i = 0;
		Delay = 0;
		count = 0;
		o = 0;
		FIFOIn = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
	initial fork
	forever #5 clk <= ~clk;
	forever #10 count <= count + 1;
	#20 reset <= 1;
	#30 reset <= 0;
	#40 i <= 1;
	#40 Delay <= 10;
	#40 RAM_Addr_i <= 5'b00001;
	#100 o <= 1;
	#40 FIFOIn <= 1;
     
	 
	join
endmodule

