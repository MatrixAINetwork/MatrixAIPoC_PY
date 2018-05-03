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

module FetchToDecode(	
					input reset,
					input clk,
					
					input [`NUM_WARP_LOG-1:0] instWarp_i,
					input instPacket0Valid_i,
					input [`SIZE_INSTRUCTION+`SIZE_PC-1:0] instPacket0_i,
					input instPacket1Valid_i,
					input [`SIZE_INSTRUCTION+`SIZE_PC-1:0] instPacket1_i,
					
					input flush_i,
					input [`NUM_WARP_LOG-1:0] flushWarp_i,
					input stall_i,
					
					output reg [`NUM_WARP_LOG-1:0] instWarp_o,
					output reg instPacket0Valid_o,
					output reg [`SIZE_INSTRUCTION+`SIZE_PC-1:0] instPacket0_o,
					output reg instPacket1Valid_o,
					output reg [`SIZE_INSTRUCTION+`SIZE_PC-1:0] instPacket1_o
					);
					
	wire flushSame;
	assign flushSame = (flushWarp_i == instWarp_i)? 1'b1:1'b0;
	
	always @(posedge clk) begin
		if(reset) begin
			instWarp_o       <= 0;
			instPacket0Valid_o <= 0;
			instPacket0_o  	<= 0;
			instPacket1Valid_o <= 0;
			instPacket1_o    <= 0;
		end
		else begin
			if(~stall_i) begin
				if(flush_i&&flushSame) begin
					instWarp_o       <= 0;
					instPacket0Valid_o <= 0;
					instPacket0_o  	<= 0;
					instPacket1Valid_o <= 0;
					instPacket1_o    <= 0;
				end
				else begin
					instWarp_o       <= instWarp_i;
					instPacket0Valid_o <= instPacket0Valid_i;
					instPacket0_o  	<= instPacket0_i;
					instPacket1Valid_o <= instPacket1Valid_i;
					instPacket1_o    <= instPacket1_i;
				end
			end
		end	
	end
	
endmodule
