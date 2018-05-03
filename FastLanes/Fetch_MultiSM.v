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

module Fetch_MultiSM(
		input reset,
		input clk,
		
		input [`SIZE_SM-1:0] SM_i, 
		
		input stall_i,
		
		input [`NUM_WARP-1:0] warpRunEnable_i,
		
		input ctaExit_i,
		input [`NUM_WARP_LOG-1:0] exitWarp_i,
		
		input reconv_i,
		input [`NUM_WARP_LOG-1:0] reconvWarp_i,
		input [`SIZE_PC-1:0] reconvPC_i,
		

		
		input [`NUM_WARP-1:0] warpValidVector_i,
		
		input selectedPacketValid_i,
		input [`NUM_WARP_LOG-1:0] selectedWarp_i,
		input [`NUM_ENTRY_LOG-1:0] selectedEntry_i,
		
		/*interface with Cache*/
		output [`SIZE_PC-1:0] PC_o,
		output [`SIZE_PC-1:0] PCadd1_o,
		input [`SIZE_INSTRUCTION-1:0] instruction0_i,
		input [`SIZE_INSTRUCTION-1:0] instruction1_i,
		/*~interface with Cache*/
		
		output [`NUM_WARP_LOG-1:0] instWarp_o,
		output instPacket0Valid_o,
		output [`SIZE_INSTRUCTION+`SIZE_PC-1:0] instPacket0_o,
		output instPacket1Valid_o,
		output [`SIZE_INSTRUCTION+`SIZE_PC-1:0] instPacket1_o,
		output [`NUM_WARP-1:0] warpRun_o
);
	
	wire [`SIZE_PC-1:0] PC_SM0;
	wire [`SIZE_PC-1:0] PCadd1_SM0;
	wire [`NUM_WARP_LOG-1:0] instWarp_SM0;
	wire instPacket0Valid_SM0;
	wire [`SIZE_INSTRUCTION+`SIZE_PC-1:0] instPacket0_SM0;
	wire instPacket1Valid_SM0;
	wire [`SIZE_INSTRUCTION+`SIZE_PC-1:0] instPacket1_SM0;
	wire [`NUM_WARP-1:0] warpRun_SM0;
	
	wire [`SIZE_PC-1:0] PC_SM1;
	wire [`SIZE_PC-1:0] PCadd1_SM1;
	wire [`NUM_WARP_LOG-1:0] instWarp_SM1;
	wire instPacket0Valid_SM1;
	wire [`SIZE_INSTRUCTION+`SIZE_PC-1:0] instPacket0_SM1;
	wire instPacket1Valid_SM1;
	wire [`SIZE_INSTRUCTION+`SIZE_PC-1:0] instPacket1_SM1;
	wire [`NUM_WARP-1:0] warpRun_SM1;
	
	wire [`SIZE_PC-1:0] PC_SM2;
	wire [`SIZE_PC-1:0] PCadd1_SM2;
	wire [`NUM_WARP_LOG-1:0] instWarp_SM2;
	wire instPacket0Valid_SM2;
	wire [`SIZE_INSTRUCTION+`SIZE_PC-1:0] instPacket0_SM2;
	wire instPacket1Valid_SM2;
	wire [`SIZE_INSTRUCTION+`SIZE_PC-1:0] instPacket1_SM2;
	wire [`NUM_WARP-1:0] warpRun_SM2;
	
	wire [`SIZE_PC-1:0] PC_SM3;
	wire [`SIZE_PC-1:0] PCadd1_SM3;
	wire [`NUM_WARP_LOG-1:0] instWarp_SM3;
	wire instPacket0Valid_SM3;
	wire [`SIZE_INSTRUCTION+`SIZE_PC-1:0] instPacket0_SM3;
	wire instPacket1Valid_SM3;
	wire [`SIZE_INSTRUCTION+`SIZE_PC-1:0] instPacket1_SM3;
	wire [`NUM_WARP-1:0] warpRun_SM3;
	
	Fetch #(0)
		fetch_SM0(
		.reset(reset),
		.clk(clk),
		
		.stall_i(stall_i),
		.SM_i(SM_i),
		
		.warpRunEnable_i(warpRunEnable_i),
		
		.ctaExit_i(ctaExit_i),
		.exitWarp_i(exitWarp_i),
		
		.reconv_i(reconv_i),
		.reconvWarp_i(reconvWarp_i),
		.reconvPC_i(reconvPC_i),
		
		.warpValidVector_i(warpValidVector_i),
		
		.selectedWarp_i(selectedWarp_i),
		.selectedEntry_i(selectedEntry_i),
		.selectedPacketValid_i(selectedPacketValid_i),
		
		/*interface with Cache*/
		.PC_o(PC_SM0),
		.PCadd1_o(PCadd1_SM0),
		.instruction0_i(instruction0_SM0),
		.instruction1_i(instruction1_SM0),
		/*~interface with Cache*/
		
		.instWarp_o(instWarp_SM0),
		.instPacket0Valid_o(instPacket0Valid_SM0),
		.instPacket0_o(instPacket0_SM0),
		.instPacket1Valid_o(instPacket1Valid_SM0),
		.instPacket1_o(instPacket1_SM0),
		
		.warpRun_o(warpRun_SM0)
	);
	
	Fetch #(1)
		fetch_SM0(
		.reset(reset),
		.clk(clk),
		
		.stall_i(stall_i),
		.SM_i(SM_i),
		
		.warpRunEnable_i(warpRunEnable_i),
		
		.ctaExit_i(ctaExit_i),
		.exitWarp_i(exitWarp_i),
		
		.reconv_i(reconv_i),
		.reconvWarp_i(reconvWarp_i),
		.reconvPC_i(reconvPC_i),
		
		.warpValidVector_i(warpValidVector_i),
		
		.selectedWarp_i(selectedWarp_i),
		.selectedEntry_i(selectedEntry_i),
		.selectedPacketValid_i(selectedPacketValid_i),
		
		/*interface with Cache*/
		.PC_o(PC_SM1),
		.PCadd1_o(PCadd1_SM1),
		.instruction0_i(instruction0_SM1),
		.instruction1_i(instruction1_SM1),
		/*~interface with Cache*/
		
		.instWarp_o(instWarp_SM1),
		.instPacket0Valid_o(instPacket0Valid_SM1),
		.instPacket0_o(instPacket0_SM1),
		.instPacket1Valid_o(instPacket1Valid_SM1),
		.instPacket1_o(instPacket1_SM1),
		
		.warpRun_o(warpRun_SM1)
	);
	
	Fetch #(2)
		fetch_SM0(
		.reset(reset),
		.clk(clk),
		
		.stall_i(stall_i),
		.SM_i(SM_i),
		
		.warpRunEnable_i(warpRunEnable_i),
		
		.ctaExit_i(ctaExit_i),
		.exitWarp_i(exitWarp_i),
		
		.reconv_i(reconv_i),
		.reconvWarp_i(reconvWarp_i),
		.reconvPC_i(reconvPC_i),
		
		.warpValidVector_i(warpValidVector_i),
		
		.selectedWarp_i(selectedWarp_i),
		.selectedEntry_i(selectedEntry_i),
		.selectedPacketValid_i(selectedPacketValid_i),
		
		/*interface with Cache*/
		.PC_o(PC),
		.PCadd1_o(PCadd1),
		.instruction0_i(instruction0),
		.instruction1_i(instruction1),
		/*~interface with Cache*/
		
		.instWarp_o(instWarp_SM2),
		.instPacket0Valid_o(instPacket0Valid_SM2),
		.instPacket0_o(instPacket0_SM2),
		.instPacket1Valid_o(instPacket1Valid_SM2),
		.instPacket1_o(instPacket1_SM2),
		
		.warpRun_o(warpRun_SM2)
	);
	
	Fetch #(3)
		fetch_SM0(
		.reset(reset),
		.clk(clk),
		
		.stall_i(stall_i),
		.SM_i(SM_i),
		
		.warpRunEnable_i(warpRunEnable_i),
		
		.ctaExit_i(ctaExit_i),
		.exitWarp_i(exitWarp_i),
		
		.reconv_i(reconv_i),
		.reconvWarp_i(reconvWarp_i),
		.reconvPC_i(reconvPC_i),
		
		.warpValidVector_i(warpValidVector_i),
		
		.selectedWarp_i(selectedWarp_i),
		.selectedEntry_i(selectedEntry_i),
		.selectedPacketValid_i(selectedPacketValid_i),
		
		/*interface with Cache*/
		.PC_o(PC_SM3),
		.PCadd1_o(PCadd1_SM3),
		.instruction0_i(instruction0_SM3),
		.instruction1_i(instruction1_SM3),
		/*~interface with Cache*/
		
		.instWarp_o(instWarp_SM3),
		.instPacket0Valid_o(instPacket0Valid_SM3),
		.instPacket0_o(instPacket0_SM3),
		.instPacket1Valid_o(instPacket1Valid_SM3),
		.instPacket1_o(instPacket1_SM3),
		
		.warpRun_o(warpRun_SM3)
	);
	
	//output
	always @(*) begin
		case(SM_i)
			0: begin
				PC_o = PC_SM0;
				PCadd1_o = PCadd1_SM0;
				instWarp_o = instWarp_SM0;
				instPacket0Valid_o = instPacket0Valid_SM0;
				instPacket0_o = instPacket0_SM0;
				instPacket1Valid_o = instPacket1Valid_SM0;
				instPacket1_o = instPacket1_SM0;
				warpRun_o = warpRun_SM0;
			end
			
			1: begin
				PC_o = PC_SM1;
				PCadd1_o = PCadd1_SM1;
				instWarp_o = instWarp_SM1;
				instPacket0Valid_o = instPacket0Valid_SM1;
				instPacket0_o = instPacket0_SM1;
				instPacket1Valid_o = instPacket1Valid_SM1;
				instPacket1_o = instPacket1_SM1;
				warpRun_o = warpRun_SM1;
			end
			
			2: begin
				PC_o = PC_SM2;
				PCadd1_o = PCadd1_SM2;
				instWarp_o = instWarp_SM2;
				instPacket0Valid_o = instPacket0Valid_SM2;
				instPacket0_o = instPacket0_SM2;
				instPacket1Valid_o = instPacket1Valid_SM2;
				instPacket1_o = instPacket1_SM2;
				warpRun_o = warpRun_SM2;
			end
			
			3: begin
				PC_o = PC_SM3;
				PCadd1_o = PCadd1_SM3;
				instWarp_o = instWarp_SM3;
				instPacket0Valid_o = instPacket0Valid_SM3;
				instPacket0_o = instPacket0_SM3;
				instPacket1Valid_o = instPacket1Valid_SM3;
				instPacket1_o = instPacket1_SM3;
				warpRun_o = warpRun_SM3;
			end
		
		endcase
	end
	

endmodule

