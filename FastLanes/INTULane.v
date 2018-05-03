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
`include "SimplePTX_ISA.v"

module INTULane(	
				input reset,
				input clk,
				
				input fuPacketValid_i,
				input [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
					+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
					:0]fuPacket_i,
				
				input fuPacketLaneValid_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane_i,
				
				output intuPacketLaneValid_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0] intuPacketLane_o
				);
		
	wire [`SIZE_DATA-1:0] instData1;
	wire [`SIZE_DATA-1:0] instData2;
	wire [`SIZE_DATA-1:0] instData3;
	wire [`SIZE_IMMEDIATE-1:0] instImmd;
	wire [`SIZE_OPCODE-1:0] instOpcode;
	wire [`INST_TYPES_LOG-1:0] instFU;
	wire [`SIZE_REGFILE-1:0] instDestReg;
	wire [`SIZE_DATA-1:0] 		result;
	
	assign instData1 = fuPacketLane_i[`SIZE_DATA-1:0];	
	assign instData2 = fuPacketLane_i[2*`SIZE_DATA-1:`SIZE_DATA];		
	assign instData3 = fuPacketLane_i[3*`SIZE_DATA-1:2*`SIZE_DATA];	
	assign instImmd = fuPacket_i[`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
									+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
									:4*(`SIZE_REGFILE+1)
									+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC];	
	assign instOpcode = fuPacket_i[`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1:`SIZE_RP+1+3*`SIZE_PC];
	assign instFU = fuPacket_i[`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
									+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
								:`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
									+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC];
	assign instDestReg = fuPacket_i[4*(`SIZE_REGFILE+1)+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
										:1+3*(`SIZE_REGFILE+1)+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC];
	assign instDestValid = fuPacket_i[3*(`SIZE_REGFILE+1)+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC];
	
	
	
	
	
	reg [`SIZE_DATA-1:0] a;
	reg [`SIZE_DATA-1:0] b;
	reg [`SIZE_DATA-1:0] c;
	reg [`SIZE_DATA-1:0] sign_ex_immd;
	wire [`SIZE_OPCODE_USED-1:0] opcode_used;// need to be modify after post-DAC.
	assign opcode_used = {1'b0, instOpcode[`SIZE_OPCODE_USED-1-1:0]};
	
	always @(*) begin
		if(instImmd[`SIZE_IMMEDIATE-1] == 1'b1)
			sign_ex_immd = {16'b1111111111111111,instImmd};
		else
			sign_ex_immd = {16'b0000000000000000,instImmd};

			
		case(instFU) 
			`INSTRUCTION_INT_R: begin
				a = instData1;
				b = instData2;
				c = instData3;
			end
			
			`INSTRUCTION_INT_I: begin
				a = instData1;
				b = sign_ex_immd;
				c = 0;
			end
			
			default: begin
			end
		endcase
	end
	
	
	INTU intu(
		.a_i(a),
		.b_i(b),
		.c_i(c),
		.opcode_i(opcode_used),		
		.result_o(result)
		);
	
	
		
	
	assign intuPacketLaneValid_o = fuPacketLaneValid_i;
	assign intuPacketLane_o = {
								result,
								instDestReg,
								instDestValid,
								instFU
								};
					
endmodule