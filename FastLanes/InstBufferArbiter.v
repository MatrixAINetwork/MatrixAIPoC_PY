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

module InstBufferArbiter(
					input reset,
					input clk,
					
					input [`NUM_WARP_LOG-1:0] preWarp_i,
					input [`NUM_WARP-1:0] ReadyVector0_i,
					input [`NUM_WARP-1:0] ReadyVector1_i,
					
					output [`NUM_WARP_LOG-1:0] grantWarp_o,
					output [`NUM_ENTRY_LOG-1:0] grantEntry_o
					);
	
	wire [`NUM_WARP_LOG-1:0] preWarp;
	wire [`NUM_WARP-1:0] warpReadyVector;
	reg [`NUM_WARP_LOG-1:0] grantWarp;
	reg [`NUM_WARP_LOG-1:0] grantEntry;
	
	assign preWarp = preWarp_i;
	assign warpReadyVector = ReadyVector0_i | ReadyVector1_i;
	assign grantWarp_o = grantWarp;
	assign grantEntry_o = grantEntry;


	
	wire [`NUM_WARP_LOG-1:0] num0;
	wire [`NUM_WARP_LOG-1:0] num1;
	wire [`NUM_WARP_LOG-1:0] num2;
	wire [`NUM_WARP_LOG-1:0] num3;
	assign num0 = preWarp;
	assign num1 = preWarp+1;
	assign num2 = preWarp+2;
	assign num3 = preWarp+3;
	
	
	always @(*) begin	
		if(warpReadyVector[num1] == 1'b1) grantWarp = preWarp+1;
		else if(warpReadyVector[num2] == 1'b1) grantWarp = preWarp+2;
		else if(warpReadyVector[num3] == 1'b1) grantWarp = preWarp+3;
		else grantWarp = preWarp;
		/*
		else if(warpReadyVector[preWarp+4] == 1'b1) grantWarp = preWarp+4;	
		else if(warpReadyVector[preWarp+5] == 1'b1) grantWarp = preWarp+5;	
		else if(warpReadyVector[preWarp+6] == 1'b1) grantWarp = preWarp+6;	
		else if(warpReadyVector[preWarp+7] == 1'b1) grantWarp = preWarp+7;	
		else if(warpReadyVector[preWarp+8] == 1'b1) grantWarp = preWarp+8;	
		else if(warpReadyVector[preWarp+9] == 1'b1) grantWarp = preWarp+9;	
		else if(warpReadyVector[preWarp+10] == 1'b1) grantWarp = preWarp+10;
		else if(warpReadyVector[preWarp+11] == 1'b1) grantWarp = preWarp+1;		
		else if(warpReadyVector[preWarp+12] == 1'b1) grantWarp = preWarp+2;
		else if(warpReadyVector[preWarp+13] == 1'b1) grantWarp = preWarp+3;
		else if(warpReadyVector[preWarp+14] == 1'b1) grantWarp = preWarp+4;	
		else if(warpReadyVector[preWarp+15] == 1'b1) grantWarp = preWarp+5;	
		else if(warpReadyVector[preWarp+16] == 1'b1) grantWarp = preWarp+6;	
		else if(warpReadyVector[preWarp+17] == 1'b1) grantWarp = preWarp+7;	
		else if(warpReadyVector[preWarp+18] == 1'b1) grantWarp = preWarp+8;	
		else if(warpReadyVector[preWarp+19] == 1'b1) grantWarp = preWarp+9;	
		else if(warpReadyVector[preWarp+20] == 1'b1) grantWarp = preWarp+10;	
		*/
		
		
	/*
		case (preWarp)
			2'b00: begin
				if(warpReadyVector[1] == 1'b1) grantWarp = 2'b01;
				else if(warpReadyVector[2] == 1'b1) grantWarp = 2'b10;
				else if(warpReadyVector[3] == 1'b1) grantWarp = 2'b11;		//If none of the warps is valid, the upper module will decide.
				else grantWarp = 2'b00;
			end
			
			2'b01: begin
				if(warpReadyVector[2] == 1'b1) grantWarp = 2'b10;
				else if(warpReadyVector[3] == 1'b1) grantWarp = 2'b11;
				else if(warpReadyVector[0] == 1'b1) grantWarp = 2'b00;		
				else grantWarp = 2'b01;
			end
			
			2'b10: begin
				if(warpReadyVector[3] == 1'b1) grantWarp = 2'b11;
				else if(warpReadyVector[0] == 1'b1) grantWarp = 2'b00;
				else if(warpReadyVector[1] == 1'b1) grantWarp = 2'b01;		
				else grantWarp = 2'b10;
			end
			
			2'b11: begin
				if(warpReadyVector[0] == 1'b1) grantWarp = 2'b00;
				else if(warpReadyVector[1] == 1'b1) grantWarp = 2'b01;
				else if(warpReadyVector[2] == 1'b1) grantWarp = 2'b10;			
				else grantWarp = 2'b11;
			end
			
			default: begin
			end
		endcase
		*/
		if(ReadyVector0_i[grantWarp] == 1'b1) grantEntry = 1'b0;		//Better code?
		else grantEntry = 1'b1;
	end
	
	
endmodule
