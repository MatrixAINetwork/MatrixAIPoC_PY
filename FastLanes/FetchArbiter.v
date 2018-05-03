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

module FetchArbiter(
				input [`NUM_WARP_LOG-1:0] preWarp_i,
				input [`NUM_WARP-1:0] warpEligeble_i,
				output [`NUM_WARP_LOG-1:0] grantWarp_o
					);
	
	wire [`NUM_WARP_LOG-1:0] preWarp;
	wire [`NUM_WARP-1:0] warpEligeble;
	reg [`NUM_WARP_LOG-1:0] grantWarp;
	
	assign preWarp = preWarp_i;
	assign warpEligeble = warpEligeble_i;
	assign grantWarp_o = grantWarp;
	
	
	wire [`NUM_WARP_LOG-1:0] num0;
	wire [`NUM_WARP_LOG-1:0] num1;
	wire [`NUM_WARP_LOG-1:0] num2;
	wire [`NUM_WARP_LOG-1:0] num3;
	assign num0 = preWarp;
	assign num1 = preWarp+1;
	assign num2 = preWarp+2;
	assign num3 = preWarp+3;
	
	
	always @(*) begin
		if(warpEligeble[num1] == 1'b1) grantWarp = preWarp+1;
		else if(warpEligeble[num2] == 1'b1) grantWarp = preWarp+2;
		else if(warpEligeble[num3] == 1'b1) grantWarp = preWarp+3;
		else grantWarp = preWarp;
	/*
		case (preWarp)
			2'b00: begin
				if(warpEligeble[1] == 1'b1) begin
					grantWarp = 2'b01;
				end
				else if(warpEligeble[2] == 1'b1) begin
					grantWarp = 2'b10; 
				end
				else if(warpEligeble[3] == 1'b1) begin
					grantWarp = 2'b11;		//If none of the warps is valid, the upper module will decide.  
				end
				else begin
					grantWarp = 2'b00;  
				end
			end
			
			2'b01: begin
				if(warpEligeble[2] == 1'b1) begin
					grantWarp = 2'b10;  
				end
				else if(warpEligeble[3] == 1'b1) begin
					grantWarp = 2'b11;  
				end
				else if(warpEligeble[0] == 1'b1) begin
					grantWarp = 2'b00;	 
				end	
				else begin
					grantWarp = 2'b01;  
				end
			end
			
			2'b10: begin
				if(warpEligeble[3] == 1'b1) begin
					grantWarp = 2'b11; 					 
				end
				else if(warpEligeble[0] == 1'b1) begin
					grantWarp = 2'b00;  
				end
				else if(warpEligeble[1] == 1'b1) begin
					grantWarp = 2'b01;  
				end		
				else begin
					grantWarp = 2'b10;  
				end
			end
			
			2'b11: begin
				if(warpEligeble[0] == 1'b1) begin
					grantWarp = 2'b00;  
				end
				else if(warpEligeble[1] == 1'b1) begin
					grantWarp = 2'b01;  
				end
				else if(warpEligeble[2] == 1'b1) begin
					grantWarp = 2'b10;	 
				end		
				else begin
					grantWarp = 2'b11;  
				end
			end
			
			default: begin
			end
		endcase
		*/
	end
	
endmodule