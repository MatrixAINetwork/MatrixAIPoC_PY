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

module SIMTStack(	
				input clk,
				input reset,
				
				input stall_i,
				
				/*OpCol to SIMT_Stack*/
				input [`NUM_WARP_LOG-1:0] branchWarp_i,
				input branch_i,
				input [`SIZE_CORE-1:0] predMask_i,
				input [`SIZE_PC-1:0] pushTarget_i,
				input [`SIZE_PC-1:0] pushReconv_i,
				input [`SIZE_PC-1:0] pushPC_i,
				/*~OpCol to SIMT_Stack*/
			
				input reconv_i,
				input [`NUM_WARP_LOG-1:0] issuedWarp_i,
				
				output pushInStack_stall_o,
				output [`SIZE_PC-1:0] TopPC_o,
				output [`SIZE_PC-1:0] TopRPC_o,
				
				output reg [`SIZE_CORE-1:0] TopActiveMask_o
				);

	//final output
	reg [`SIZE_PC-1:0] TopPC_issuedWarp;
	reg [`SIZE_PC-1:0] TopRPC_issuedWarp;
	assign TopPC_o = TopPC_issuedWarp;	
	assign TopRPC_o = TopRPC_issuedWarp;
	
	//choose
	reg [`SIZE_CORE-1:0] ActiveMask_TOS_branch;
	reg [`SIZE_PC-1:0] RPC_TOS_branch;
	
	
	wire reconv;
	assign reconv = reconv_i;
	wire branch;
	assign branch = branch_i;
	reg preBranch;
	reg [`NUM_WARP_LOG-1:0] preBranchWarp;
	
	//2-step push
	reg  pushState;
	reg [`SIZE_CORE-1:0] prePushActiveMask0;
	reg [`SIZE_CORE-1:0] prePushActiveMask1;
	assign pushInStack_stall_o = pushState;
	
	reg pushTOS;
	reg pushTOSsub1;
	reg [2*`SIZE_PC+`SIZE_CORE-1:0] pushPacket_TOS;
	reg [2*`SIZE_PC+`SIZE_CORE-1:0] pushPacket_TOSsub1;
	wire [`SIZE_PC-1:0] pushNextPC;
	assign pushNextPC = pushPC_i + 1;
	
	
	
	
	
	
	
	
	

	wire [`SIZE_CORE-1:0] pushActiveMask0;
	wire [`SIZE_CORE-1:0] pushActiveMask1;
	assign pushActiveMask0 = (~predMask_i) & ActiveMask_TOS_branch;
	assign pushActiveMask1 = predMask_i & ActiveMask_TOS_branch;
	wire mask0_all0;
	wire mask1_all0;
	assign mask0_all0 = (pushActiveMask0 == 0);
	assign mask1_all0 = (pushActiveMask0 == 0);
	
	
	
	
	
  
  


	always @(posedge clk) begin: SIMT_STACK_FSM
		if(reset) begin
			pushState <= 1'b0;
		end
		else begin
			if(~stall_i) begin
				if(pushState == 1'b1) pushState <= 1'b0;
				else if(branch) pushState <= 1'b1;
				else pushState <= 1'b0;
			end
		end
	end
	
		
	
	always @(posedge clk) begin
		if(reset) begin
			prePushActiveMask0 <= 0;
			prePushActiveMask1 <= 0;
			
			preBranchWarp <= 0;
		end
		else begin
			if(~stall_i) begin
				if(~pushState) begin
					preBranch <= branch_i;
				
					prePushActiveMask0 <= pushActiveMask0;
					prePushActiveMask1 <= pushActiveMask1;
					
					preBranchWarp <= branchWarp_i;//???
				end
			end
		end	
	end
	
	
	
	//Push Enable and Push Packet
	always @(*) begin	
		case(pushState)
			1'b0: begin
				if(mask0_all0 && mask1_all0) begin
					pushTOS = 1'b0;
					pushTOSsub1 = 1'b0;
				end
				else begin
					pushTOS = branch;
					pushTOSsub1 = 1'b0;					
					pushPacket_TOS = {RPC_TOS_branch, pushReconv_i, ActiveMask_TOS_branch};
					//pushPacket_TOSsub1_warp0 = {pushReconv_i, pushTarget_i, prePushActiveMask1};//useless
				end
			end
			
			1'b1 : begin
			
				if(~(mask0_all0 && mask1_all0)) begin
					pushTOS = 1'b1;
					pushTOSsub1 = 1'b1;				
					pushPacket_TOS = {pushReconv_i, pushNextPC, prePushActiveMask0};
					pushPacket_TOSsub1 = {pushReconv_i, pushTarget_i, prePushActiveMask1};
				end
				else if(mask0_all0 && mask1_all0) begin
					pushTOS = 1'b0;
					pushTOSsub1 = 1'b0;				
					pushPacket_TOS = 0;
					pushPacket_TOSsub1 = 0;
				end			
				else if(mask0_all0) begin
					pushTOS = 1'b0;
					pushTOSsub1 = 1'b1;				
					pushPacket_TOS = 0;
					pushPacket_TOSsub1 = {pushReconv_i, pushTarget_i, prePushActiveMask1};
				end	
				else if(mask1_all0) begin
					pushTOS = 1'b0;
					pushTOSsub1 = 1'b1;				
					pushPacket_TOS = {pushReconv_i, pushNextPC, prePushActiveMask0};
					pushPacket_TOSsub1 = 0;
				end

			end			
		endcase
	end
	
	
	
	/*CONFIGURABLE*/
	
	//all the stack input, output
	wire [`SIZE_PC-1:0] RPC_TOS_warp0;
	wire [`SIZE_PC-1:0] PC_TOS_warp0;
	wire [`SIZE_CORE-1:0] ActiveMask_TOS_warp0;
	wire [`SIZE_PC-1:0] RPC_TOSsub1_warp0;
	wire [`SIZE_PC-1:0] PC_TOSsub1_warp0;
	wire [`SIZE_CORE-1:0] ActiveMask_TOSsub1_warp0;
	
	wire [`SIZE_PC-1:0] RPC_TOS_warp1;
	wire [`SIZE_PC-1:0] PC_TOS_warp1;
	wire [`SIZE_CORE-1:0] ActiveMask_TOS_warp1;
	wire [`SIZE_PC-1:0] RPC_TOSsub1_warp1;
	wire [`SIZE_PC-1:0] PC_TOSsub1_warp1;
	wire [`SIZE_CORE-1:0] ActiveMask_TOSsub1_warp1;
	
	wire [`SIZE_PC-1:0] RPC_TOS_warp2;
	wire [`SIZE_PC-1:0] PC_TOS_warp2;
	wire [`SIZE_CORE-1:0] ActiveMask_TOS_warp2;
	wire [`SIZE_PC-1:0] RPC_TOSsub1_warp2;
	wire [`SIZE_PC-1:0] PC_TOSsub1_warp2;
	wire [`SIZE_CORE-1:0] ActiveMask_TOSsub1_warp2;
	
	wire [`SIZE_PC-1:0] RPC_TOS_warp3;
	wire [`SIZE_PC-1:0] PC_TOS_warp3;
	wire [`SIZE_CORE-1:0] ActiveMask_TOS_warp3;
	wire [`SIZE_PC-1:0] RPC_TOSsub1_warp3;
	wire [`SIZE_PC-1:0] PC_TOSsub1_warp3;
	wire [`SIZE_CORE-1:0] ActiveMask_TOSsub1_warp3;
	
	PerWarpStack
		perWarpStack0(	
				.clk(clk),
				.reset(reset),
				
				.stall_i(stall_i),
				
				.branchWarp_i(branchWarp_i),
				.issuedWarp_i(issuedWarp_i),
				
				.preBranchWarp(preBranchWarp),
				.pushState(pushState), 				
				.pushTOS(pushTOS), 
				.pushTOSsub1(pushTOSsub1),
				.reconv(reconv),
				.branch(branch),
				.mask0_all0(mask0_all0),
				.mask1_all0(mask1_all0),
				.pushPacket_TOS(pushPacket_TOS),
				.pushPacket_TOSsub1(pushPacket_TOSsub1),
				
				.id(0),
				
				.RPC_TOS_warp(RPC_TOS_warp0),
				.PC_TOS_warp(PC_TOS_warp0),
				.ActiveMask_TOS_warp(ActiveMask_TOS_warp0),
				.RPC_TOSsub1_warp(RPC_TOSsub1_warp0),
				.PC_TOSsub1_warp(PC_TOSsub1_warp0),
				.ActiveMask_TOSsub1_warp(ActiveMask_TOSsub1_warp0)				
				);
	
	PerWarpStack
		perWarpStack1(	
				.clk(clk),
				.reset(reset),
				
				.stall_i(stall_i),
				
				.branchWarp_i(branchWarp_i),
				.issuedWarp_i(issuedWarp_i),
				
				.preBranchWarp(preBranchWarp),
				.pushState(pushState), 				
				.pushTOS(pushTOS), 
				.pushTOSsub1(pushTOSsub1),
				.reconv(reconv),
				.branch(branch),
				.mask0_all0(mask0_all0),
				.mask1_all0(mask1_all0),
				.pushPacket_TOS(pushPacket_TOS),
				.pushPacket_TOSsub1(pushPacket_TOSsub1),
				
				.id(1),
				
				.RPC_TOS_warp(RPC_TOS_warp1),
				.PC_TOS_warp(PC_TOS_warp1),
				.ActiveMask_TOS_warp(ActiveMask_TOS_warp1),
				.RPC_TOSsub1_warp(RPC_TOSsub1_warp1),
				.PC_TOSsub1_warp(PC_TOSsub1_warp1),
				.ActiveMask_TOSsub1_warp(ActiveMask_TOSsub1_warp1)				
				);
	
	PerWarpStack
		perWarpStack2(	
				.clk(clk),
				.reset(reset),
				
				.stall_i(stall_i),
				
				.branchWarp_i(branchWarp_i),
				.issuedWarp_i(issuedWarp_i),
				
				.preBranchWarp(preBranchWarp),
				.pushState(pushState), 				
				.pushTOS(pushTOS), 
				.pushTOSsub1(pushTOSsub1),
				.reconv(reconv),
				.branch(branch),
				.mask0_all0(mask0_all0),
				.mask1_all0(mask1_all0),
				.pushPacket_TOS(pushPacket_TOS),
				.pushPacket_TOSsub1(pushPacket_TOSsub1),
				
				.id(2),
				
				.RPC_TOS_warp(RPC_TOS_warp2),
				.PC_TOS_warp(PC_TOS_warp2),
				.ActiveMask_TOS_warp(ActiveMask_TOS_warp2),
				.RPC_TOSsub1_warp(RPC_TOSsub1_warp2),
				.PC_TOSsub1_warp(PC_TOSsub1_warp2),
				.ActiveMask_TOSsub1_warp(ActiveMask_TOSsub1_warp2)				
				);
	
	PerWarpStack
		perWarpStack3(	
				.clk(clk),
				.reset(reset),
				
				.stall_i(stall_i),
				
				.branchWarp_i(branchWarp_i),
				.issuedWarp_i(issuedWarp_i),
				
				.preBranchWarp(preBranchWarp),
				.pushState(pushState), 				
				.pushTOS(pushTOS), 
				.pushTOSsub1(pushTOSsub1),
				.reconv(reconv),
				.branch(branch),
				.mask0_all0(mask0_all0),
				.mask1_all0(mask1_all0),
				.pushPacket_TOS(pushPacket_TOS),
				.pushPacket_TOSsub1(pushPacket_TOSsub1),
				
				.id(3),
				
				.RPC_TOS_warp(RPC_TOS_warp3),
				.PC_TOS_warp(PC_TOS_warp3),
				.ActiveMask_TOS_warp(ActiveMask_TOS_warp3),
				.RPC_TOSsub1_warp(RPC_TOSsub1_warp3),
				.PC_TOSsub1_warp(PC_TOSsub1_warp3),
				.ActiveMask_TOSsub1_warp(ActiveMask_TOSsub1_warp3)				
				);	
	
	
		/* the top of the stack
	*/
	always @(*) begin
		case(issuedWarp_i)
			2'b00: begin
					TopRPC_issuedWarp = RPC_TOS_warp0;
					TopPC_issuedWarp = PC_TOSsub1_warp0;	//reconv beneath PC
					TopActiveMask_o = ActiveMask_TOS_warp0;
				end
			2'b01: begin
					TopRPC_issuedWarp = RPC_TOS_warp1;
					TopPC_issuedWarp = PC_TOSsub1_warp1;	//reconv beneath PC
					TopActiveMask_o = ActiveMask_TOS_warp1;
				end
			2'b10: begin
					TopRPC_issuedWarp = RPC_TOS_warp2;
					TopPC_issuedWarp = PC_TOSsub1_warp2;	//reconv beneath PC
					TopActiveMask_o = ActiveMask_TOS_warp2;
				end
			2'b11: begin
					TopRPC_issuedWarp = RPC_TOS_warp3;
					TopPC_issuedWarp = PC_TOSsub1_warp3;	//reconv beneath PC
					TopActiveMask_o = ActiveMask_TOS_warp3;
				end
		endcase
	end
				
	
	always @(*) begin
		case(branchWarp_i)
			2'b00: begin
					ActiveMask_TOS_branch = ActiveMask_TOS_warp0;
					RPC_TOS_branch = RPC_TOS_warp0;
				end
			2'b01: begin
					ActiveMask_TOS_branch = ActiveMask_TOS_warp1;
					RPC_TOS_branch = RPC_TOS_warp1;
				end
			2'b10: begin
					ActiveMask_TOS_branch = ActiveMask_TOS_warp2;
					RPC_TOS_branch = RPC_TOS_warp2;
				end
			2'b11: begin
					ActiveMask_TOS_branch = ActiveMask_TOS_warp3;
					RPC_TOS_branch = RPC_TOS_warp3;
				end
		endcase
	end
  
	
endmodule