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

module IssueToOpcol(	
          input reset,
          input clk,
          
		  input [`SIZE_SM_LOG-1:0] issuedSM_i,
          input [`NUM_WARP_LOG-1:0] issuedWarp_i,
          input issuedPacketValid_i,
          input [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
              +`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
              :0] issuedPacket_i,							
          input [`SIZE_CORE-1:0] issuedMask_i,
          
          input flush_i,
          input [`NUM_WARP_LOG-1:0] flushWarp_i,
          input stall_i,
          //input [`NUM_WARP_LOG-1:0] stallWarp_i,
          
		  output reg [`SIZE_SM_LOG-1:0] issuedSM_o,
          output reg [`NUM_WARP_LOG-1:0] issuedWarp_o,
          output reg issuedPacketValid_o,
          output reg [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
              +`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
              :0] issuedPacket_o,							
          output reg [`SIZE_CORE-1:0] issuedMask_o

          );
  
  wire flushSame;
  assign flushSame = (flushWarp_i == issuedWarp_i)? 1'b1:1'b0;
  
  always @(posedge clk) begin
    if(reset) begin
		issuedSM_o			<= 0;
		issuedWarp_o       	<= 0;
		issuedPacketValid_o <= 0;
		issuedPacket_o  	<= 0;
		issuedMask_o 		<= 0;
    end
    else begin
		if(~stall_i) begin
			if(flush_i&&flushSame) begin
				issuedSM_o			<= 0;
				issuedWarp_o       	<= 0;
				issuedPacketValid_o <= 0;
				issuedPacket_o  	<= 0;
				issuedMask_o 		<= 0;
			end
			else begin
				issuedSM_o			<= issuedSM_i;
				issuedWarp_o		<= issuedWarp_i;
				issuedPacketValid_o <= issuedPacketValid_i;
				issuedPacket_o  	<= issuedPacket_i;
				issuedMask_o		<= issuedMask_i;
			end
		end
    end	
  end
  
endmodule