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

//???
//means that the ScoreBoard mechanic still remain dubious

module InstBuffer(
				input reset,
                input clk,
				
				input [`NUM_WARP_LOG-1:0] decodedWarp_i,
				input decodedPacket0Valid_i,
				input [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
							+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
							:0] decodedPacket0_i,
				input decodedPacket1Valid_i,
				input [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
							+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
							:0] decodedPacket1_i,
				
				input [`NUM_WARP-1:0] hazardVector0_i,
				input [`NUM_WARP-1:0] hazardVector1_i,
				
				input toSelectReady_i,
				
				input flush_i,
				input [`NUM_WARP_LOG-1:0] flushWarp_i,
				input stall_i,
				
				output [`NUM_WARP-1:0] warpValidVector_o,
				output [`NUM_WARP-1:0] instValidVector0_o,
				output [`NUM_WARP-1:0] instValidVector1_o,
				
				output [`NUM_WARP_LOG-1:0] toSelectWarp_o,
				output [`NUM_ENTRY_LOG-1:0] toSelectEntry_o,
				output toSelectPacketValid_o,
				output [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
							+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
							:0]toSelectPacket_o,
				
				output reg [`NUM_WARP_LOG-1:0] selectedWarp_o,
				output reg [`NUM_ENTRY_LOG-1:0] selectedEntry_o,
				output reg selectedPacketValid_o,
				output reg [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
							+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
							:0]selectedPacket_o
							
						);
							
	
	reg [`NUM_WARP-1:0] instValidVector0;
	reg [`NUM_WARP-1:0] instValidVector1;
	assign instValidVector0_o = instValidVector0;
	assign instValidVector1_o = instValidVector1;
	
	wire [`NUM_WARP-1:0] instReadyVector0;
	wire [`NUM_WARP-1:0] instReadyVector1;
	wire [`NUM_WARP-1:0] warpReadyVector;
	wire anyReady;
	wire find_a_Choice;
	assign instReadyVector0 = (~hazardVector0_i) & instValidVector0;
	assign instReadyVector1 = (~hazardVector1_i) & instValidVector1;
	assign warpReadyVector = instReadyVector0 | instReadyVector1;
	assign anyReady = |warpReadyVector;
	assign find_a_Choice = anyReady && toSelectReady_i;
	
	/*
	reg [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
		+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
		:0] packetBuffer0[`NUM_WARP-1:0];		
	reg [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
		+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
		:0] packetBuffer1[`NUM_WARP-1:0];
	*/
	
	reg [`NUM_WARP_LOG-1:0] selectedWarp;
	reg [`NUM_ENTRY_LOG-1:0]selectedEntry;
	reg selectedPacketValid;
	reg [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
		+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
		:0]selectedPacket;
	reg [`NUM_WARP_LOG-1:0] preWarp;
	
	wire [`NUM_ENTRY_LOG-1:0]selectedEntry_ARB;
	wire [`NUM_WARP_LOG-1:0] selectedWarp_ARB;
	
	
	assign toSelectWarp_o = selectedWarp;
	assign toSelectEntry_o = selectedEntry;
	assign toSelectPacketValid_o = selectedPacketValid;
	assign toSelectPacket_o = selectedPacket;
	
	
	wire flush_selected;
	wire flush_decoded;
	assign flush_selected = (flush_i) && (flushWarp_i == selectedWarp_ARB);
	assign flush_decoded = (flush_i) && (flushWarp_i == decodedWarp_i);
	
	
	InstBufferArbiter instBufferArbiter(
					.preWarp_i(preWarp),
					.ReadyVector0_i(instReadyVector0),
					.ReadyVector1_i(instReadyVector1),
					.grantWarp_o(selectedWarp_ARB),
					.grantEntry_o(selectedEntry_ARB)
				);
							
	
				
	/* select result
	*/
	 assign warpValidVector_o = instValidVector0 | instValidVector1;
	 
	always @(posedge clk) begin
		if (reset) begin
			  instValidVector0 <= 0;	//Not Configurable yet!
			  instValidVector1 <= 0;
			  preWarp <= `PREWARP_START;
			  
			  selectedWarp_o <= 0;
			  selectedEntry_o <= 0;
			  selectedPacketValid_o <= 0;
			  selectedPacket_o <= 0;
			  
		end
		else begin
		
			if(~stall_i) begin
						/*flush operation
						*/
						if(flush_i) begin
							instValidVector0[flushWarp_i] <= 1'b0;
							instValidVector1[flushWarp_i] <= 1'b0;
						end
				
						
						/*To set the valid vector
						*/
						if(flush_decoded) begin							
						end
						else begin
							if(decodedPacket0Valid_i) begin
								instValidVector0[decodedWarp_i] <= 1'b1;
								//packetBuffer0[decodedWarp_i] <= decodedPacket0_i;
							end
							if(decodedPacket1Valid_i) begin
								instValidVector1[decodedWarp_i] <= 1'b1;
								//packetBuffer1[decodedWarp_i] <= decodedPacket1_i;
							end
						end

				
						/*select and unset Valid bit
						*/
						if(flush_selected) begin		
							selectedWarp_o <= 0;
							selectedEntry_o <= 0;
							selectedPacketValid_o <= 0;
							selectedPacket_o <= 0;
						end		
						else begin
							selectedWarp_o <= selectedWarp;
							if(find_a_Choice) begin
								preWarp <= selectedWarp;
							end
							else begin
								preWarp <= preWarp;
							end
							selectedEntry_o <= selectedEntry;
							selectedPacketValid_o <= selectedPacketValid;
							selectedPacket_o <= selectedPacket;
							
							
							if(find_a_Choice) begin
								case(selectedEntry_ARB)
									1'b0: begin
										instValidVector0[selectedWarp_ARB] <= 1'b0;
									end
									
									1'b1: begin
										instValidVector1[selectedWarp_ARB] <= 1'b0;
									end						
								endcase	
							end
						end

				
			end//stall_i	
			
		end				
	end
	
	
	
	wire [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
		+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
		:0] packetBuffer0_ARB;
	wire [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
		+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
		:0] packetBuffer1_ARB;
		
	//assign packetBuffer0_ARB = packetBuffer0[selectedWarp_ARB];
	//assign packetBuffer1_ARB = packetBuffer1[selectedWarp_ARB];
	
	always @(*) begin
	  
		selectedEntry = selectedEntry_ARB;
		
		case(selectedEntry_ARB)
			1'b0: begin
				selectedPacket = packetBuffer0_ARB;
			end
			
			1'b1: begin
				selectedPacket = packetBuffer1_ARB;
			end
		endcase
	  
	  
	  selectedWarp = selectedWarp_ARB;	
		if(find_a_Choice) begin						
			selectedPacketValid = 1'b1;	
		end		
		else begin
			//selectedWarp = preWarp;
			selectedPacketValid = 1'b0;
		end
	end
	 
	
	/*
	Module: Distributed RAM (Dual Port RAM)
	Name: IPCore_DisRam_PackeBuffer
	Depth: 4
	Data Width: 182
	Coe: \NA
	*/
	
	IPCore_DualPort_DisRam	#(`NUM_WARP, `NUM_WARP_LOG, `LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC)
	//IPCore_DisRAM_PacketBuffer
		packetBuffer0(
		  .a(decodedWarp_i), // input [1 : 0] 		addr0
		  .d(decodedPacket0_i), // input [182 : 0] 		din0
		  .dpra(selectedWarp_ARB), // input [1 : 0] 	addr1
		  .clk(clk), // input clk	
		  .we(decodedPacket0Valid_i && ~flush_decoded && ~stall_i), // input we		
		  //.spo(), // output [182 : 0]	dout0 
		  .dpo(packetBuffer0_ARB) // output [1 : 0] 	dout1
		);
		
	IPCore_DualPort_DisRam	#(`NUM_WARP, `NUM_WARP_LOG, `LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC)
	//IPCore_DisRAM_PacketBuffer
		packetBuffer1(
		  .a(decodedWarp_i), // input [8 : 0] 		addr0
		  .d(decodedPacket1_i), // input [63 : 0] 		din0
		  .dpra(selectedWarp_ARB), // input [8 : 0] 	addr1
		  .clk(clk), // input clk	
		  .we(decodedPacket1Valid_i && ~flush_decoded && ~stall_i), // input we		
		  //.spo(), // output [63 : 0]	dout0 
		  .dpo(packetBuffer1_ARB) // output [63 : 0] 	dout1
		);
	
endmodule
