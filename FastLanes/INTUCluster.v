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

module INTUCluster(
				input reset,
				input clk,
				
				input [`NUM_WARP_LOG-1:0] fuWarp_i,
				input fuPacketValid_i,
				input [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
					+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
					:0]fuPacket_i,	
				
				input [`SIZE_CORE-1:0] fuMask_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane0_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane1_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane2_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane3_i,		
				input [3*`SIZE_DATA-1:0] fuPacketLane4_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane5_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane6_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane7_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane8_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane9_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane10_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane11_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane12_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane13_i,		
				input [3*`SIZE_DATA-1:0] fuPacketLane14_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane15_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane16_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane17_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane18_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane19_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane20_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane21_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane22_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane23_i,		
				input [3*`SIZE_DATA-1:0] fuPacketLane24_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane25_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane26_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane27_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane28_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane29_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane30_i,
				input [3*`SIZE_DATA-1:0] fuPacketLane31_i,
				
				output [`NUM_WARP_LOG-1:0] intuWarp_o,
				output intuPacketValid_o,
				output [`SIZE_CORE-1:0] intuMask_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane0_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane1_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane2_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane3_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane4_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane5_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane6_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane7_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane8_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane9_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane10_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane11_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane12_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane13_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane14_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane15_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane16_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane17_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane18_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane19_o,	
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane20_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane21_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane22_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane23_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane24_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane25_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane26_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane27_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane28_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane29_o,	
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane30_o,
				output [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane31_o
						
				);
				
	reg  [`SIZE_CORE-1:0] intuMask;
	
	assign intuPacketValid_o = fuPacketValid_i;
	//assign intuMask_o = intuMask;			
	assign intuWarp_o = fuWarp_i;
	
	always @(*) begin
		if(fuPacketValid_i == 1'b1) begin
			intuMask = fuMask_i;
		end
		else begin
			intuMask = 0;
		end
	end
						
	INTULane
		intuLane0(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[0]),
				.fuPacketLane_i(fuPacketLane0_i),
				
				.intuPacketLaneValid_o(intuMask_o[0]),
				.intuPacketLane_o(intuPacketLane0_o)
				);	
	INTULane
		intuLane1(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[1]),
				.fuPacketLane_i(fuPacketLane1_i),
				
				.intuPacketLaneValid_o(intuMask_o[1]),
				.intuPacketLane_o(intuPacketLane1_o)
				);
	INTULane
		intuLane2(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[2]),
				.fuPacketLane_i(fuPacketLane2_i),
				
				.intuPacketLaneValid_o(intuMask_o[2]),
				.intuPacketLane_o(intuPacketLane2_o)
				);			
	INTULane
		intuLane3(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[3]),
				.fuPacketLane_i(fuPacketLane3_i),
				
				.intuPacketLaneValid_o(intuMask_o[3]),
				.intuPacketLane_o(intuPacketLane3_o)
				);			
	INTULane
		intuLane4(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[4]),
				.fuPacketLane_i(fuPacketLane4_i),
				
				.intuPacketLaneValid_o(intuMask_o[4]),
				.intuPacketLane_o(intuPacketLane4_o)
				);	
	INTULane
		intuLane5(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[5]),
				.fuPacketLane_i(fuPacketLane5_i),
				
				.intuPacketLaneValid_o(intuMask_o[5]),
				.intuPacketLane_o(intuPacketLane5_o)
				);
	INTULane
		intuLane6(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[6]),
				.fuPacketLane_i(fuPacketLane6_i),
				
				.intuPacketLaneValid_o(intuMask_o[6]),
				.intuPacketLane_o(intuPacketLane6_o)
				);			
	INTULane
		intuLane7(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[7]),
				.fuPacketLane_i(fuPacketLane7_i),
				
				.intuPacketLaneValid_o(intuMask_o[7]),
				.intuPacketLane_o(intuPacketLane7_o)
				);
				
	INTULane
		intuLane8(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[8]),
				.fuPacketLane_i(fuPacketLane8_i),
				
				.intuPacketLaneValid_o(intuMask_o[8]),
				.intuPacketLane_o(intuPacketLane8_o)
				);			
	INTULane
		intuLane9(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[9]),
				.fuPacketLane_i(fuPacketLane9_i),
				
				.intuPacketLaneValid_o(intuMask_o[9]),
				.intuPacketLane_o(intuPacketLane9_o)
				);
				
	INTULane
		intuLane10(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[10]),
				.fuPacketLane_i(fuPacketLane10_i),
				
				.intuPacketLaneValid_o(intuMask_o[10]),
				.intuPacketLane_o(intuPacketLane10_o)
				);
				
	INTULane
		intuLane11(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[11]),
				.fuPacketLane_i(fuPacketLane11_i),
				
				.intuPacketLaneValid_o(intuMask_o[11]),
				.intuPacketLane_o(intuPacketLane11_o)
				);
				
	INTULane
		intuLane12(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[12]),
				.fuPacketLane_i(fuPacketLane12_i),
				
				.intuPacketLaneValid_o(intuMask_o[12]),
				.intuPacketLane_o(intuPacketLane12_o)
				);
				
	INTULane
		intuLane13(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[13]),
				.fuPacketLane_i(fuPacketLane13_i),
				
				.intuPacketLaneValid_o(intuMask_o[13]),
				.intuPacketLane_o(intuPacketLane13_o)
				);
				
	INTULane
		intuLane14(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[14]),
				.fuPacketLane_i(fuPacketLane14_i),
				
				.intuPacketLaneValid_o(intuMask_o[14]),
				.intuPacketLane_o(intuPacketLane14_o)
				);
				
	INTULane
		intuLane15(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[15]),
				.fuPacketLane_i(fuPacketLane15_i),
				
				.intuPacketLaneValid_o(intuMask_o[15]),
				.intuPacketLane_o(intuPacketLane15_o)
				);
				
	INTULane
		intuLane16(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[16]),
				.fuPacketLane_i(fuPacketLane16_i),
				
				.intuPacketLaneValid_o(intuMask_o[16]),
				.intuPacketLane_o(intuPacketLane16_o)
				);
				
	INTULane
		intuLane17(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[17]),
				.fuPacketLane_i(fuPacketLane17_i),
				
				.intuPacketLaneValid_o(intuMask_o[17]),
				.intuPacketLane_o(intuPacketLane17_o)
				);
				
	INTULane
		intuLane18(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[18]),
				.fuPacketLane_i(fuPacketLane18_i),
				
				.intuPacketLaneValid_o(intuMask_o[18]),
				.intuPacketLane_o(intuPacketLane18_o)
				);
				
	INTULane
		intuLane19(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[19]),
				.fuPacketLane_i(fuPacketLane19_i),
				
				.intuPacketLaneValid_o(intuMask_o[19]),
				.intuPacketLane_o(intuPacketLane19_o)
				);
				
	INTULane
		intuLane20(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[20]),
				.fuPacketLane_i(fuPacketLane20_i),
				
				.intuPacketLaneValid_o(intuMask_o[20]),
				.intuPacketLane_o(intuPacketLane20_o)
				);
				
	INTULane
		intuLane21(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[21]),
				.fuPacketLane_i(fuPacketLane21_i),
				
				.intuPacketLaneValid_o(intuMask_o[21]),
				.intuPacketLane_o(intuPacketLane21_o)
				);
				
	INTULane
		intuLane22(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[22]),
				.fuPacketLane_i(fuPacketLane22_i),
				
				.intuPacketLaneValid_o(intuMask_o[22]),
				.intuPacketLane_o(intuPacketLane22_o)
				);
				
	INTULane
		intuLane23(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[23]),
				.fuPacketLane_i(fuPacketLane23_i),
				
				.intuPacketLaneValid_o(intuMask_o[23]),
				.intuPacketLane_o(intuPacketLane23_o)
				);
				
	INTULane
		intuLane24(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[24]),
				.fuPacketLane_i(fuPacketLane24_i),
				
				.intuPacketLaneValid_o(intuMask_o[24]),
				.intuPacketLane_o(intuPacketLane24_o)
				);
				
	INTULane
		intuLane25(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[25]),
				.fuPacketLane_i(fuPacketLane25_i),
				
				.intuPacketLaneValid_o(intuMask_o[25]),
				.intuPacketLane_o(intuPacketLane25_o)
				);
				
	INTULane
		intuLane26(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[26]),
				.fuPacketLane_i(fuPacketLane26_i),
				
				.intuPacketLaneValid_o(intuMask_o[26]),
				.intuPacketLane_o(intuPacketLane26_o)
				);
				
	INTULane
		intuLane27(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[27]),
				.fuPacketLane_i(fuPacketLane27_i),
				
				.intuPacketLaneValid_o(intuMask_o[27]),
				.intuPacketLane_o(intuPacketLane27_o)
				);
				
	INTULane
		intuLane28(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[28]),
				.fuPacketLane_i(fuPacketLane28_i),
				
				.intuPacketLaneValid_o(intuMask_o[28]),
				.intuPacketLane_o(intuPacketLane28_o)
				);
				
	INTULane
		intuLane29(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[29]),
				.fuPacketLane_i(fuPacketLane29_i),
				
				.intuPacketLaneValid_o(intuMask_o[29]),
				.intuPacketLane_o(intuPacketLane29_o)
				);
				
	INTULane
		intuLane30(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[30]),
				.fuPacketLane_i(fuPacketLane30_i),
				
				.intuPacketLaneValid_o(intuMask_o[30]),
				.intuPacketLane_o(intuPacketLane30_o)
				);
				
	INTULane
		intuLane31(	
				.reset(reset),
				.clk(clk),
				
				.fuPacketValid_i(fuPacketValid_i),
				.fuPacket_i(fuPacket_i),
					
				.fuPacketLaneValid_i(intuMask[31]),
				.fuPacketLane_i(fuPacketLane31_i),
				
				.intuPacketLaneValid_o(intuMask_o[31]),
				.intuPacketLane_o(intuPacketLane31_o)
				);
endmodule