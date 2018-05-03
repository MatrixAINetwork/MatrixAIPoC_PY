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

module OCUnit(
				input reset,
				input clk,
				input clkX4,
				input [1:0]clkPhase,
				
				input stall_i,
				
				input instSRValid_i,
				input [`SIZE_PREDEFINED*12-1:0] predefinedPacketLane_i,
				
				input [`NUM_WARP_LOG-1:0] issuedWarp_i,
				input issuedPacketValid_i,
				input [`SIZE_REGFILE*3+`SIZE_RP-1:0] readPacket_i,
				
				input [`NUM_WARP_LOG-1:0] intuWarp_i,
				input intuPacketLaneValid_i,
				input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
						:0]intuPacketLane_i,
				
				input [`NUM_WARP_LOG-1:0] loadWarp_i,
				input loadPacketLaneValid_i,					
				input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane_i,
				
				output pred_o,
				output [3*`SIZE_DATA-1:0] fuPacketLane_o,
				
				input rotate_i,
				input rotateValid_i,
				input rotateWE_i,
				input [`REGFILE_BR_INDEX-1:0] rotateRegAddr_i,
				input [`SIZE_DATA-1:0] rotateDin_i,
				output [`SIZE_DATA-1:0] rotateDout_o
				);
	
	//predefined registers
	wire [`SIZE_PREDEFINED-1:0] tid_x;
	wire [`SIZE_PREDEFINED-1:0] tid_y;
	wire [`SIZE_PREDEFINED-1:0] tid_z;
	wire [`SIZE_PREDEFINED-1:0] ntid_x;
	wire [`SIZE_PREDEFINED-1:0] ntid_y;
	wire [`SIZE_PREDEFINED-1:0] ntid_z;
	wire [`SIZE_PREDEFINED-1:0] ctaid_x;
	wire [`SIZE_PREDEFINED-1:0] ctaid_y;
	wire [`SIZE_PREDEFINED-1:0] ctaid_z;
	wire [`SIZE_PREDEFINED-1:0] nctaid_x;
	wire [`SIZE_PREDEFINED-1:0] nctaid_y;
	wire [`SIZE_PREDEFINED-1:0] nctaid_z;
	assign tid_x = predefinedPacketLane_i[`SIZE_PREDEFINED*12-1:`SIZE_PREDEFINED*11];
	assign tid_y = predefinedPacketLane_i[`SIZE_PREDEFINED*11-1:`SIZE_PREDEFINED*10];
	assign tid_z = predefinedPacketLane_i[`SIZE_PREDEFINED*10-1:`SIZE_PREDEFINED*9];
	assign ntid_x = predefinedPacketLane_i[`SIZE_PREDEFINED*9-1:`SIZE_PREDEFINED*8];
	assign ntid_y = predefinedPacketLane_i[`SIZE_PREDEFINED*8-1:`SIZE_PREDEFINED*7];
	assign ntid_z = predefinedPacketLane_i[`SIZE_PREDEFINED*7-1:`SIZE_PREDEFINED*6];
	assign ctaid_x = predefinedPacketLane_i[`SIZE_PREDEFINED*6-1:`SIZE_PREDEFINED*5];
	assign ctaid_y = predefinedPacketLane_i[`SIZE_PREDEFINED*5-1:`SIZE_PREDEFINED*4];
	assign ctaid_z = predefinedPacketLane_i[`SIZE_PREDEFINED*4-1:`SIZE_PREDEFINED*3];
	assign nctaid_x = predefinedPacketLane_i[`SIZE_PREDEFINED*3-1:`SIZE_PREDEFINED*2];
	assign nctaid_y = predefinedPacketLane_i[`SIZE_PREDEFINED*2-1:`SIZE_PREDEFINED];
	assign nctaid_z = predefinedPacketLane_i[`SIZE_PREDEFINED-1:0];
	//**
	
	
	
	
	//Row data read from SRAM and Special registers
	reg [`SIZE_DATA-1:0] predData;
	reg [`SIZE_DATA-1:0] instData1_BR;
	reg [`SIZE_DATA-1:0] instData2_BR;
	reg [`SIZE_DATA-1:0] instData3_BR;
	reg [`SIZE_DATA-1:0] instData1_SR;
	//Chosen data according Special or not
	reg [`SIZE_DATA-1:0] instData1;
	reg [`SIZE_DATA-1:0] instData2;
	reg [`SIZE_DATA-1:0] instData3;

	//output wires
	assign pred_o = predData[0];
	assign fuPacketLane_o = {
								instData3,
								instData2,
								instData1								
							};
	
	//decouple signals from "readPacket_i"
	wire [`SIZE_RP-1:0] instPredReg;
	wire [`SIZE_REGFILE-1:0] instSourceReg1;
	wire [`SIZE_REGFILE-1:0] instSourceReg2;
	wire [`SIZE_REGFILE-1:0] instSourceReg3;	
	assign instPredReg = readPacket_i[`SIZE_RP-1:0];	
	assign instSourceReg1 = readPacket_i[`SIZE_REGFILE+`SIZE_RP-1:`SIZE_RP];
	assign instSourceReg2 = readPacket_i[`SIZE_REGFILE*2+`SIZE_RP-1:`SIZE_REGFILE+`SIZE_RP];
	assign instSourceReg3 = readPacket_i[`SIZE_REGFILE*3+`SIZE_RP-1:`SIZE_REGFILE+`SIZE_RP*2];
	
	//addresses to be read
	wire [`NUM_WARP_LOG+`SIZE_RP-1:0] instPred;	
	wire [`REGFILE_BR_INDEX-1:0] instSource1;	
	wire [`REGFILE_BR_INDEX-1:0] instSource2;	
	wire [`REGFILE_BR_INDEX-1:0] instSource3;	
	assign instPred = {issuedWarp_i, instPredReg};	
	assign instSource1 = {issuedWarp_i, instSourceReg1[`SIZE_REGFILE_BR-1:0]};	
	assign instSource2 = {issuedWarp_i, instSourceReg2[`SIZE_REGFILE_BR-1:0]};	
	assign instSource3 = {issuedWarp_i, instSourceReg3[`SIZE_REGFILE_BR-1:0]};


	
	/*write back	(need to be modified when add FPU)
	*/
	//INTU write back
	wire [`SIZE_DATA-1:0] intuData;
	wire [`SIZE_REGFILE-1:0] intuDestReg;
	wire intuDestValid;
	wire [`SIZE_REGFILE_TYPES-1:0] intuFU;
	wire [`REGFILE_BR_INDEX-1:0] intuDest;
	wire intuWE;	
	assign intuData = intuPacketLane_i[`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1:`SIZE_REGFILE+1+`INST_TYPES_LOG];
	assign intuDestReg = intuPacketLane_i[`SIZE_REGFILE+1+`INST_TYPES_LOG-1:1+`INST_TYPES_LOG];
	assign intuDestValid = intuPacketLane_i[`INST_TYPES_LOG];
	assign intuFU = intuPacketLane_i[`INST_TYPES_LOG-1:0];	
	assign intuDest = {intuWarp_i, intuDestReg[`SIZE_REGFILE_BR-1:0]};	
	assign intuWE = intuPacketLaneValid_i && intuDestValid;
	
	//load write back
	wire [`SIZE_DATA-1:0] loadData;
	wire [`SIZE_REGFILE_BR-1:0] loadDestReg;
	wire [`REGFILE_BR_INDEX-1:0] loadDest;
	wire loadWE;	
	assign loadData = loadPacketLane_i[`SIZE_DATA+`SIZE_REGFILE_BR-1:`SIZE_REGFILE_BR];
	assign loadDestReg = loadPacketLane_i[`SIZE_REGFILE_BR-1:0];
	assign loadDest = {loadWarp_i, loadDestReg[`SIZE_REGFILE_BR-1:0]};	
	assign loadWE = loadPacketLaneValid_i;
	//**
	/*
	SRAM_4R3W #(`REGFILE_BR_DEPTH,`REGFILE_BR_INDEX,`SIZE_DATA)  
		bank_BR(
			.clk(clk),
			.reset(reset),
			
			.addr0_i(instPred),
			.addr1_i(instSource1),
			.addr2_i(instSource2),
			.addr3_i(instSource3),
			
			.addr0wr_i(intuDest),
			.we0_i(intuWE),
			.data0wr_i(intuData),
			
			.addr1wr_i(loadDest),
			.we1_i(loadWE),
			.data1wr_i(loadData),
			
			.addr2wr_i(),
			.we2_i(1'b0),
			.data2wr_i(),
			
			.data0_o(predData),
			.data1_o(instData1_BR),
			.data2_o(instData2_BR),
			.data3_o(instData3_BR)
			);
	*/
	
	reg [`REGFILE_BR_INDEX-1:0] addr_BR;
	reg [`REGFILE_BR_INDEX-1:0] addrWr_BR;
	reg WE_BR;
	reg [`SIZE_DATA-1:0] dataWr_BR;
	wire [`SIZE_DATA-1:0] data_BR;	
	
	always @(*) begin: ADDR_BR_BY_CLKPHASE
		case(clkPhase)
			2'b00:	begin	
				addr_BR <= instPred;
				
				addrWr_BR <= intuDest;
				WE_BR <= intuWE && (~stall_i);
				dataWr_BR <= intuData;
			end
			
			2'b01:	begin
				addr_BR <= instSource1;
				
				addrWr_BR <= 0;
				WE_BR <= 1'b0 && (~stall_i);
				dataWr_BR <= 0;
			end
			
			2'b10:	begin
				addr_BR <= instSource2;
				
				addrWr_BR <= loadDest;
				WE_BR <= loadWE && (~stall_i);
				dataWr_BR <= loadData;
			end
			
			2'b11:	begin
				addr_BR <= instSource3;
				
				addrWr_BR <= 0;
				WE_BR <= 1'b0 && (~stall_i);
				dataWr_BR <= 0;
			end			
		endcase
	end
	
	
	
	assign rotateDout_o = data_BR;
	
	reg [`REGFILE_BR_INDEX-1:0] addr_RT;
	reg [`REGFILE_BR_INDEX-1:0] addrWr_RT;
	reg WE_RT;
	reg [`SIZE_DATA-1:0] dataWr_RT;
	
	always @(*) begin: ADDR_RT
		case(rotate_i)
			1'b0:	begin	
				addr_RT <= addr_BR;				
				addrWr_RT <= addrWr_BR;
				WE_RT <= WE_BR;
				dataWr_RT <= dataWr_BR;
			end
			
			1'b1:	begin
				addr_RT <= rotateRegAddr_i;				
				addrWr_RT <= rotateRegAddr_i;
				WE_RT <= rotateWE_i && rotateValid_i;
				dataWr_RT <= rotateDin_i;
			end	
		endcase
	end
	
	always @(*) begin: DATA_BR_BY_CLKPHASE
		case(clkPhase)
			2'b00:	begin	
				predData = data_BR;
				instData1_BR = instData1_BR;
				instData2_BR = instData2_BR;
				instData3_BR = instData3_BR;
			end
			
			2'b01:	begin
				predData = predData;
				instData1_BR = data_BR;
				instData2_BR = instData2_BR;
				instData3_BR = instData3_BR;
			end
			
			2'b10:	begin
				predData = predData;
				instData1_BR = instData1_BR;
				instData2_BR = data_BR;
				instData3_BR = instData3_BR;
			end
			
			2'b11:	begin
				predData = predData;
				instData1_BR = instData1_BR;
				instData2_BR = instData2_BR;
				instData3_BR = data_BR;
			end			
		endcase
	end
	
	/*
	SRAM_1R1W #(`REGFILE_BR_DEPTH,`REGFILE_BR_INDEX,`SIZE_DATA)  
		bank_BR(
			.clk(clkX4),
			.reset(reset),
			
			.addr0_i(addr_RT),
			
			.addr0wr_i(addrWr_RT),
			.we0_i(WE_RT),
			.data0wr_i(dataWr_RT),
			
			.data0_o(data_BR)
			);
	*/

	/*
	Distributed RAM (Dual Port RAM)
	Depth: 128
	Data Width: 32
	Default Value: 0
	*/
	
   IPCore_DisRAM_OC2
		bank_BR(
		  .a(addrWr_RT), // input [6 : 0] 
		  .d(dataWr_RT), // input [31 : 0]
		  .dpra(addr_RT), // input [6 : 0] 
		  .clk(clkX4), // input clk
		  .we(WE_RT), // input we		
		  .spo(data_BR), // output [31 : 0] 
		  .dpo() // output [31 : 0] 
		); 
	
	
	
	
	
	
	
	
	
	
	
	/*
	3'b00000: void
	3'b00001: tid.x
	3'b00010: tid.y
	3'b00011: tid.z
	3'b00100: ntid.x
	3'b00101: ntid.y
	3'b00110: ntid.z
	3'b00111: ctaid.x
	3'b01000: ctaid.y
	3'b01001: ctaid.z
	3'b01010: nctaid.x
	3'b01011: nctaid.y
	3'b01100: nctaid.z
	*/	
	always @(*) begin: SPECIAL_REG
		case(instSourceReg1[`SIZE_REGFILE_SR-1:0])
			`SR_TID_X: begin
				instData1_SR = {16'b0, tid_x};
			end
			
			`SR_TID_Y: begin
				instData1_SR = {16'b0, tid_y};
			end
			
			`SR_TID_Z: begin
				instData1_SR = {16'b0, tid_z};
			end
			
			`SR_NTID_X: begin
				instData1_SR = {16'b0, ntid_x};
			end
			
			`SR_NTID_Y: begin
				instData1_SR = {16'b0, ntid_y};
			end
			
			`SR_NTID_Z: begin
				instData1_SR = {16'b0, ntid_z};
			end
			 
			`SR_CTAID_X: begin
				instData1_SR = {16'b0, ctaid_x};
			end
			
			`SR_CTAID_Y: begin
				instData1_SR = {16'b0, ctaid_y};
			end
			
			`SR_CTAID_Z: begin
				instData1_SR = {16'b0, ctaid_z};
			end
			
			`SR_NCTAID_X: begin
				instData1_SR = {16'b0, nctaid_x};
			end
			
			`SR_NCTAID_Y: begin
				instData1_SR = {16'b0, nctaid_y};
			end
			
			`SR_NCTAID_Z: begin
				instData1_SR = {16'b0, nctaid_z};
			end
			
			default: begin
			end
		endcase
	end	
	
	
	/*Stage selection
	*/	
	always @(*) begin: SPECIAL_REG_MUX
		if(instSRValid_i) begin
			instData1 = instData1_SR;
			instData2 = 0;
			instData3 = 0;
		end
		else begin
			instData1 = (instSourceReg1 == 0) ? 0:instData1_BR;
			instData2 = (instSourceReg2 == 0) ? 0:instData2_BR;
			instData3 = (instSourceReg3 == 0) ? 0:instData3_BR;
		end
	end		
	
endmodule
