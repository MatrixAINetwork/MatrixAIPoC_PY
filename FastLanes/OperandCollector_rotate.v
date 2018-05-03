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

module OperandCollector_rotate(
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
								
						output reg [`SIZE_SM_LOG-1:0] fuSM_o,
						output reg [`NUM_WARP_LOG-1:0] fuWarp_o,
						output reg fuPacketValid_o,
						output reg [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
							+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
							:0]fuPacket_o,	
						
						output reg [`SIZE_CORE-1:0] fuMask_o,
						
						output reg [3*`SIZE_DATA-1:0] fuPacketLane0_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane1_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane2_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane3_o,		
						output reg [3*`SIZE_DATA-1:0] fuPacketLane4_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane5_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane6_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane7_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane8_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane9_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane10_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane11_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane12_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane13_o,		
						output reg [3*`SIZE_DATA-1:0] fuPacketLane14_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane15_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane16_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane17_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane18_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane19_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane20_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane21_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane22_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane23_o,		
						output reg [3*`SIZE_DATA-1:0] fuPacketLane24_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane25_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane26_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane27_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane28_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane29_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane30_o,
						output reg [3*`SIZE_DATA-1:0] fuPacketLane31_o,
						
						output reg branch_o,
						output reg [`SIZE_CORE-1:0] predMask_o,
						output reg [`SIZE_PC-1:0] branchTarget_o,
						output reg [`SIZE_PC-1:0] branchReconv_o,
						output reg [`SIZE_PC-1:0] branchPC_o,
						
						input rdRdy_i,
						input wrRdy_i,
						input rotateValid_i,	//stalled when load/store occupy the 
						input [512-1:0] mem2ocBundle_i,
						output mem2oc_o, //0: oc -> mem; 1: mem -> oc
						output reg [`SIZE_SM_LOG+1+`REGFILE_BR_INDEX-1:0] rotateMemOffset_o,
						output reg [512-1:0] oc2memBundle_o,	
						output reg rotateDone_o
						
				);
	assign mem2oc_o = mem2oc;
				
				
	wire [`SIZE_SM_LOG+1+`REGFILE_BR_INDEX-1:0] mem2ocMemOffset;			
	wire [`SIZE_SM_LOG+1+`REGFILE_BR_INDEX-1:0] oc2memMemOffset;							
				
	reg [`SIZE_SM_LOG-1:0] preSM;
	reg [`SIZE_SM_LOG-1:0] inactiveSM;
	//wire changeSM;
	//assign changeSM = (preSM != issuedSM_i);
	wire rdRdy;
	wire wrRdy;
	assign rdRdy = rdRdy_i && rotateValid_i;
	assign wrRdy = wrRdy_i && rotateValid_i;
	
	reg changeRegAddr;
	
	reg activeFile;
	reg part;
	reg mem2oc;		//0: oc -> mem; 1: mem -> oc
	reg [`REGFILE_BR_INDEX-1:0] regAddr;
	
	assign mem2ocMemOffset = {(issuedSM_i+1), part, regAddr};
	assign oc2memMemOffset = {inactiveSM, part, regAddr};
	
	always @(*) begin
		case(mem2oc)
			1'b0: begin
				rotateMemOffset_o = oc2memMemOffset;
			end
			
			1'b1: begin
				rotateMemOffset_o = mem2ocMemOffset;
			end
		endcase
	end
	
	
	always @(posedge clk) begin
		if(reset) begin
			rotateDone_o <= 0;
			activeFile <= 0;
			part <= 0;
			mem2oc <= 0;
			regAddr <= 0;
			inactiveSM <= 0;
			changeRegAddr <= 0;
		end
		else begin
			preSM <= issuedSM_i;
			if(preSM != issuedSM_i) begin
				activeFile <= activeFile + 1;
				rotateDone_o <= 1'b0;
				inactiveSM <= preSM;
			end
			else begin
				if(changeRegAddr) begin
					changeRegAddr <= 0;
				end
				else begin
					if((mem2oc == 0) && wrRdy) begin
						if(regAddr == `REGFILE_BR_DEPTH-1) begin
							regAddr <= 0;
							changeRegAddr <= 1'b1;
							if(part == 1/*512/32 = 16*/) begin
								part <= 0;
								mem2oc <= 1;
							end
							else begin
								part <= part + 1;
							end
						end
						else begin
							regAddr <= regAddr + 1;	
							changeRegAddr <= 1'b1;							
						end
					end
					else if((mem2oc == 1) && rdRdy) begin
						if(regAddr == `REGFILE_BR_DEPTH-1) begin
							//
							regAddr <= 0;
							changeRegAddr <= 1'b1;
							if(part == 1/*512/32 = 16*/) begin
								part <= 0;
								//activeFile <= activeFile + 1;
								rotateDone_o <= 1'b1;
								mem2oc <= 0;
							end
							else begin
								part <= part + 1;
							end
						end
						else begin
							regAddr <= regAddr + 1;	
							changeRegAddr <= 1'b1;
						end
					end
				end
			end
		end		
	end	
	
	reg [`SIZE_CORE-1:0] rotateMask;
	
	wire [`SIZE_DATA-1:0] rotateDin0;
	wire [`SIZE_DATA-1:0] rotateDin1;
	wire [`SIZE_DATA-1:0] rotateDin2;
	wire [`SIZE_DATA-1:0] rotateDin3;
	wire [`SIZE_DATA-1:0] rotateDin4;
	wire [`SIZE_DATA-1:0] rotateDin5;
	wire [`SIZE_DATA-1:0] rotateDin6;
	wire [`SIZE_DATA-1:0] rotateDin7;
	wire [`SIZE_DATA-1:0] rotateDin8;
	wire [`SIZE_DATA-1:0] rotateDin9;
	wire [`SIZE_DATA-1:0] rotateDin10;
	wire [`SIZE_DATA-1:0] rotateDin11;
	wire [`SIZE_DATA-1:0] rotateDin12;
	wire [`SIZE_DATA-1:0] rotateDin13;
	wire [`SIZE_DATA-1:0] rotateDin14;
	wire [`SIZE_DATA-1:0] rotateDin15;
	wire [`SIZE_DATA-1:0] rotateDin16;
	wire [`SIZE_DATA-1:0] rotateDin17;
	wire [`SIZE_DATA-1:0] rotateDin18;
	wire [`SIZE_DATA-1:0] rotateDin19;
	wire [`SIZE_DATA-1:0] rotateDin20;
	wire [`SIZE_DATA-1:0] rotateDin21;
	wire [`SIZE_DATA-1:0] rotateDin22;
	wire [`SIZE_DATA-1:0] rotateDin23;
	wire [`SIZE_DATA-1:0] rotateDin24;
	wire [`SIZE_DATA-1:0] rotateDin25;
	wire [`SIZE_DATA-1:0] rotateDin26;
	wire [`SIZE_DATA-1:0] rotateDin27;
	wire [`SIZE_DATA-1:0] rotateDin28;
	wire [`SIZE_DATA-1:0] rotateDin29;
	wire [`SIZE_DATA-1:0] rotateDin30;
	wire [`SIZE_DATA-1:0] rotateDin31;
	
	assign rotateDin0 = mem2ocBundle_i[`SIZE_DATA*1-1:`SIZE_DATA*0];
	assign rotateDin1 = mem2ocBundle_i[`SIZE_DATA*2-1:`SIZE_DATA*1];
	assign rotateDin2 = mem2ocBundle_i[`SIZE_DATA*3-1:`SIZE_DATA*2];
	assign rotateDin3 = mem2ocBundle_i[`SIZE_DATA*4-1:`SIZE_DATA*3];
	assign rotateDin4 = mem2ocBundle_i[`SIZE_DATA*5-1:`SIZE_DATA*4];
	assign rotateDin5 = mem2ocBundle_i[`SIZE_DATA*6-1:`SIZE_DATA*5];
	assign rotateDin6 = mem2ocBundle_i[`SIZE_DATA*7-1:`SIZE_DATA*6];
	assign rotateDin7 = mem2ocBundle_i[`SIZE_DATA*8-1:`SIZE_DATA*7];
	assign rotateDin8 = mem2ocBundle_i[`SIZE_DATA*9-1:`SIZE_DATA*8];
	assign rotateDin9 = mem2ocBundle_i[`SIZE_DATA*10-1:`SIZE_DATA*9];
	assign rotateDin10 = mem2ocBundle_i[`SIZE_DATA*11-1:`SIZE_DATA*10];
	assign rotateDin11 = mem2ocBundle_i[`SIZE_DATA*12-1:`SIZE_DATA*11];
	assign rotateDin12 = mem2ocBundle_i[`SIZE_DATA*13-1:`SIZE_DATA*12];
	assign rotateDin13 = mem2ocBundle_i[`SIZE_DATA*14-1:`SIZE_DATA*13];
	assign rotateDin14 = mem2ocBundle_i[`SIZE_DATA*15-1:`SIZE_DATA*14];
	assign rotateDin15 = mem2ocBundle_i[`SIZE_DATA*16-1:`SIZE_DATA*15];
	assign rotateDin16 = mem2ocBundle_i[`SIZE_DATA*1-1:`SIZE_DATA*0];
	assign rotateDin17 = mem2ocBundle_i[`SIZE_DATA*2-1:`SIZE_DATA*1];
	assign rotateDin18 = mem2ocBundle_i[`SIZE_DATA*3-1:`SIZE_DATA*2];
	assign rotateDin19 = mem2ocBundle_i[`SIZE_DATA*4-1:`SIZE_DATA*3];
	assign rotateDin20 = mem2ocBundle_i[`SIZE_DATA*5-1:`SIZE_DATA*4];
	assign rotateDin21 = mem2ocBundle_i[`SIZE_DATA*6-1:`SIZE_DATA*5];
	assign rotateDin22 = mem2ocBundle_i[`SIZE_DATA*7-1:`SIZE_DATA*6];
	assign rotateDin23 = mem2ocBundle_i[`SIZE_DATA*8-1:`SIZE_DATA*7];
	assign rotateDin24 = mem2ocBundle_i[`SIZE_DATA*9-1:`SIZE_DATA*8];
	assign rotateDin25 = mem2ocBundle_i[`SIZE_DATA*10-1:`SIZE_DATA*9];
	assign rotateDin26 = mem2ocBundle_i[`SIZE_DATA*11-1:`SIZE_DATA*10];
	assign rotateDin27 = mem2ocBundle_i[`SIZE_DATA*12-1:`SIZE_DATA*11];
	assign rotateDin28 = mem2ocBundle_i[`SIZE_DATA*13-1:`SIZE_DATA*12];
	assign rotateDin29 = mem2ocBundle_i[`SIZE_DATA*14-1:`SIZE_DATA*13];
	assign rotateDin30 = mem2ocBundle_i[`SIZE_DATA*15-1:`SIZE_DATA*14];
	assign rotateDin31 = mem2ocBundle_i[`SIZE_DATA*16-1:`SIZE_DATA*15];
	
	
	wire [`SIZE_DATA-1:0] rotateDout0_rf0;
	wire [`SIZE_DATA-1:0] rotateDout1_rf0;
	wire [`SIZE_DATA-1:0] rotateDout2_rf0;
	wire [`SIZE_DATA-1:0] rotateDout3_rf0;
	wire [`SIZE_DATA-1:0] rotateDout4_rf0;
	wire [`SIZE_DATA-1:0] rotateDout5_rf0;
	wire [`SIZE_DATA-1:0] rotateDout6_rf0;
	wire [`SIZE_DATA-1:0] rotateDout7_rf0;
	wire [`SIZE_DATA-1:0] rotateDout8_rf0;
	wire [`SIZE_DATA-1:0] rotateDout9_rf0;
	wire [`SIZE_DATA-1:0] rotateDout10_rf0;
	wire [`SIZE_DATA-1:0] rotateDout11_rf0;
	wire [`SIZE_DATA-1:0] rotateDout12_rf0;
	wire [`SIZE_DATA-1:0] rotateDout13_rf0;
	wire [`SIZE_DATA-1:0] rotateDout14_rf0;
	wire [`SIZE_DATA-1:0] rotateDout15_rf0;
	wire [`SIZE_DATA-1:0] rotateDout16_rf0;
	wire [`SIZE_DATA-1:0] rotateDout17_rf0;
	wire [`SIZE_DATA-1:0] rotateDout18_rf0;
	wire [`SIZE_DATA-1:0] rotateDout19_rf0;
	wire [`SIZE_DATA-1:0] rotateDout20_rf0;
	wire [`SIZE_DATA-1:0] rotateDout21_rf0;
	wire [`SIZE_DATA-1:0] rotateDout22_rf0;
	wire [`SIZE_DATA-1:0] rotateDout23_rf0;
	wire [`SIZE_DATA-1:0] rotateDout24_rf0;
	wire [`SIZE_DATA-1:0] rotateDout25_rf0;
	wire [`SIZE_DATA-1:0] rotateDout26_rf0;
	wire [`SIZE_DATA-1:0] rotateDout27_rf0;
	wire [`SIZE_DATA-1:0] rotateDout28_rf0;
	wire [`SIZE_DATA-1:0] rotateDout29_rf0;
	wire [`SIZE_DATA-1:0] rotateDout30_rf0;
	wire [`SIZE_DATA-1:0] rotateDout31_rf0;
	wire [512-1:0] oc2memBundle_rf0_pt0;
	wire [512-1:0] oc2memBundle_rf0_pt1;
	reg [512-1:0] oc2memBundle_rf0;
	
	assign oc2memBundle_rf0_pt0 = {
									rotateDout15_rf0,
									rotateDout14_rf0,
									rotateDout13_rf0,
									rotateDout12_rf0,
									rotateDout11_rf0,
									rotateDout10_rf0,
									rotateDout9_rf0,
									rotateDout8_rf0,
									rotateDout7_rf0,
									rotateDout6_rf0,
									rotateDout5_rf0,
									rotateDout4_rf0,
									rotateDout3_rf0,
									rotateDout2_rf0,
									rotateDout1_rf0,
									rotateDout0_rf0
								};
	assign oc2memBundle_rf0_pt1 = {
									rotateDout31_rf0,
									rotateDout30_rf0,
									rotateDout29_rf0,
									rotateDout28_rf0,
									rotateDout27_rf0,
									rotateDout26_rf0,
									rotateDout25_rf0,
									rotateDout24_rf0,
									rotateDout23_rf0,
									rotateDout22_rf0,
									rotateDout21_rf0,
									rotateDout20_rf0,
									rotateDout19_rf0,
									rotateDout18_rf0,
									rotateDout17_rf0,
									rotateDout16_rf0
								};			

	wire [`SIZE_DATA-1:0] rotateDout0_rf1;
	wire [`SIZE_DATA-1:0] rotateDout1_rf1;
	wire [`SIZE_DATA-1:0] rotateDout2_rf1;
	wire [`SIZE_DATA-1:0] rotateDout3_rf1;
	wire [`SIZE_DATA-1:0] rotateDout4_rf1;
	wire [`SIZE_DATA-1:0] rotateDout5_rf1;
	wire [`SIZE_DATA-1:0] rotateDout6_rf1;
	wire [`SIZE_DATA-1:0] rotateDout7_rf1;
	wire [`SIZE_DATA-1:0] rotateDout8_rf1;
	wire [`SIZE_DATA-1:0] rotateDout9_rf1;
	wire [`SIZE_DATA-1:0] rotateDout10_rf1;
	wire [`SIZE_DATA-1:0] rotateDout11_rf1;
	wire [`SIZE_DATA-1:0] rotateDout12_rf1;
	wire [`SIZE_DATA-1:0] rotateDout13_rf1;
	wire [`SIZE_DATA-1:0] rotateDout14_rf1;
	wire [`SIZE_DATA-1:0] rotateDout15_rf1;
	wire [`SIZE_DATA-1:0] rotateDout16_rf1;
	wire [`SIZE_DATA-1:0] rotateDout17_rf1;
	wire [`SIZE_DATA-1:0] rotateDout18_rf1;
	wire [`SIZE_DATA-1:0] rotateDout19_rf1;
	wire [`SIZE_DATA-1:0] rotateDout20_rf1;
	wire [`SIZE_DATA-1:0] rotateDout21_rf1;
	wire [`SIZE_DATA-1:0] rotateDout22_rf1;
	wire [`SIZE_DATA-1:0] rotateDout23_rf1;
	wire [`SIZE_DATA-1:0] rotateDout24_rf1;
	wire [`SIZE_DATA-1:0] rotateDout25_rf1;
	wire [`SIZE_DATA-1:0] rotateDout26_rf1;
	wire [`SIZE_DATA-1:0] rotateDout27_rf1;
	wire [`SIZE_DATA-1:0] rotateDout28_rf1;
	wire [`SIZE_DATA-1:0] rotateDout29_rf1;
	wire [`SIZE_DATA-1:0] rotateDout30_rf1;
	wire [`SIZE_DATA-1:0] rotateDout31_rf1;
	wire [512-1:0] oc2memBundle_rf1_pt0;
	wire [512-1:0] oc2memBundle_rf1_pt1;
	reg [512-1:0] oc2memBundle_rf1;
	
	assign oc2memBundle_rf1_pt0 = {
									rotateDout15_rf1,
									rotateDout14_rf1,
									rotateDout13_rf1,
									rotateDout12_rf1,
									rotateDout11_rf1,
									rotateDout10_rf1,
									rotateDout9_rf1,
									rotateDout8_rf1,
									rotateDout7_rf1,
									rotateDout6_rf1,
									rotateDout5_rf1,
									rotateDout4_rf1,
									rotateDout3_rf1,
									rotateDout2_rf1,
									rotateDout1_rf1,
									rotateDout0_rf1
								};
	assign oc2memBundle_rf1_pt1 = {
									rotateDout31_rf1,
									rotateDout30_rf1,
									rotateDout29_rf1,
									rotateDout28_rf1,
									rotateDout27_rf1,
									rotateDout26_rf1,
									rotateDout25_rf1,
									rotateDout24_rf1,
									rotateDout23_rf1,
									rotateDout22_rf1,
									rotateDout21_rf1,
									rotateDout20_rf1,
									rotateDout19_rf1,
									rotateDout18_rf1,
									rotateDout17_rf1,
									rotateDout16_rf1
								};		
	
	always@(*) begin
		case(part)
			0: begin
				rotateMask = {{16{1'b0}}, {16{1'b1}}};
				oc2memBundle_rf0 = oc2memBundle_rf0_pt0;
				oc2memBundle_rf1 = oc2memBundle_rf1_pt0;
			end
			
			1: begin
				rotateMask = {{16{1'b1}}, {16{1'b0}}};
				oc2memBundle_rf0 = oc2memBundle_rf0_pt1;
				oc2memBundle_rf1 = oc2memBundle_rf1_pt1;
			end
		endcase	
	end
	
	
	
	reg rotate_rf0;
	reg rotate_rf1;
	/////////////////////////////////////////////////////////////////////////////////
	always @(*) begin
		case(activeFile)
			0: begin
				rotate_rf0 = 1'b0;
				rotate_rf1 = 1'b1;
			end
			
			1: begin
				rotate_rf0 = 1'b1;
				rotate_rf1 = 1'b0;
			end		
		endcase
	end
	
	
	
	wire [`SIZE_SM_LOG-1:0] fuSM_rf0;
	wire [`NUM_WARP_LOG-1:0] fuWarp_rf0;
	wire fuPacketValid_rf0;
	wire [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
		+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
		:0]fuPacket_rf0;		
	wire [`SIZE_CORE-1:0] fuMask_rf0;	
	wire [3*`SIZE_DATA-1:0] fuPacketLane0_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane1_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane2_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane3_rf0;		
	wire [3*`SIZE_DATA-1:0] fuPacketLane4_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane5_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane6_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane7_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane8_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane9_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane10_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane11_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane12_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane13_rf0;		
	wire [3*`SIZE_DATA-1:0] fuPacketLane14_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane15_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane16_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane17_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane18_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane19_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane20_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane21_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane22_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane23_rf0;		
	wire [3*`SIZE_DATA-1:0] fuPacketLane24_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane25_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane26_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane27_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane28_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane29_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane30_rf0;
	wire [3*`SIZE_DATA-1:0] fuPacketLane31_rf0;	
	wire branch_rf0;
	wire [`SIZE_CORE-1:0] predMask_rf0;
	wire [`SIZE_PC-1:0] branchTarget_rf0;
	wire [`SIZE_PC-1:0] branchReconv_rf0;
	wire [`SIZE_PC-1:0] branchPC_rf0;				
	OperandCollector 
		operandCollector_rf0(
						.reset(reset),
						.clk(clk),
						.clkX4(clkX4),
						.clkPhase(clkPhase),
						
						.stall_i(stall_i),
						
						.issuedSM_i(issuedSM_i),
						.issuedWarp_i(issuedWarp_i),	//set SIMD width
						.issuedPacketValid_i(issuedPacketValid_i),
						.issuedPacket_i(issuedPacket_i),
						.issuedMask_i(issuedMask_i),
						

						.predefinedPacketLane0_i(predefinedPacketLane0_i),
						.predefinedPacketLane1_i(predefinedPacketLane1_i),
						.predefinedPacketLane2_i(predefinedPacketLane2_i),
						.predefinedPacketLane3_i(predefinedPacketLane3_i),
						.predefinedPacketLane4_i(predefinedPacketLane4_i),
						.predefinedPacketLane5_i(predefinedPacketLane5_i),
						.predefinedPacketLane6_i(predefinedPacketLane6_i),
						.predefinedPacketLane7_i(predefinedPacketLane7_i),
						.predefinedPacketLane8_i(predefinedPacketLane8_i),
						.predefinedPacketLane9_i(predefinedPacketLane9_i),
						.predefinedPacketLane10_i(predefinedPacketLane10_i),
						.predefinedPacketLane11_i(predefinedPacketLane11_i),
						.predefinedPacketLane12_i(predefinedPacketLane12_i),
						.predefinedPacketLane13_i(predefinedPacketLane13_i),
						.predefinedPacketLane14_i(predefinedPacketLane14_i),
						.predefinedPacketLane15_i(predefinedPacketLane15_i),
						.predefinedPacketLane16_i(predefinedPacketLane16_i),
						.predefinedPacketLane17_i(predefinedPacketLane17_i),
						.predefinedPacketLane18_i(predefinedPacketLane18_i),
						.predefinedPacketLane19_i(predefinedPacketLane19_i),
						.predefinedPacketLane20_i(predefinedPacketLane20_i),
						.predefinedPacketLane21_i(predefinedPacketLane21_i),
						.predefinedPacketLane22_i(predefinedPacketLane22_i),
						.predefinedPacketLane23_i(predefinedPacketLane23_i),
						.predefinedPacketLane24_i(predefinedPacketLane24_i),
						.predefinedPacketLane25_i(predefinedPacketLane25_i),
						.predefinedPacketLane26_i(predefinedPacketLane26_i),
						.predefinedPacketLane27_i(predefinedPacketLane27_i),
						.predefinedPacketLane28_i(predefinedPacketLane28_i),
						.predefinedPacketLane29_i(predefinedPacketLane29_i),
						.predefinedPacketLane30_i(predefinedPacketLane30_i),
						.predefinedPacketLane31_i(predefinedPacketLane31_i),
			
						//.intuPacket_i(),
						.intuWarp_i(intuWarp_i),
						.intuMask_i(intuMask_i),
						.intuPacketLane0_i(intuPacketLane0_i),
						.intuPacketLane1_i(intuPacketLane1_i),
						.intuPacketLane2_i(intuPacketLane2_i),
						.intuPacketLane3_i(intuPacketLane3_i),
						.intuPacketLane4_i(intuPacketLane4_i),
						.intuPacketLane5_i(intuPacketLane5_i),
						.intuPacketLane6_i(intuPacketLane6_i),
						.intuPacketLane7_i(intuPacketLane7_i),
						.intuPacketLane8_i(intuPacketLane8_i),
						.intuPacketLane9_i(intuPacketLane9_i),
						.intuPacketLane10_i(intuPacketLane10_i),
						.intuPacketLane11_i(intuPacketLane11_i),
						.intuPacketLane12_i(intuPacketLane12_i),
						.intuPacketLane13_i(intuPacketLane13_i),
						.intuPacketLane14_i(intuPacketLane14_i),
						.intuPacketLane15_i(intuPacketLane15_i),
						.intuPacketLane16_i(intuPacketLane16_i),
						.intuPacketLane17_i(intuPacketLane17_i),
						.intuPacketLane18_i(intuPacketLane18_i),
						.intuPacketLane19_i(intuPacketLane19_i),
						.intuPacketLane20_i(intuPacketLane20_i),
						.intuPacketLane21_i(intuPacketLane21_i),
						.intuPacketLane22_i(intuPacketLane22_i),
						.intuPacketLane23_i(intuPacketLane23_i),
						.intuPacketLane24_i(intuPacketLane24_i),
						.intuPacketLane25_i(intuPacketLane25_i),
						.intuPacketLane26_i(intuPacketLane26_i),
						.intuPacketLane27_i(intuPacketLane27_i),
						.intuPacketLane28_i(intuPacketLane28_i),
						.intuPacketLane29_i(intuPacketLane29_i),
						.intuPacketLane30_i(intuPacketLane30_i),
						.intuPacketLane31_i(intuPacketLane31_i),
						
						.loadWarp_i(loadWarp_i),
						.loadMask_i(loadMask_i),					
						.loadPacketLane0_i(loadPacketLane0_i),
						.loadPacketLane1_i(loadPacketLane1_i),
						.loadPacketLane2_i(loadPacketLane2_i),
						.loadPacketLane3_i(loadPacketLane3_i),
						.loadPacketLane4_i(loadPacketLane4_i),
						.loadPacketLane5_i(loadPacketLane5_i),
						.loadPacketLane6_i(loadPacketLane6_i),
						.loadPacketLane7_i(loadPacketLane7_i),						
						.loadPacketLane8_i(loadPacketLane8_i),
						.loadPacketLane9_i(loadPacketLane9_i),
						.loadPacketLane10_i(loadPacketLane10_i),
						.loadPacketLane11_i(loadPacketLane11_i),
						.loadPacketLane12_i(loadPacketLane12_i),
						.loadPacketLane13_i(loadPacketLane13_i),
						.loadPacketLane14_i(loadPacketLane14_i),
						.loadPacketLane15_i(loadPacketLane15_i),
						.loadPacketLane16_i(loadPacketLane16_i),
						.loadPacketLane17_i(loadPacketLane17_i),
						.loadPacketLane18_i(loadPacketLane18_i),
						.loadPacketLane19_i(loadPacketLane19_i),
						.loadPacketLane20_i(loadPacketLane20_i),
						.loadPacketLane21_i(loadPacketLane21_i),
						.loadPacketLane22_i(loadPacketLane22_i),
						.loadPacketLane23_i(loadPacketLane23_i),
						.loadPacketLane24_i(loadPacketLane24_i),
						.loadPacketLane25_i(loadPacketLane25_i),
						.loadPacketLane26_i(loadPacketLane26_i),
						.loadPacketLane27_i(loadPacketLane27_i),
						.loadPacketLane28_i(loadPacketLane28_i),
						.loadPacketLane29_i(loadPacketLane29_i),
						.loadPacketLane30_i(loadPacketLane30_i),
						.loadPacketLane31_i(loadPacketLane31_i),
					
						
						.fuSM_o(fuSM_rf0),
						.fuWarp_o(fuWarp_rf0),
						.fuPacketValid_o(fuPacketValid_rf0),
						.fuPacket_o(fuPacket_rf0),
						
						.fuMask_o(fuMask_rf0),
						.fuPacketLane0_o(fuPacketLane0_rf0),
						.fuPacketLane1_o(fuPacketLane1_rf0),
						.fuPacketLane2_o(fuPacketLane2_rf0),
						.fuPacketLane3_o(fuPacketLane3_rf0),
						.fuPacketLane4_o(fuPacketLane4_rf0),
						.fuPacketLane5_o(fuPacketLane5_rf0),
						.fuPacketLane6_o(fuPacketLane6_rf0),
						.fuPacketLane7_o(fuPacketLane7_rf0),
						.fuPacketLane8_o(fuPacketLane8_rf0),
						.fuPacketLane9_o(fuPacketLane9_rf0),
						.fuPacketLane10_o(fuPacketLane10_rf0),
						.fuPacketLane11_o(fuPacketLane11_rf0),
						.fuPacketLane12_o(fuPacketLane12_rf0),
						.fuPacketLane13_o(fuPacketLane13_rf0),
						.fuPacketLane14_o(fuPacketLane14_rf0),
						.fuPacketLane15_o(fuPacketLane15_rf0),
						.fuPacketLane16_o(fuPacketLane16_rf0),
						.fuPacketLane17_o(fuPacketLane17_rf0),
						.fuPacketLane18_o(fuPacketLane18_rf0),
						.fuPacketLane19_o(fuPacketLane19_rf0),
						.fuPacketLane20_o(fuPacketLane20_rf0),
						.fuPacketLane21_o(fuPacketLane21_rf0),
						.fuPacketLane22_o(fuPacketLane22_rf0),
						.fuPacketLane23_o(fuPacketLane23_rf0),
						.fuPacketLane24_o(fuPacketLane24_rf0),
						.fuPacketLane25_o(fuPacketLane25_rf0),
						.fuPacketLane26_o(fuPacketLane26_rf0),
						.fuPacketLane27_o(fuPacketLane27_rf0),
						.fuPacketLane28_o(fuPacketLane28_rf0),
						.fuPacketLane29_o(fuPacketLane29_rf0),
						.fuPacketLane30_o(fuPacketLane30_rf0),
						.fuPacketLane31_o(fuPacketLane31_rf0),
						
						.branch_o(branch_rf0),
						.predMask_o(predMask_rf0),
						.branchTarget_o(branchTarget_rf0),
						.branchReconv_o(branchReconv_rf0),
						.branchPC_o(branchPC_rf0),
						
						.rotate_i(rotate_rf0),
						.rotateMask_i(rotateMask),
						.rotateWE_i(mem2oc),
						.rotateRegAddr_i(regAddr),
						.rotateDin0_i(rotateDin0),
						.rotateDin1_i(rotateDin1),
						.rotateDin2_i(rotateDin2),
						.rotateDin3_i(rotateDin3),
						.rotateDin4_i(rotateDin4),
						.rotateDin5_i(rotateDin5),
						.rotateDin6_i(rotateDin6),
						.rotateDin7_i(rotateDin7),
						.rotateDin8_i(rotateDin8),
						.rotateDin9_i(rotateDin9),
						.rotateDin10_i(rotateDin10),
						.rotateDin11_i(rotateDin11),
						.rotateDin12_i(rotateDin12),
						.rotateDin13_i(rotateDin13),
						.rotateDin14_i(rotateDin14),
						.rotateDin15_i(rotateDin15),
						.rotateDin16_i(rotateDin16),
						.rotateDin17_i(rotateDin17),
						.rotateDin18_i(rotateDin18),
						.rotateDin19_i(rotateDin19),
						.rotateDin20_i(rotateDin20),
						.rotateDin21_i(rotateDin21),
						.rotateDin22_i(rotateDin22),
						.rotateDin23_i(rotateDin23),
						.rotateDin24_i(rotateDin24),
						.rotateDin25_i(rotateDin25),
						.rotateDin26_i(rotateDin26),
						.rotateDin27_i(rotateDin27),
						.rotateDin28_i(rotateDin28),
						.rotateDin29_i(rotateDin29),
						.rotateDin30_i(rotateDin30),
						.rotateDin31_i(rotateDin31),
						
						.rotateDout0_o(rotateDout0_rf0),
						.rotateDout1_o(rotateDout1_rf0),
						.rotateDout2_o(rotateDout2_rf0),
						.rotateDout3_o(rotateDout3_rf0),
						.rotateDout4_o(rotateDout4_rf0),
						.rotateDout5_o(rotateDout5_rf0),
						.rotateDout6_o(rotateDout6_rf0),
						.rotateDout7_o(rotateDout7_rf0),
						.rotateDout8_o(rotateDout8_rf0),
						.rotateDout9_o(rotateDout9_rf0),
						.rotateDout10_o(rotateDout10_rf0),
						.rotateDout11_o(rotateDout11_rf0),
						.rotateDout12_o(rotateDout12_rf0),
						.rotateDout13_o(rotateDout13_rf0),
						.rotateDout14_o(rotateDout14_rf0),
						.rotateDout15_o(rotateDout15_rf0),
						.rotateDout16_o(rotateDout16_rf0),
						.rotateDout17_o(rotateDout17_rf0),
						.rotateDout18_o(rotateDout18_rf0),
						.rotateDout19_o(rotateDout19_rf0),
						.rotateDout20_o(rotateDout20_rf0),
						.rotateDout21_o(rotateDout21_rf0),
						.rotateDout22_o(rotateDout22_rf0),
						.rotateDout23_o(rotateDout23_rf0),
						.rotateDout24_o(rotateDout24_rf0),
						.rotateDout25_o(rotateDout25_rf0),
						.rotateDout26_o(rotateDout26_rf0),
						.rotateDout27_o(rotateDout27_rf0),
						.rotateDout28_o(rotateDout28_rf0),
						.rotateDout29_o(rotateDout29_rf0),
						.rotateDout30_o(rotateDout30_rf0),
						.rotateDout31_o(rotateDout31_rf0)
				);
	wire [`SIZE_SM_LOG-1:0] fuSM_rf1;
	wire [`NUM_WARP_LOG-1:0] fuWarp_rf1;
	wire fuPacketValid_rf1;
	wire [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
		+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
		:0]fuPacket_rf1;	
	wire [`SIZE_CORE-1:0] fuMask_rf1;	
	wire [3*`SIZE_DATA-1:0] fuPacketLane0_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane1_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane2_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane3_rf1;		
	wire [3*`SIZE_DATA-1:0] fuPacketLane4_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane5_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane6_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane7_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane8_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane9_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane10_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane11_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane12_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane13_rf1;		
	wire [3*`SIZE_DATA-1:0] fuPacketLane14_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane15_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane16_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane17_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane18_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane19_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane20_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane21_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane22_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane23_rf1;		
	wire [3*`SIZE_DATA-1:0] fuPacketLane24_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane25_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane26_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane27_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane28_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane29_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane30_rf1;
	wire [3*`SIZE_DATA-1:0] fuPacketLane31_rf1;	
	wire branch_rf1;
	wire [`SIZE_CORE-1:0] predMask_rf1;
	wire [`SIZE_PC-1:0] branchTarget_rf1;
	wire [`SIZE_PC-1:0] branchReconv_rf1;
	wire [`SIZE_PC-1:0] branchPC_rf1;	
	OperandCollector 
		operandCollector_rf1(
						.reset(reset),
						.clk(clk),
						.clkX4(clkX4),
						.clkPhase(clkPhase),
						
						.stall_i(stall_i),
						
						.issuedSM_i(issuedSM_i),
						.issuedWarp_i(issuedWarp_i),	//set SIMD width
						.issuedPacketValid_i(issuedPacketValid_i),
						.issuedPacket_i(issuedPacket_i),
						.issuedMask_i(issuedMask_i),
						

						.predefinedPacketLane0_i(predefinedPacketLane0_i),
						.predefinedPacketLane1_i(predefinedPacketLane1_i),
						.predefinedPacketLane2_i(predefinedPacketLane2_i),
						.predefinedPacketLane3_i(predefinedPacketLane3_i),
						.predefinedPacketLane4_i(predefinedPacketLane4_i),
						.predefinedPacketLane5_i(predefinedPacketLane5_i),
						.predefinedPacketLane6_i(predefinedPacketLane6_i),
						.predefinedPacketLane7_i(predefinedPacketLane7_i),
						.predefinedPacketLane8_i(predefinedPacketLane8_i),
						.predefinedPacketLane9_i(predefinedPacketLane9_i),
						.predefinedPacketLane10_i(predefinedPacketLane10_i),
						.predefinedPacketLane11_i(predefinedPacketLane11_i),
						.predefinedPacketLane12_i(predefinedPacketLane12_i),
						.predefinedPacketLane13_i(predefinedPacketLane13_i),
						.predefinedPacketLane14_i(predefinedPacketLane14_i),
						.predefinedPacketLane15_i(predefinedPacketLane15_i),
						.predefinedPacketLane16_i(predefinedPacketLane16_i),
						.predefinedPacketLane17_i(predefinedPacketLane17_i),
						.predefinedPacketLane18_i(predefinedPacketLane18_i),
						.predefinedPacketLane19_i(predefinedPacketLane19_i),
						.predefinedPacketLane20_i(predefinedPacketLane20_i),
						.predefinedPacketLane21_i(predefinedPacketLane21_i),
						.predefinedPacketLane22_i(predefinedPacketLane22_i),
						.predefinedPacketLane23_i(predefinedPacketLane23_i),
						.predefinedPacketLane24_i(predefinedPacketLane24_i),
						.predefinedPacketLane25_i(predefinedPacketLane25_i),
						.predefinedPacketLane26_i(predefinedPacketLane26_i),
						.predefinedPacketLane27_i(predefinedPacketLane27_i),
						.predefinedPacketLane28_i(predefinedPacketLane28_i),
						.predefinedPacketLane29_i(predefinedPacketLane29_i),
						.predefinedPacketLane30_i(predefinedPacketLane30_i),
						.predefinedPacketLane31_i(predefinedPacketLane31_i),
			
						//.intuPacket_i(),
						.intuWarp_i(intuWarp_i),
						.intuMask_i(intuMask_i),
						.intuPacketLane0_i(intuPacketLane0_i),
						.intuPacketLane1_i(intuPacketLane1_i),
						.intuPacketLane2_i(intuPacketLane2_i),
						.intuPacketLane3_i(intuPacketLane3_i),
						.intuPacketLane4_i(intuPacketLane4_i),
						.intuPacketLane5_i(intuPacketLane5_i),
						.intuPacketLane6_i(intuPacketLane6_i),
						.intuPacketLane7_i(intuPacketLane7_i),
						.intuPacketLane8_i(intuPacketLane8_i),
						.intuPacketLane9_i(intuPacketLane9_i),
						.intuPacketLane10_i(intuPacketLane10_i),
						.intuPacketLane11_i(intuPacketLane11_i),
						.intuPacketLane12_i(intuPacketLane12_i),
						.intuPacketLane13_i(intuPacketLane13_i),
						.intuPacketLane14_i(intuPacketLane14_i),
						.intuPacketLane15_i(intuPacketLane15_i),
						.intuPacketLane16_i(intuPacketLane16_i),
						.intuPacketLane17_i(intuPacketLane17_i),
						.intuPacketLane18_i(intuPacketLane18_i),
						.intuPacketLane19_i(intuPacketLane19_i),
						.intuPacketLane20_i(intuPacketLane20_i),
						.intuPacketLane21_i(intuPacketLane21_i),
						.intuPacketLane22_i(intuPacketLane22_i),
						.intuPacketLane23_i(intuPacketLane23_i),
						.intuPacketLane24_i(intuPacketLane24_i),
						.intuPacketLane25_i(intuPacketLane25_i),
						.intuPacketLane26_i(intuPacketLane26_i),
						.intuPacketLane27_i(intuPacketLane27_i),
						.intuPacketLane28_i(intuPacketLane28_i),
						.intuPacketLane29_i(intuPacketLane29_i),
						.intuPacketLane30_i(intuPacketLane30_i),
						.intuPacketLane31_i(intuPacketLane31_i),
						
						.loadWarp_i(loadWarp_i),
						.loadMask_i(loadMask_i),					
						.loadPacketLane0_i(loadPacketLane0_i),
						.loadPacketLane1_i(loadPacketLane1_i),
						.loadPacketLane2_i(loadPacketLane2_i),
						.loadPacketLane3_i(loadPacketLane3_i),
						.loadPacketLane4_i(loadPacketLane4_i),
						.loadPacketLane5_i(loadPacketLane5_i),
						.loadPacketLane6_i(loadPacketLane6_i),
						.loadPacketLane7_i(loadPacketLane7_i),						
						.loadPacketLane8_i(loadPacketLane8_i),
						.loadPacketLane9_i(loadPacketLane9_i),
						.loadPacketLane10_i(loadPacketLane10_i),
						.loadPacketLane11_i(loadPacketLane11_i),
						.loadPacketLane12_i(loadPacketLane12_i),
						.loadPacketLane13_i(loadPacketLane13_i),
						.loadPacketLane14_i(loadPacketLane14_i),
						.loadPacketLane15_i(loadPacketLane15_i),
						.loadPacketLane16_i(loadPacketLane16_i),
						.loadPacketLane17_i(loadPacketLane17_i),
						.loadPacketLane18_i(loadPacketLane18_i),
						.loadPacketLane19_i(loadPacketLane19_i),
						.loadPacketLane20_i(loadPacketLane20_i),
						.loadPacketLane21_i(loadPacketLane21_i),
						.loadPacketLane22_i(loadPacketLane22_i),
						.loadPacketLane23_i(loadPacketLane23_i),
						.loadPacketLane24_i(loadPacketLane24_i),
						.loadPacketLane25_i(loadPacketLane25_i),
						.loadPacketLane26_i(loadPacketLane26_i),
						.loadPacketLane27_i(loadPacketLane27_i),
						.loadPacketLane28_i(loadPacketLane28_i),
						.loadPacketLane29_i(loadPacketLane29_i),
						.loadPacketLane30_i(loadPacketLane30_i),
						.loadPacketLane31_i(loadPacketLane31_i),
					
						
						.fuSM_o(fuSM_rf1),
						.fuWarp_o(fuWarp_rf1),
						.fuPacketValid_o(fuPacketValid_rf1),
						.fuPacket_o(fuPacket_rf1),
						
						.fuMask_o(fuMask_rf1),
						.fuPacketLane0_o(fuPacketLane0_rf1),
						.fuPacketLane1_o(fuPacketLane1_rf1),
						.fuPacketLane2_o(fuPacketLane2_rf1),
						.fuPacketLane3_o(fuPacketLane3_rf1),
						.fuPacketLane4_o(fuPacketLane4_rf1),
						.fuPacketLane5_o(fuPacketLane5_rf1),
						.fuPacketLane6_o(fuPacketLane6_rf1),
						.fuPacketLane7_o(fuPacketLane7_rf1),
						.fuPacketLane8_o(fuPacketLane8_rf1),
						.fuPacketLane9_o(fuPacketLane9_rf1),
						.fuPacketLane10_o(fuPacketLane10_rf1),
						.fuPacketLane11_o(fuPacketLane11_rf1),
						.fuPacketLane12_o(fuPacketLane12_rf1),
						.fuPacketLane13_o(fuPacketLane13_rf1),
						.fuPacketLane14_o(fuPacketLane14_rf1),
						.fuPacketLane15_o(fuPacketLane15_rf1),
						.fuPacketLane16_o(fuPacketLane16_rf1),
						.fuPacketLane17_o(fuPacketLane17_rf1),
						.fuPacketLane18_o(fuPacketLane18_rf1),
						.fuPacketLane19_o(fuPacketLane19_rf1),
						.fuPacketLane20_o(fuPacketLane20_rf1),
						.fuPacketLane21_o(fuPacketLane21_rf1),
						.fuPacketLane22_o(fuPacketLane22_rf1),
						.fuPacketLane23_o(fuPacketLane23_rf1),
						.fuPacketLane24_o(fuPacketLane24_rf1),
						.fuPacketLane25_o(fuPacketLane25_rf1),
						.fuPacketLane26_o(fuPacketLane26_rf1),
						.fuPacketLane27_o(fuPacketLane27_rf1),
						.fuPacketLane28_o(fuPacketLane28_rf1),
						.fuPacketLane29_o(fuPacketLane29_rf1),
						.fuPacketLane30_o(fuPacketLane30_rf1),
						.fuPacketLane31_o(fuPacketLane31_rf1),
						
						.branch_o(branch_rf1),
						.predMask_o(predMask_rf1),
						.branchTarget_o(branchTarget_rf1),
						.branchReconv_o(branchReconv_rf1),
						.branchPC_o(branchPC_rf1),
						
						.rotate_i(rotate_rf1),
						.rotateMask_i(rotateMask),
						.rotateWE_i(mem2oc),
						.rotateRegAddr_i(regAddr),
						.rotateDin0_i(rotateDin0),
						.rotateDin1_i(rotateDin1),
						.rotateDin2_i(rotateDin2),
						.rotateDin3_i(rotateDin3),
						.rotateDin4_i(rotateDin4),
						.rotateDin5_i(rotateDin5),
						.rotateDin6_i(rotateDin6),
						.rotateDin7_i(rotateDin7),
						.rotateDin8_i(rotateDin8),
						.rotateDin9_i(rotateDin9),
						.rotateDin10_i(rotateDin10),
						.rotateDin11_i(rotateDin11),
						.rotateDin12_i(rotateDin12),
						.rotateDin13_i(rotateDin13),
						.rotateDin14_i(rotateDin14),
						.rotateDin15_i(rotateDin15),
						.rotateDin16_i(rotateDin16),
						.rotateDin17_i(rotateDin17),
						.rotateDin18_i(rotateDin18),
						.rotateDin19_i(rotateDin19),
						.rotateDin20_i(rotateDin20),
						.rotateDin21_i(rotateDin21),
						.rotateDin22_i(rotateDin22),
						.rotateDin23_i(rotateDin23),
						.rotateDin24_i(rotateDin24),
						.rotateDin25_i(rotateDin25),
						.rotateDin26_i(rotateDin26),
						.rotateDin27_i(rotateDin27),
						.rotateDin28_i(rotateDin28),
						.rotateDin29_i(rotateDin29),
						.rotateDin30_i(rotateDin30),
						.rotateDin31_i(rotateDin31),
						
						.rotateDout0_o(rotateDout0_rf1),
						.rotateDout1_o(rotateDout1_rf1),
						.rotateDout2_o(rotateDout2_rf1),
						.rotateDout3_o(rotateDout3_rf1),
						.rotateDout4_o(rotateDout4_rf1),
						.rotateDout5_o(rotateDout5_rf1),
						.rotateDout6_o(rotateDout6_rf1),
						.rotateDout7_o(rotateDout7_rf1),
						.rotateDout8_o(rotateDout8_rf1),
						.rotateDout9_o(rotateDout9_rf1),
						.rotateDout10_o(rotateDout10_rf1),
						.rotateDout11_o(rotateDout11_rf1),
						.rotateDout12_o(rotateDout12_rf1),
						.rotateDout13_o(rotateDout13_rf1),
						.rotateDout14_o(rotateDout14_rf1),
						.rotateDout15_o(rotateDout15_rf1),
						.rotateDout16_o(rotateDout16_rf1),
						.rotateDout17_o(rotateDout17_rf1),
						.rotateDout18_o(rotateDout18_rf1),
						.rotateDout19_o(rotateDout19_rf1),
						.rotateDout20_o(rotateDout20_rf1),
						.rotateDout21_o(rotateDout21_rf1),
						.rotateDout22_o(rotateDout22_rf1),
						.rotateDout23_o(rotateDout23_rf1),
						.rotateDout24_o(rotateDout24_rf1),
						.rotateDout25_o(rotateDout25_rf1),
						.rotateDout26_o(rotateDout26_rf1),
						.rotateDout27_o(rotateDout27_rf1),
						.rotateDout28_o(rotateDout28_rf1),
						.rotateDout29_o(rotateDout29_rf1),
						.rotateDout30_o(rotateDout30_rf1),
						.rotateDout31_o(rotateDout31_rf1)
				);
				
	always @(*) begin
		case(activeFile)
			0: begin
				fuSM_o = fuSM_rf0;
				fuWarp_o = fuWarp_rf0;
				fuPacketValid_o = fuPacketValid_rf0;
				fuPacket_o = fuPacket_rf0;
				
				fuMask_o = fuMask_rf0;
						
				fuPacketLane0_o = fuPacketLane0_rf0;
				fuPacketLane1_o = fuPacketLane1_rf0;
				fuPacketLane2_o = fuPacketLane2_rf0;
				fuPacketLane3_o = fuPacketLane3_rf0;		
				fuPacketLane4_o = fuPacketLane4_rf0;
				fuPacketLane5_o = fuPacketLane5_rf0;
				fuPacketLane6_o = fuPacketLane6_rf0;
				fuPacketLane7_o = fuPacketLane7_rf0;
				fuPacketLane8_o = fuPacketLane8_rf0;
				fuPacketLane9_o = fuPacketLane9_rf0;
				fuPacketLane10_o = fuPacketLane10_rf0;
				fuPacketLane11_o = fuPacketLane11_rf0;
				fuPacketLane12_o = fuPacketLane12_rf0;
				fuPacketLane13_o = fuPacketLane13_rf0;		
				fuPacketLane14_o = fuPacketLane14_rf0;
				fuPacketLane15_o = fuPacketLane15_rf0;
				fuPacketLane16_o = fuPacketLane16_rf0;
				fuPacketLane17_o = fuPacketLane17_rf0;
				fuPacketLane18_o = fuPacketLane18_rf0;
				fuPacketLane19_o = fuPacketLane19_rf0;
				fuPacketLane20_o = fuPacketLane20_rf0;
				fuPacketLane21_o = fuPacketLane21_rf0;
				fuPacketLane22_o = fuPacketLane22_rf0;
				fuPacketLane23_o = fuPacketLane23_rf0;		
				fuPacketLane24_o = fuPacketLane24_rf0;
				fuPacketLane25_o = fuPacketLane25_rf0;
				fuPacketLane26_o = fuPacketLane26_rf0;
				fuPacketLane27_o = fuPacketLane27_rf0;
				fuPacketLane28_o = fuPacketLane28_rf0;
				fuPacketLane29_o = fuPacketLane29_rf0;
				fuPacketLane30_o = fuPacketLane30_rf0;
				fuPacketLane31_o = fuPacketLane31_rf0;
				
				branch_o = branch_rf0;
				predMask_o = predMask_rf0;
				branchTarget_o = branchTarget_rf0;
				branchReconv_o = branchReconv_rf0;
				branchPC_o = branchPC_rf0;
				
				//
				oc2memBundle_o = oc2memBundle_rf0;
			end
			
			1: begin
				fuSM_o = fuSM_rf1;
				fuWarp_o = fuWarp_rf1;
				fuPacketValid_o = fuPacketValid_rf1;
				fuPacket_o = fuPacket_rf1;
				
				fuMask_o = fuMask_rf1;
						
				fuPacketLane0_o = fuPacketLane0_rf1;
				fuPacketLane1_o = fuPacketLane1_rf1;
				fuPacketLane2_o = fuPacketLane2_rf1;
				fuPacketLane3_o = fuPacketLane3_rf1;		
				fuPacketLane4_o = fuPacketLane4_rf1;
				fuPacketLane5_o = fuPacketLane5_rf1;
				fuPacketLane6_o = fuPacketLane6_rf1;
				fuPacketLane7_o = fuPacketLane7_rf1;
				fuPacketLane8_o = fuPacketLane8_rf1;
				fuPacketLane9_o = fuPacketLane9_rf1;
				fuPacketLane10_o = fuPacketLane10_rf1;
				fuPacketLane11_o = fuPacketLane11_rf1;
				fuPacketLane12_o = fuPacketLane12_rf1;
				fuPacketLane13_o = fuPacketLane13_rf1;		
				fuPacketLane14_o = fuPacketLane14_rf1;
				fuPacketLane15_o = fuPacketLane15_rf1;
				fuPacketLane16_o = fuPacketLane16_rf1;
				fuPacketLane17_o = fuPacketLane17_rf1;
				fuPacketLane18_o = fuPacketLane18_rf1;
				fuPacketLane19_o = fuPacketLane19_rf1;
				fuPacketLane20_o = fuPacketLane20_rf1;
				fuPacketLane21_o = fuPacketLane21_rf1;
				fuPacketLane22_o = fuPacketLane22_rf1;
				fuPacketLane23_o = fuPacketLane23_rf1;		
				fuPacketLane24_o = fuPacketLane24_rf1;
				fuPacketLane25_o = fuPacketLane25_rf1;
				fuPacketLane26_o = fuPacketLane26_rf1;
				fuPacketLane27_o = fuPacketLane27_rf1;
				fuPacketLane28_o = fuPacketLane28_rf1;
				fuPacketLane29_o = fuPacketLane29_rf1;
				fuPacketLane30_o = fuPacketLane30_rf1;
				fuPacketLane31_o = fuPacketLane31_rf1;
				
				branch_o = branch_rf1;
				predMask_o = predMask_rf1;
				branchTarget_o = branchTarget_rf1;
				branchReconv_o = branchReconv_rf1;
				branchPC_o = branchPC_rf1;
				
				//
				oc2memBundle_o = oc2memBundle_rf1;
			end		
		endcase
	end
endmodule