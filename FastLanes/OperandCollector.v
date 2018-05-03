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

module OperandCollector(
						input reset,
						input clk,
						input clkX4,
						input [1:0]clkPhase,
						
						input stall_i,
			
						input [`SIZE_SM_LOG-1:0] issuedSM_i,
						input [`NUM_WARP_LOG-1:0] issuedWarp_i,
						input issuedPacketValid_i,
						input [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
								+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
								:0] issuedPacket_i,
						input [`SIZE_CORE-1:0] issuedMask_i,
						
						
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane0_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane1_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane2_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane3_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane4_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane5_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane6_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane7_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane8_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane9_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane10_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane11_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane12_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane13_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane14_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane15_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane16_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane17_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane18_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane19_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane20_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane21_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane22_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane23_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane24_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane25_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane26_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane27_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane28_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane29_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane30_i,
						input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane31_i,
						
						
		
		
						input [`NUM_WARP_LOG-1:0] intuWarp_i,
						input [`SIZE_CORE-1:0] intuMask_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane0_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane1_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane2_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane3_i,		
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane4_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane5_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane6_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane7_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane8_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane9_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane10_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane11_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane12_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane13_i,		
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane14_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane15_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane16_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane17_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane18_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane19_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane20_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane21_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane22_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane23_i,		
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane24_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane25_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane26_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane27_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane28_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane29_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane30_i,
						input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:0] intuPacketLane31_i,
						
								
						input [`NUM_WARP_LOG-1:0] loadWarp_i,
						input [`SIZE_CORE-1:0] loadMask_i,	
						
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane0_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane1_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane2_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane3_i,		
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane4_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane5_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane6_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane7_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane8_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane9_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane10_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane11_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane12_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane13_i,		
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane14_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane15_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane16_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane17_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane18_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane19_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane20_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane21_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane22_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane23_i,		
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane24_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane25_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane26_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane27_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane28_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane29_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane30_i,
						input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane31_i,
								
						output [`SIZE_SM_LOG-1:0] fuSM_o,
						output [`NUM_WARP_LOG-1:0] fuWarp_o,
						output fuPacketValid_o,
						output [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
							+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
							:0]fuPacket_o,	
						
						output [`SIZE_CORE-1:0] fuMask_o,
						
						output [3*`SIZE_DATA-1:0] fuPacketLane0_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane1_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane2_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane3_o,		
						output [3*`SIZE_DATA-1:0] fuPacketLane4_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane5_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane6_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane7_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane8_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane9_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane10_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane11_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane12_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane13_o,		
						output [3*`SIZE_DATA-1:0] fuPacketLane14_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane15_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane16_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane17_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane18_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane19_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane20_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane21_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane22_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane23_o,		
						output [3*`SIZE_DATA-1:0] fuPacketLane24_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane25_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane26_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane27_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane28_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane29_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane30_o,
						output [3*`SIZE_DATA-1:0] fuPacketLane31_o,
						
						output branch_o,
						output reg [`SIZE_CORE-1:0] predMask_o,
						output [`SIZE_PC-1:0] branchTarget_o,
						output [`SIZE_PC-1:0] branchReconv_o,
						output [`SIZE_PC-1:0] branchPC_o,
						
						
						input rotate_i,
						input [`SIZE_CORE-1:0] rotateMask_i,
						input rotateWE_i,
						input [`REGFILE_BR_INDEX-1:0] rotateRegAddr_i,
						input [`SIZE_DATA-1:0] rotateDin0_i,
						input [`SIZE_DATA-1:0] rotateDin1_i,
						input [`SIZE_DATA-1:0] rotateDin2_i,
						input [`SIZE_DATA-1:0] rotateDin3_i,
						input [`SIZE_DATA-1:0] rotateDin4_i,
						input [`SIZE_DATA-1:0] rotateDin5_i,
						input [`SIZE_DATA-1:0] rotateDin6_i,
						input [`SIZE_DATA-1:0] rotateDin7_i,
						input [`SIZE_DATA-1:0] rotateDin8_i,
						input [`SIZE_DATA-1:0] rotateDin9_i,
						input [`SIZE_DATA-1:0] rotateDin10_i,
						input [`SIZE_DATA-1:0] rotateDin11_i,
						input [`SIZE_DATA-1:0] rotateDin12_i,
						input [`SIZE_DATA-1:0] rotateDin13_i,
						input [`SIZE_DATA-1:0] rotateDin14_i,
						input [`SIZE_DATA-1:0] rotateDin15_i,
						input [`SIZE_DATA-1:0] rotateDin16_i,
						input [`SIZE_DATA-1:0] rotateDin17_i,
						input [`SIZE_DATA-1:0] rotateDin18_i,
						input [`SIZE_DATA-1:0] rotateDin19_i,
						input [`SIZE_DATA-1:0] rotateDin20_i,
						input [`SIZE_DATA-1:0] rotateDin21_i,
						input [`SIZE_DATA-1:0] rotateDin22_i,
						input [`SIZE_DATA-1:0] rotateDin23_i,
						input [`SIZE_DATA-1:0] rotateDin24_i,
						input [`SIZE_DATA-1:0] rotateDin25_i,
						input [`SIZE_DATA-1:0] rotateDin26_i,
						input [`SIZE_DATA-1:0] rotateDin27_i,
						input [`SIZE_DATA-1:0] rotateDin28_i,
						input [`SIZE_DATA-1:0] rotateDin29_i,
						input [`SIZE_DATA-1:0] rotateDin30_i,
						input [`SIZE_DATA-1:0] rotateDin31_i,
						
						output [`SIZE_DATA-1:0] rotateDout0_o,
						output [`SIZE_DATA-1:0] rotateDout1_o,
						output [`SIZE_DATA-1:0] rotateDout2_o,
						output [`SIZE_DATA-1:0] rotateDout3_o,
						output [`SIZE_DATA-1:0] rotateDout4_o,
						output [`SIZE_DATA-1:0] rotateDout5_o,
						output [`SIZE_DATA-1:0] rotateDout6_o,
						output [`SIZE_DATA-1:0] rotateDout7_o,
						output [`SIZE_DATA-1:0] rotateDout8_o,
						output [`SIZE_DATA-1:0] rotateDout9_o,
						output [`SIZE_DATA-1:0] rotateDout10_o,
						output [`SIZE_DATA-1:0] rotateDout11_o,
						output [`SIZE_DATA-1:0] rotateDout12_o,
						output [`SIZE_DATA-1:0] rotateDout13_o,
						output [`SIZE_DATA-1:0] rotateDout14_o,
						output [`SIZE_DATA-1:0] rotateDout15_o,
						output [`SIZE_DATA-1:0] rotateDout16_o,
						output [`SIZE_DATA-1:0] rotateDout17_o,
						output [`SIZE_DATA-1:0] rotateDout18_o,
						output [`SIZE_DATA-1:0] rotateDout19_o,
						output [`SIZE_DATA-1:0] rotateDout20_o,
						output [`SIZE_DATA-1:0] rotateDout21_o,
						output [`SIZE_DATA-1:0] rotateDout22_o,
						output [`SIZE_DATA-1:0] rotateDout23_o,
						output [`SIZE_DATA-1:0] rotateDout24_o,
						output [`SIZE_DATA-1:0] rotateDout25_o,
						output [`SIZE_DATA-1:0] rotateDout26_o,
						output [`SIZE_DATA-1:0] rotateDout27_o,
						output [`SIZE_DATA-1:0] rotateDout28_o,
						output [`SIZE_DATA-1:0] rotateDout29_o,
						output [`SIZE_DATA-1:0] rotateDout30_o,
						output [`SIZE_DATA-1:0] rotateDout31_o
						
				);
	
	wire [`SIZE_CORE-1:0] predData;
	
	assign fuSM_o 			= issuedSM_i;
	assign fuWarp_o 		= issuedWarp_i;
	assign fuMask_o 		= predMask_o & issuedMask_i;
	assign fuPacket_o 		= issuedPacket_i;
	assign fuPacketValid_o 	= issuedPacketValid_i;
	
	wire instSRValid;
	wire [`SIZE_REGFILE*3+`SIZE_RP-1:0] readPacket;
	wire [`SIZE_RP-1:0] instPredReg;
	wire [`SIZE_REGFILE-1:0] instSourceReg1;
	wire [`SIZE_REGFILE-1:0] instSourceReg2;
	wire [`SIZE_REGFILE-1:0] instSourceReg3;
	
	assign instSRValid = issuedPacket_i[6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
								+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1];
	assign instPredReg = issuedPacket_i[`SIZE_RP+1+3*`SIZE_PC-1:1+3*`SIZE_PC];	
	assign instSourceReg1 = issuedPacket_i[`SIZE_REGFILE+1+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
										:1+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC];
	assign instSourceReg2 = issuedPacket_i[2*`SIZE_REGFILE+2+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
										:1+`SIZE_REGFILE+1+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC];
	assign instSourceReg3 = issuedPacket_i[3*`SIZE_REGFILE+3+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
										:1+2*`SIZE_REGFILE+2+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC];
	assign readPacket = {
							instSourceReg3,
							instSourceReg2,
							instSourceReg1,
							instPredReg
						};
	
	/*Branch and Predicate
	*/
	assign branchPC_o = issuedPacket_i[3*`SIZE_PC-1:2*`SIZE_PC];
	assign branchTarget_o = issuedPacket_i[2*`SIZE_PC-1:1*`SIZE_PC];
	assign branchReconv_o = issuedPacket_i[`SIZE_PC-1:0];

	wire [`NUM_WARP_LOG+`SIZE_RP-1:0] instPred;
	wire predLogic;
	wire [`SIZE_OPCODE-1:0] instOpcode;
	assign instPred = {issuedWarp_i, issuedPacket_i[`SIZE_RP+1+3*`SIZE_PC-1:1+3*`SIZE_PC]};
	assign predLogic = issuedPacket_i[3*`SIZE_PC];
	assign instOpcode = issuedPacket_i[`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
									:`SIZE_RP+1+3*`SIZE_PC];
									
	
	assign branch_o = issuedPacketValid_i && issuedPacket_i[3+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
							+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1];
	
	
	//wire [`SIZE_CORE-1:0] all0mask;
	//assign all0mask = 0;
	
	always @(*) begin
		if(issuedPacketValid_i) begin
			if(instPred[`SIZE_RP-1:0] == 0) begin			//Not configurable yet!
				predMask_o = -1;				     //Not configurable yet!//???
			end
			else if(~predLogic) begin
				predMask_o = predData;
			end
			else begin
				predMask_o = ~predData;
			end
		end
		else begin
			predMask_o = 0;
		end
	end
	

	
	/*Register Read & Write
	*/
	OCUnit ocUnit0(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane0_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[0]),
			.intuPacketLane_i(intuPacketLane0_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[0]),					
			.loadPacketLane_i(loadPacketLane0_i),
				
			.pred_o(predData[0]),						
			.fuPacketLane_o(fuPacketLane0_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[0]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin0_i),
			.rotateDout_o(rotateDout0_o)
			);
			
	OCUnit ocUnit1(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane1_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[1]),
			.intuPacketLane_i(intuPacketLane1_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[1]),					
			.loadPacketLane_i(loadPacketLane1_i),
			
			.pred_o(predData[1]),			
			.fuPacketLane_o(fuPacketLane1_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[1]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin1_i),
			.rotateDout_o(rotateDout1_o)				
			);
			
	OCUnit ocUnit2(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane2_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[2]),
			.intuPacketLane_i(intuPacketLane2_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[2]),					
			.loadPacketLane_i(loadPacketLane2_i),
			
			.pred_o(predData[2]),			
			.fuPacketLane_o(fuPacketLane2_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[2]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin2_i),
			.rotateDout_o(rotateDout2_o)			
			);
			
	OCUnit ocUnit3(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane3_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[3]),
			.intuPacketLane_i(intuPacketLane3_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[3]),					
			.loadPacketLane_i(loadPacketLane3_i),
			
			.pred_o(predData[3]),			
			.fuPacketLane_o(fuPacketLane3_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[3]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin3_i),
			.rotateDout_o(rotateDout3_o)			
			);
			
	OCUnit ocUnit4(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane4_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[4]),
			.intuPacketLane_i(intuPacketLane4_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[4]),					
			.loadPacketLane_i(loadPacketLane4_i),
			
			.pred_o(predData[4]),			
			.fuPacketLane_o(fuPacketLane4_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[4]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin4_i),
			.rotateDout_o(rotateDout4_o)				
			);
			
	OCUnit ocUnit5(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane5_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[5]),
			.intuPacketLane_i(intuPacketLane5_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[5]),					
			.loadPacketLane_i(loadPacketLane5_i),
			
			.pred_o(predData[5]),			
			.fuPacketLane_o(fuPacketLane5_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[5]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin5_i),
			.rotateDout_o(rotateDout5_o)				
			);
			
	OCUnit ocUnit6(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane6_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[6]),
			.intuPacketLane_i(intuPacketLane6_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[6]),					
			.loadPacketLane_i(loadPacketLane6_i),
			
			.pred_o(predData[6]),			
			.fuPacketLane_o(fuPacketLane6_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[6]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin6_i),
			.rotateDout_o(rotateDout6_o)			
			);
			
	OCUnit ocUnit7(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane7_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[7]),
			.intuPacketLane_i(intuPacketLane7_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[7]),					
			.loadPacketLane_i(loadPacketLane7_i),
			
			.pred_o(predData[7]),			
			.fuPacketLane_o(fuPacketLane7_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[7]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin7_i),
			.rotateDout_o(rotateDout7_o)			
			);
	
	OCUnit ocUnit8(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane8_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[8]),
			.intuPacketLane_i(intuPacketLane8_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[8]),					
			.loadPacketLane_i(loadPacketLane8_i),
				
			.pred_o(predData[8]),						
			.fuPacketLane_o(fuPacketLane8_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[8]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin8_i),
			.rotateDout_o(rotateDout8_o)			
			);
			
	OCUnit ocUnit9(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane9_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[9]),
			.intuPacketLane_i(intuPacketLane9_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[9]),					
			.loadPacketLane_i(loadPacketLane9_i),
			
			.pred_o(predData[9]),			
			.fuPacketLane_o(fuPacketLane9_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[9]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin9_i),
			.rotateDout_o(rotateDout9_o)				
			);
			
	OCUnit ocUnit10(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane10_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[10]),
			.intuPacketLane_i(intuPacketLane10_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[10]),					
			.loadPacketLane_i(loadPacketLane10_i),
			
			.pred_o(predData[10]),			
			.fuPacketLane_o(fuPacketLane10_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[10]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin10_i),
			.rotateDout_o(rotateDout10_o)			
			);
			
	OCUnit ocUnit11(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane11_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[11]),
			.intuPacketLane_i(intuPacketLane11_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[11]),					
			.loadPacketLane_i(loadPacketLane11_i),
			
			.pred_o(predData[11]),			
			.fuPacketLane_o(fuPacketLane11_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[11]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin11_i),
			.rotateDout_o(rotateDout11_o)			
			);
			
	OCUnit ocUnit12(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane12_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[12]),
			.intuPacketLane_i(intuPacketLane12_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[12]),					
			.loadPacketLane_i(loadPacketLane12_i),
			
			.pred_o(predData[12]),			
			.fuPacketLane_o(fuPacketLane12_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[12]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin12_i),
			.rotateDout_o(rotateDout12_o)				
			);
			
	OCUnit ocUnit13(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane13_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[13]),
			.intuPacketLane_i(intuPacketLane13_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[13]),					
			.loadPacketLane_i(loadPacketLane13_i),
			
			.pred_o(predData[13]),			
			.fuPacketLane_o(fuPacketLane13_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[13]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin13_i),
			.rotateDout_o(rotateDout13_o)				
			);
			
	OCUnit ocUnit14(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane14_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[14]),
			.intuPacketLane_i(intuPacketLane14_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[14]),					
			.loadPacketLane_i(loadPacketLane14_i),
			
			.pred_o(predData[14]),			
			.fuPacketLane_o(fuPacketLane14_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[14]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin14_i),
			.rotateDout_o(rotateDout14_o)			
			);
			
	OCUnit ocUnit15(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane15_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[15]),
			.intuPacketLane_i(intuPacketLane15_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[15]),					
			.loadPacketLane_i(loadPacketLane15_i),
			
			.pred_o(predData[15]),			
			.fuPacketLane_o(fuPacketLane15_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[15]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin15_i),
			.rotateDout_o(rotateDout15_o)			
			);
	
	OCUnit ocUnit16(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane16_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[16]),
			.intuPacketLane_i(intuPacketLane16_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[16]),					
			.loadPacketLane_i(loadPacketLane16_i),
			
			.pred_o(predData[16]),			
			.fuPacketLane_o(fuPacketLane16_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[16]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin16_i),
			.rotateDout_o(rotateDout16_o)			
			);
			
	OCUnit ocUnit17(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane17_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[17]),
			.intuPacketLane_i(intuPacketLane17_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[17]),					
			.loadPacketLane_i(loadPacketLane17_i),
			
			.pred_o(predData[17]),			
			.fuPacketLane_o(fuPacketLane17_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[17]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin17_i),
			.rotateDout_o(rotateDout17_o)			
			);
	
	OCUnit ocUnit18(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane18_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[18]),
			.intuPacketLane_i(intuPacketLane18_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[18]),					
			.loadPacketLane_i(loadPacketLane18_i),
			
			.pred_o(predData[18]),			
			.fuPacketLane_o(fuPacketLane18_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[18]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin18_i),
			.rotateDout_o(rotateDout18_o)			
			);
			
	OCUnit ocUnit19(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane19_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[19]),
			.intuPacketLane_i(intuPacketLane19_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[19]),					
			.loadPacketLane_i(loadPacketLane19_i),
			
			.pred_o(predData[19]),			
			.fuPacketLane_o(fuPacketLane19_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[19]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin19_i),
			.rotateDout_o(rotateDout19_o)			
			);
			
	OCUnit ocUnit20(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane20_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[20]),
			.intuPacketLane_i(intuPacketLane20_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[20]),					
			.loadPacketLane_i(loadPacketLane20_i),
			
			.pred_o(predData[20]),			
			.fuPacketLane_o(fuPacketLane20_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[20]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin20_i),
			.rotateDout_o(rotateDout20_o)			
			);
			
	OCUnit ocUnit21(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane21_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[21]),
			.intuPacketLane_i(intuPacketLane21_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[21]),					
			.loadPacketLane_i(loadPacketLane21_i),
			
			.pred_o(predData[21]),			
			.fuPacketLane_o(fuPacketLane21_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[21]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin21_i),
			.rotateDout_o(rotateDout21_o)			
			);
			
	OCUnit ocUnit22(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane22_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[22]),
			.intuPacketLane_i(intuPacketLane22_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[22]),					
			.loadPacketLane_i(loadPacketLane22_i),
			
			.pred_o(predData[22]),			
			.fuPacketLane_o(fuPacketLane22_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[22]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin22_i),
			.rotateDout_o(rotateDout22_o)				
			);
			
	OCUnit ocUnit23(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane23_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[23]),
			.intuPacketLane_i(intuPacketLane23_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[23]),					
			.loadPacketLane_i(loadPacketLane23_i),
			
			.pred_o(predData[23]),			
			.fuPacketLane_o(fuPacketLane23_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[23]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin23_i),
			.rotateDout_o(rotateDout23_o)				
			);
			
	OCUnit ocUnit24(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane24_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[24]),
			.intuPacketLane_i(intuPacketLane24_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[24]),					
			.loadPacketLane_i(loadPacketLane24_i),
			
			.pred_o(predData[24]),			
			.fuPacketLane_o(fuPacketLane24_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[24]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin24_i),
			.rotateDout_o(rotateDout24_o)			
			);
			
	OCUnit ocUnit25(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane25_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[25]),
			.intuPacketLane_i(intuPacketLane25_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[25]),					
			.loadPacketLane_i(loadPacketLane25_i),
			
			.pred_o(predData[25]),			
			.fuPacketLane_o(fuPacketLane25_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[25]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin25_i),
			.rotateDout_o(rotateDout25_o)			
			);
	
	OCUnit ocUnit26(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane26_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[26]),
			.intuPacketLane_i(intuPacketLane26_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[26]),					
			.loadPacketLane_i(loadPacketLane26_i),
			
			.pred_o(predData[26]),			
			.fuPacketLane_o(fuPacketLane26_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[26]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin26_i),
			.rotateDout_o(rotateDout26_o)			
			);
			
	OCUnit ocUnit27(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane27_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[27]),
			.intuPacketLane_i(intuPacketLane27_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[27]),					
			.loadPacketLane_i(loadPacketLane27_i),
			
			.pred_o(predData[27]),			
			.fuPacketLane_o(fuPacketLane27_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[27]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin27_i),
			.rotateDout_o(rotateDout27_o)			
			);
	
	OCUnit ocUnit28(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane28_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[28]),
			.intuPacketLane_i(intuPacketLane28_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[28]),					
			.loadPacketLane_i(loadPacketLane28_i),
			
			.pred_o(predData[28]),			
			.fuPacketLane_o(fuPacketLane28_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[28]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin28_i),
			.rotateDout_o(rotateDout28_o)			
			);
			
	OCUnit ocUnit29(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane29_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[29]),
			.intuPacketLane_i(intuPacketLane29_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[29]),					
			.loadPacketLane_i(loadPacketLane29_i),
			
			.pred_o(predData[29]),			
			.fuPacketLane_o(fuPacketLane29_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[29]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin29_i),
			.rotateDout_o(rotateDout29_o)			
			);

	OCUnit ocUnit30(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane30_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[30]),
			.intuPacketLane_i(intuPacketLane30_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[30]),					
			.loadPacketLane_i(loadPacketLane30_i),
			
			.pred_o(predData[30]),			
			.fuPacketLane_o(fuPacketLane30_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[30]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin30_i),
			.rotateDout_o(rotateDout30_o)			
			);
			
	OCUnit ocUnit31(
			.reset(reset),
			.clk(clk),
			.clkX4(clkX4),
			.clkPhase(clkPhase),
			
			.stall_i(stall_i),
			
			.instSRValid_i(instSRValid),
			.predefinedPacketLane_i(predefinedPacketLane31_i),
			
			.issuedWarp_i(issuedWarp_i),
			.issuedPacketValid_i(issuedPacketValid_i),
			.readPacket_i(readPacket),

			.intuWarp_i(intuWarp_i),
			.intuPacketLaneValid_i(intuMask_i[31]),
			.intuPacketLane_i(intuPacketLane31_i),
			
			.loadWarp_i(loadWarp_i),
			.loadPacketLaneValid_i(loadMask_i[31]),					
			.loadPacketLane_i(loadPacketLane31_i),
			
			.pred_o(predData[31]),			
			.fuPacketLane_o(fuPacketLane31_o),
			
			.rotate_i(rotate_i),
			.rotateValid_i(rotateMask_i[31]),
			.rotateWE_i(rotateWE_i),
			.rotateRegAddr_i(rotateRegAddr_i),
			.rotateDin_i(rotateDin31_i),
			.rotateDout_o(rotateDout31_o)			
			);
	

endmodule

