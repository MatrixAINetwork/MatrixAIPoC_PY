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
module Issue(	
        input reset,
        input clk,
        
				input [`NUM_WARP_LOG-1:0] selectedWarp_i,
				input selectedPacketValid_i,
				input [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
							+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
							:0]selectedPacket_i,
				input [`SIZE_CORE-1:0] ActiveMask_i,
				input [`SIZE_PC-1:0] TopRPC_i,
				
				output [`NUM_WARP_LOG-1:0] issuedWarp_o,
				output issuedPacketValid_o,
				output [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
							+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
							:0] issuedPacket_o,							
				output reg [`SIZE_CORE-1:0] issuedMask_o,
				
				output reg reconv_o,
				
				output issuedSync_o,
				output issuedExit_o
				
				);
				
	assign issuedSync_o = issuedPacketValid_o && issuedPacket_o[4+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
							+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1];
	assign issuedExit_o = issuedPacketValid_o && issuedPacket_o[5+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
							+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1];
	
	wire [`SIZE_PC-1:0] curPC;
	
	assign issuedWarp_o = selectedWarp_i;
	assign issuedPacketValid_o = selectedPacketValid_i;
	assign issuedPacket_o = selectedPacket_i;
	//assign issuedMask_o = ActiveMask_i;
	
	assign curPC = selectedPacket_i[3*`SIZE_PC-1:2*`SIZE_PC];
	
	always @(*) begin
		if(curPC == TopRPC_i) begin
			reconv_o = selectedPacketValid_i;
			issuedMask_o = 0;
		end
		else begin
			reconv_o = 1'b0;
			issuedMask_o = ActiveMask_i;
		end
	end
	
endmodule
