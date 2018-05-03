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

module PerWarpStack(	
				input clk,
				input reset,
				
				input [`NUM_WARP_LOG-1:0] id,
				
				input stall_i,
				
				input [`NUM_WARP_LOG-1:0] branchWarp_i,
				input [`NUM_WARP_LOG-1:0] issuedWarp_i,
				
				input [`NUM_WARP_LOG-1:0] preBranchWarp,
				input pushState, 				
				input pushTOS, 
				input pushTOSsub1,
				input reconv,
				input branch,
				input mask0_all0,
				input mask1_all0,
				input [2*`SIZE_PC+`SIZE_CORE-1:0] pushPacket_TOS,
				input [2*`SIZE_PC+`SIZE_CORE-1:0] pushPacket_TOSsub1,
				
				output [`SIZE_PC-1:0] RPC_TOS_warp,
				output [`SIZE_PC-1:0] PC_TOS_warp,
				output [`SIZE_CORE-1:0] ActiveMask_TOS_warp,
				output [`SIZE_PC-1:0] RPC_TOSsub1_warp,
				output [`SIZE_PC-1:0] PC_TOSsub1_warp,
				output [`SIZE_CORE-1:0] ActiveMask_TOSsub1_warp				
				);
	
	
	reg [`SIMT_STACK_DEPTH_LOG-1:0] TOS_warp;
	reg [`SIMT_STACK_DEPTH_LOG-1:0] nextTOS_warp;
	wire [`SIMT_STACK_DEPTH_LOG-1:0] TOSadd1_warp;
	wire [`SIMT_STACK_DEPTH_LOG-1:0] TOSadd2_warp;
	wire [`SIMT_STACK_DEPTH_LOG-1:0] TOSsub1_warp;
	
	
	assign TOSadd1_warp = TOS_warp + 1;
	assign TOSadd2_warp = TOS_warp + 2;
	assign TOSsub1_warp = TOS_warp - 1;
	
	
	always @(*) begin
		if(reconv) begin
			nextTOS_warp = TOSsub1_warp;
		end
		else if(branch && ~pushState) begin
			if(~(mask0_all0 && mask1_all0)) begin
				nextTOS_warp = TOSadd2_warp;
			end
			else if(mask0_all0 && mask1_all0) begin
				nextTOS_warp = TOS_warp;
			end			
			else begin
				nextTOS_warp = TOSadd1_warp;
			end		
		end
		else begin
			nextTOS_warp = TOS_warp;
		end
	
	end
	
	
	/* Push and Pop Stack Operation
	*/
	always @(posedge clk) begin
		 if (reset) begin
			TOS_warp <= 0;		
		 end
	 
		 else begin
			if(~stall_i) begin
				/*Pop and Push
				*/
				if(reconv) begin
					if(issuedWarp_i == id) begin
						TOS_warp <= nextTOS_warp;
					end
				end
				
				if(branch && ~pushState) begin
					if(branchWarp_i == id) begin
						TOS_warp <= nextTOS_warp;
					end
				end
				
			end
		 end
	end
	
	
	
	wire pushTOS_warp;
	wire pushTOSsub1_warp;
	assign pushTOS_warp = pushTOS && ((~pushState && (branchWarp_i == id)) || (pushState && (preBranchWarp == id)));
	assign pushTOSsub1_warp = pushTOSsub1 && ((~pushState && (branchWarp_i == id)) || (pushState && (preBranchWarp == id)));
	
	/*
	Module: Block RAM (Naive/True Dual Port RAM)
	Name: IPCore_BloRam_SIMTStack
	Write Width: 96
	Write Depth: 64
	Coe: simtstack.coe
	*/
	  //Need to initialize
  //IPCore_BloRAM_TrueDualPort_SIMT_Stack #(`SIMT_STACK_DEPTH, `SIMT_STACK_DEPTH_LOG, (2*`SIZE_PC+`SIZE_CORE))
	IPCore_BloRAM_SIMTStack
	simt_stack_warp(
				  .clka(clk), // input clka
				  .wea(pushTOS_warp && (~stall_i)), // input [0 : 0] wea
				  .addra(TOS_warp), // input [5 : 0] addra
				  .dina( pushPacket_TOS ), // input [71 : 0] dina
				  .douta( {RPC_TOS_warp, PC_TOS_warp, ActiveMask_TOS_warp} ), // output [71 : 0] douta
				  .clkb(clk), // input clkb
				  .web(pushTOSsub1_warp && (~stall_i)), // input [0 : 0] web
				  .addrb(TOSsub1_warp), // input [5 : 0] addrb
				  .dinb( pushPacket_TOSsub1 ), // input [71 : 0] dinb
				  .doutb( {RPC_TOSsub1_warp, PC_TOSsub1_warp, ActiveMask_TOSsub1_warp} ) // output [71 : 0] doutb
				);
	
	
endmodule 