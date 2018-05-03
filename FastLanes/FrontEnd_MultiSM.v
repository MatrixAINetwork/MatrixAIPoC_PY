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

module FrontEnd_MultiSM(
				input reset,
				input clk,		
				input clkX4,
				input [1:0]clkPhase,
				
				input [`SIZE_SM_LOG-1:0] sm_i,
				
				input stall_i,
				input freeze_i,
				
				/*system parameters*/
				input [`SIZE_PREDEFINED-1:0] nctaid_x_i,
				input [`SIZE_PREDEFINED-1:0] nctaid_y_i,
				input [`SIZE_PREDEFINED-1:0] nctaid_z_i,	
				input [`SIZE_PREDEFINED-1:0] ntid_x_i,
				input [`SIZE_PREDEFINED-1:0] ntid_y_i,
				input [`SIZE_PREDEFINED-1:0] ntid_z_i,
				input [`NUM_WARP_LOG-1:0] nctaSM_i,	//if 4 _i,then 4-1 = 2'b11
				input [`NUM_WARP-1:0] ctaEnMask_i,
				input [`SIZE_CORE_LOG-1:0] nlaneSM_i,	//if 8 _i,then 8-1 = 3'b111
				input [`SIZE_CORE-1:0] simdEnMask_i,
				/*~system parameters*/
				
				input [`NUM_WARP_LOG-1:0] fuWarp_i,
				
				/*interface with Cache*/
				input [`SIZE_INSTRUCTION-1:0] instruction0_i,
				input [`SIZE_INSTRUCTION-1:0] instruction1_i,
				/*~interface with Cache*/
				
				/*intu Commit*/
				input [`NUM_WARP_LOG-1:0] intuWarp_i,
				input intuPacketValid_i,
				input [`SIZE_CORE-1:0] intuMask_i,
				input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
								:0]intuPacketLane0_i,
				/*~intu Commit*/
				
				/*Load Commit*/
				input [`NUM_WARP_LOG-1:0] loadWarp_i,
				input loadPacketValid_i,
				input [`SIZE_CORE-1:0] loadMask_i,
				input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane0_i,
				/*~Load Commit*/
				
				/*OpCol to SIMT_Stack*/
				input [`NUM_WARP_LOG-1:0] issuedWarp_l1_i,
				input branch_i,
				input [`SIZE_CORE-1:0] predMask_i,
				input [`SIZE_PC-1:0] branchTarget_i,
				input [`SIZE_PC-1:0] branchReconv_i,
				input [`SIZE_PC-1:0] branchPC_i,
				/*~OpCol to SIMT_Stack*/
				
				
				input [`SIZE_SM_LOG-1:0] intuSM_i,
				
				
				/*Issue ouput*/
				output reg [`NUM_WARP_LOG-1:0] issuedWarp_o,
				output reg issuedPacketValid_o,
				output reg [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
							+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
							:0] issuedPacket_o,							
				output reg [`SIZE_CORE-1:0] issuedMask_o,
				
				output reg reconv_o,
				
				output reg issuedSync_o,
				output reg issuedExit_o,
				/*~Issue ouput*/
				
				/*Cache output reg*/
				output reg [`SIZE_PC-1:0] PC_o,
				output reg [`SIZE_PC-1:0] PCadd1_o,
				/*~Cache output reg*/
				
				output reg [`SIZE_PREDEFINED-1:0] ctaid_x_o,
				output reg [`SIZE_PREDEFINED-1:0] ctaid_y_o,
				output reg [`SIZE_PREDEFINED-1:0] ctaid_z_o,
				
				output reg pushInStack_stall_o,
				output reg kernelStall_o,
				output reg kernelDone_o
				
);
	/**sm0 output**/
		reg stall_sm0;
	
		/*Issue ouput*/
		wire [`NUM_WARP_LOG-1:0] issuedWarp_sm0;
		wire issuedPacketValid_sm0;
		wire [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
					+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
					:0] issuedPacket_sm0;							
		wire [`SIZE_CORE-1:0] issuedMask_sm0;
		
		wire reconv_sm0;
		
		wire issuedSync_sm0;
		wire issuedExit_sm0;
		/*~Issue ouput*/
		
		/*Cache wire*/
		wire [`SIZE_PC-1:0] PC_sm0;
		wire [`SIZE_PC-1:0] PCadd1_sm0;
		/*~Cache wire*/
		
		wire [`SIZE_PREDEFINED-1:0] ctaid_x_sm0;
		wire [`SIZE_PREDEFINED-1:0] ctaid_y_sm0;
		wire [`SIZE_PREDEFINED-1:0] ctaid_z_sm0;
		
		wire pushInStack_stall_sm0;
		wire kernelStall_sm0;
		wire kernelDone_sm0;
		
	/**sm1 output**/
		reg stall_sm1;
	
		/*Issue ouput*/
		wire [`NUM_WARP_LOG-1:0] issuedWarp_sm1;
		wire issuedPacketValid_sm1;
		wire [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
					+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
					:0] issuedPacket_sm1;							
		wire [`SIZE_CORE-1:0] issuedMask_sm1;
		
		wire reconv_sm1;
		
		wire issuedSync_sm1;
		wire issuedExit_sm1;
		/*~Issue ouput*/
		
		/*Cache wire*/
		wire [`SIZE_PC-1:0] PC_sm1;
		wire [`SIZE_PC-1:0] PCadd1_sm1;
		/*~Cache wire*/
		
		wire [`SIZE_PREDEFINED-1:0] ctaid_x_sm1;
		wire [`SIZE_PREDEFINED-1:0] ctaid_y_sm1;
		wire [`SIZE_PREDEFINED-1:0] ctaid_z_sm1;
		
		wire pushInStack_stall_sm1;
		wire kernelStall_sm1;
		wire kernelDone_sm1;
		
	/**sm2 output**/
		reg stall_sm2;
	
		/*Issue ouput*/
		wire [`NUM_WARP_LOG-1:0] issuedWarp_sm2;
		wire issuedPacketValid_sm2;
		wire [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
					+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
					:0] issuedPacket_sm2;							
		wire [`SIZE_CORE-1:0] issuedMask_sm2;
		
		wire reconv_sm2;
		
		wire issuedSync_sm2;
		wire issuedExit_sm2;
		/*~Issue ouput*/
		
		/*Cache wire*/
		wire [`SIZE_PC-1:0] PC_sm2;
		wire [`SIZE_PC-1:0] PCadd1_sm2;
		/*~Cache wire*/
		
		wire [`SIZE_PREDEFINED-1:0] ctaid_x_sm2;
		wire [`SIZE_PREDEFINED-1:0] ctaid_y_sm2;
		wire [`SIZE_PREDEFINED-1:0] ctaid_z_sm2;
		
		wire pushInStack_stall_sm2;
		wire kernelStall_sm2;
		wire kernelDone_sm2;
		
	/**sm3 output**/
		reg stall_sm3;
	
		/*Issue ouput*/
		wire [`NUM_WARP_LOG-1:0] issuedWarp_sm3;
		wire issuedPacketValid_sm3;
		wire [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
					+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
					:0] issuedPacket_sm3;							
		wire [`SIZE_CORE-1:0] issuedMask_sm3;
		
		wire reconv_sm3;
		
		wire issuedSync_sm3;
		wire issuedExit_sm3;
		/*~Issue ouput*/
		
		/*Cache wire*/
		wire [`SIZE_PC-1:0] PC_sm3;
		wire [`SIZE_PC-1:0] PCadd1_sm3;
		/*~Cache wire*/
		
		wire [`SIZE_PREDEFINED-1:0] ctaid_x_sm3;
		wire [`SIZE_PREDEFINED-1:0] ctaid_y_sm3;
		wire [`SIZE_PREDEFINED-1:0] ctaid_z_sm3;
		
		wire pushInStack_stall_sm3;
		wire kernelStall_sm3;
		wire kernelDone_sm3;
	
	FrontEnd #(0)
		frontEnd_sm0(
				.reset(reset),
				.clk(clk),		
				.clkX4(clkX4),
				.clkPhase(clkPhase),
				
				.stall_i(stall_sm0),
				.freeze_i(freeze),
				
				/*system parameters*/
				.nctaid_x_i(nctaid_x_i),
				.nctaid_y_i(nctaid_y_i),
				.nctaid_z_i(nctaid_z_i),	
				.ntid_x_i(ntid_x_i),
				.ntid_y_i(ntid_y_i),
				.ntid_z_i(ntid_z_i),
				.nctaSM_i(nctaSM_i),	//if 4 _i,then 4-1 = 2'b11
				.ctaEnMask_i(ctaEnMask_i),
				.nlaneSM_i(nlaneSM_i),	//if 8 _i,then 8-1 = 3'b111
				.simdEnMask_i(simdEnMask_i),
				/*~system parameters*/
				
				.fuWarp_i(fuWarp_i),
				
				/*interface with Cache*/
				.instruction0_i(instruction0_i),
				.instruction1_i(instruction1_i),
				/*~interface with Cache*/
				
				/*intu Commit*/
				.intuWarp_i(intuWarp_i),
				.intuPacketValid_i(intuPacketValid_i),
				.intuMask_i(intuMask_i),
				.intuPacketLane0_i(intuPacketLane0_i),
				/*~intu Commit*/
				
				/*Load Commit*/
				.loadWarp_i(loadWarp_i),
				.loadPacketValid_i(loadPacketValid_i),
				.loadMask_i(loadMask_i),
				.loadPacketLane0_i(loadPacketLane0_i),
				/*~Load Commit*/
				
				/*OpCol to SIMT_Stack*/
				.issuedWarp_l1_i(issuedWarp_l1_i),
				.branch_i(branch_i),
				.predMask_i(predMask_i),
				.branchTarget_i(branchTarget_i),
				.branchReconv_i(branchReconv_i),
				.branchPC_i(branchPC_i),
				/*~OpCol to SIMT_Stack*/
				
				
				.intuSM_i(intuSM_i),
				
				
				/*Issue ouput*/
				.issuedWarp_o(issuedWarp_sm0),
				.issuedPacketValid_o(issuedPacketValid_sm0),
				.issuedPacket_o(issuedPacket_sm0),							
				.issuedMask_o(issuedMask_sm0),
				
				.reconv_o(reconv_sm0),
				
				.issuedSync_o(issuedSync_sm0),
				.issuedExit_o(issuedExit_sm0),
				/*~Issue ouput*/
				
				/*Cache output*/
				.PC_o(PC_sm0),
				.PCadd1_o(PCadd1_sm0),
				/*~Cache output*/
				
				.ctaid_x_o(ctaid_x_sm0),
				.ctaid_y_o(ctaid_y_sm0),
				.ctaid_z_o(ctaid_z_sm0),				
				
				.pushInStack_stall_o(pushInStack_stall_sm0),
				.kernelStall_o(kernelStall_sm0),
				.kernelDone_o(kernelDone_sm0)
				
		);
	
	FrontEnd #(1)
		frontEnd_sm1(
				.reset(reset),
				.clk(clk),		
				.clkX4(clkX4),
				.clkPhase(clkPhase),
				
				.stall_i(stall_sm1),
				.freeze_i(freeze),
				
				/*system parameters*/
				.nctaid_x_i(nctaid_x_i),
				.nctaid_y_i(nctaid_y_i),
				.nctaid_z_i(nctaid_z_i),	
				.ntid_x_i(ntid_x_i),
				.ntid_y_i(ntid_y_i),
				.ntid_z_i(ntid_z_i),
				.nctaSM_i(nctaSM_i),	//if 4 _i,then 4-1 = 2'b11
				.ctaEnMask_i(ctaEnMask_i),
				.nlaneSM_i(nlaneSM_i),	//if 8 _i,then 8-1 = 3'b111
				.simdEnMask_i(simdEnMask_i),
				/*~system parameters*/
				
				.fuWarp_i(fuWarp_i),
				
				/*interface with Cache*/
				.instruction0_i(instruction0_i),
				.instruction1_i(instruction1_i),
				/*~interface with Cache*/
				
				/*intu Commit*/
				.intuWarp_i(intuWarp_i),
				.intuPacketValid_i(intuPacketValid_i),
				.intuMask_i(intuMask_i),
				.intuPacketLane0_i(intuPacketLane0_i),
				/*~intu Commit*/
				
				/*Load Commit*/
				.loadWarp_i(loadWarp_i),
				.loadPacketValid_i(loadPacketValid_i),
				.loadMask_i(loadMask_i),
				.loadPacketLane0_i(loadPacketLane0_i),
				/*~Load Commit*/
				
				/*OpCol to SIMT_Stack*/
				.issuedWarp_l1_i(issuedWarp_l1_i),
				.branch_i(branch_i),
				.predMask_i(predMask_i),
				.branchTarget_i(branchTarget_i),
				.branchReconv_i(branchReconv_i),
				.branchPC_i(branchPC_i),
				/*~OpCol to SIMT_Stack*/
				
				
				.intuSM_i(intuSM_i),
				
				
				/*Issue ouput*/
				.issuedWarp_o(issuedWarp_sm1),
				.issuedPacketValid_o(issuedPacketValid_sm1),
				.issuedPacket_o(issuedPacket_sm1),							
				.issuedMask_o(issuedMask_sm1),
				
				.reconv_o(reconv_sm1),
				
				.issuedSync_o(issuedSync_sm1),
				.issuedExit_o(issuedExit_sm1),
				/*~Issue ouput*/
				
				/*Cache output*/
				.PC_o(PC_sm1),
				.PCadd1_o(PCadd1_sm1),
				/*~Cache output*/
				
				.ctaid_x_o(ctaid_x_sm1),
				.ctaid_y_o(ctaid_y_sm1),
				.ctaid_z_o(ctaid_z_sm1),				
				
				.pushInStack_stall_o(pushInStack_stall_sm1),
				.kernelStall_o(kernelStall_sm1),
				.kernelDone_o(kernelDone_sm1)
				
		);
	
	FrontEnd #(2)
		frontEnd_sm2(
				.reset(reset),
				.clk(clk),		
				.clkX4(clkX4),
				.clkPhase(clkPhase),
				
				.stall_i(stall_sm2),
				.freeze_i(freeze),
				
				/*system parameters*/
				.nctaid_x_i(nctaid_x_i),
				.nctaid_y_i(nctaid_y_i),
				.nctaid_z_i(nctaid_z_i),	
				.ntid_x_i(ntid_x_i),
				.ntid_y_i(ntid_y_i),
				.ntid_z_i(ntid_z_i),
				.nctaSM_i(nctaSM_i),	//if 4 _i,then 4-1 = 2'b11
				.ctaEnMask_i(ctaEnMask_i),
				.nlaneSM_i(nlaneSM_i),	//if 8 _i,then 8-1 = 3'b111
				.simdEnMask_i(simdEnMask_i),
				/*~system parameters*/
				
				.fuWarp_i(fuWarp_i),
				
				/*interface with Cache*/
				.instruction0_i(instruction0_i),
				.instruction1_i(instruction1_i),
				/*~interface with Cache*/
				
				/*intu Commit*/
				.intuWarp_i(intuWarp_i),
				.intuPacketValid_i(intuPacketValid_i),
				.intuMask_i(intuMask_i),
				.intuPacketLane0_i(intuPacketLane0_i),
				/*~intu Commit*/
				
				/*Load Commit*/
				.loadWarp_i(loadWarp_i),
				.loadPacketValid_i(loadPacketValid_i),
				.loadMask_i(loadMask_i),
				.loadPacketLane0_i(loadPacketLane0_i),
				/*~Load Commit*/
				
				/*OpCol to SIMT_Stack*/
				.issuedWarp_l1_i(issuedWarp_l1_i),
				.branch_i(branch_i),
				.predMask_i(predMask_i),
				.branchTarget_i(branchTarget_i),
				.branchReconv_i(branchReconv_i),
				.branchPC_i(branchPC_i),
				/*~OpCol to SIMT_Stack*/
				
				
				.intuSM_i(intuSM_i),
				
				
				/*Issue ouput*/
				.issuedWarp_o(issuedWarp_sm2),
				.issuedPacketValid_o(issuedPacketValid_sm2),
				.issuedPacket_o(issuedPacket_sm2),							
				.issuedMask_o(issuedMask_sm2),
				
				.reconv_o(reconv_sm2),
				
				.issuedSync_o(issuedSync_sm2),
				.issuedExit_o(issuedExit_sm2),
				/*~Issue ouput*/
				
				/*Cache output*/
				.PC_o(PC_sm2),
				.PCadd1_o(PCadd1_sm2),
				/*~Cache output*/
				
				.ctaid_x_o(ctaid_x_sm2),
				.ctaid_y_o(ctaid_y_sm2),
				.ctaid_z_o(ctaid_z_sm2),				
				
				.pushInStack_stall_o(pushInStack_stall_sm2),
				.kernelStall_o(kernelStall_sm2),
				.kernelDone_o(kernelDone_sm2)
				
		);
	
	FrontEnd #(3)
		frontEnd_sm3(
				.reset(reset),
				.clk(clk),		
				.clkX4(clkX4),
				.clkPhase(clkPhase),
				
				.stall_i(stall_sm3),
				.freeze_i(freeze),
				
				/*system parameters*/
				.nctaid_x_i(nctaid_x_i),
				.nctaid_y_i(nctaid_y_i),
				.nctaid_z_i(nctaid_z_i),	
				.ntid_x_i(ntid_x_i),
				.ntid_y_i(ntid_y_i),
				.ntid_z_i(ntid_z_i),
				.nctaSM_i(nctaSM_i),	//if 4 _i,then 4-1 = 2'b11
				.ctaEnMask_i(ctaEnMask_i),
				.nlaneSM_i(nlaneSM_i),	//if 8 _i,then 8-1 = 3'b111
				.simdEnMask_i(simdEnMask_i),
				/*~system parameters*/
				
				.fuWarp_i(fuWarp_i),
				
				/*interface with Cache*/
				.instruction0_i(instruction0_i),
				.instruction1_i(instruction1_i),
				/*~interface with Cache*/
				
				/*intu Commit*/
				.intuWarp_i(intuWarp_i),
				.intuPacketValid_i(intuPacketValid_i),
				.intuMask_i(intuMask_i),
				.intuPacketLane0_i(intuPacketLane0_i),
				/*~intu Commit*/
				
				/*Load Commit*/
				.loadWarp_i(loadWarp_i),
				.loadPacketValid_i(loadPacketValid_i),
				.loadMask_i(loadMask_i),
				.loadPacketLane0_i(loadPacketLane0_i),
				/*~Load Commit*/
				
				/*OpCol to SIMT_Stack*/
				.issuedWarp_l1_i(issuedWarp_l1_i),
				.branch_i(branch_i),
				.predMask_i(predMask_i),
				.branchTarget_i(branchTarget_i),
				.branchReconv_i(branchReconv_i),
				.branchPC_i(branchPC_i),
				/*~OpCol to SIMT_Stack*/
				
				
				.intuSM_i(intuSM_i),
				
				
				
				/*Issue ouput*/
				.issuedWarp_o(issuedWarp_sm3),
				.issuedPacketValid_o(issuedPacketValid_sm3),
				.issuedPacket_o(issuedPacket_sm3),							
				.issuedMask_o(issuedMask_sm3),
				
				.reconv_o(reconv_sm3),
				
				.issuedSync_o(issuedSync_sm3),
				.issuedExit_o(issuedExit_sm3),
				/*~Issue ouput*/
				
				/*Cache output*/
				.PC_o(PC_sm3),
				.PCadd1_o(PCadd1_sm3),
				/*~Cache output*/
				
				.ctaid_x_o(ctaid_x_sm3),
				.ctaid_y_o(ctaid_y_sm3),
				.ctaid_z_o(ctaid_z_sm3),				
				
				.pushInStack_stall_o(pushInStack_stall_sm3),
				.kernelStall_o(kernelStall_sm3),
				.kernelDone_o(kernelDone_sm3)
				
		);
		
	always @(*) begin
		case(sm_i)
			0: begin
				stall_sm0 = stall_i;
				stall_sm1 = 1'b1;
				stall_sm2 = 1'b1;
				stall_sm3 = 1'b1;
			end
			
			1: begin
				stall_sm0 = 1'b1;
				stall_sm1 = stall_i;
				stall_sm2 = 1'b1;
				stall_sm3 = 1'b1;
			end
			
			2: begin
				stall_sm0 = 1'b1;
				stall_sm1 = 1'b1;
				stall_sm2 = stall_i;
				stall_sm3 = 1'b1;
			end
			
			3: begin
				stall_sm0 = 1'b1;
				stall_sm1 = 1'b1;
				stall_sm2 = 1'b1;
				stall_sm3 = stall_i;
			end
		endcase	
	end
		
		
		
	always @(*) begin
		case(sm_i)
			0: begin	
				/*Issue ouput*/
				 issuedWarp_o = issuedWarp_sm0;
				 issuedPacketValid_o = issuedPacketValid_sm0;
				 issuedPacket_o = issuedPacket_sm0;							
				 issuedMask_o = issuedMask_sm0;
				
				 reconv_o = reconv_sm0;
				
				 issuedSync_o = issuedSync_sm0;
				 issuedExit_o = issuedExit_sm0;
				/*~Issue ouput*/
				
				/*Cache */
				 PC_o = PC_sm0;
				 PCadd1_o = PCadd1_sm0;
				/*~Cache */
				
				 ctaid_x_o = ctaid_x_sm0;
				 ctaid_y_o = ctaid_y_sm0;
				 ctaid_z_o = ctaid_z_sm0;
				
				 pushInStack_stall_o = pushInStack_stall_sm0;
				 kernelStall_o = kernelStall_sm0;
				 kernelDone_o = kernelDone_sm0;
			end
			
			1: begin	
				/*Issue ouput*/
				 issuedWarp_o = issuedWarp_sm1;
				 issuedPacketValid_o = issuedPacketValid_sm1;
				 issuedPacket_o = issuedPacket_sm1;							
				 issuedMask_o = issuedMask_sm1;
				
				 reconv_o = reconv_sm1;
				
				 issuedSync_o = issuedSync_sm1;
				 issuedExit_o = issuedExit_sm1;
				/*~Issue ouput*/
				
				/*Cache */
				 PC_o = PC_sm1;
				 PCadd1_o = PCadd1_sm1;
				/*~Cache */
				
				 ctaid_x_o = ctaid_x_sm1;
				 ctaid_y_o = ctaid_y_sm1;
				 ctaid_z_o = ctaid_z_sm1;
				
				 pushInStack_stall_o = pushInStack_stall_sm1;
				 kernelStall_o = kernelStall_sm1;
				 kernelDone_o = kernelDone_sm1;
			end
			
			2: begin	
				/*Issue ouput*/
				 issuedWarp_o = issuedWarp_sm2;
				 issuedPacketValid_o = issuedPacketValid_sm2;
				 issuedPacket_o = issuedPacket_sm2;							
				 issuedMask_o = issuedMask_sm2;
				
				 reconv_o = reconv_sm2;
				
				 issuedSync_o = issuedSync_sm2;
				 issuedExit_o = issuedExit_sm2;
				/*~Issue ouput*/
				
				/*Cache */
				 PC_o = PC_sm2;
				 PCadd1_o = PCadd1_sm2;
				/*~Cache */
				
				 ctaid_x_o = ctaid_x_sm2;
				 ctaid_y_o = ctaid_y_sm2;
				 ctaid_z_o = ctaid_z_sm2;
				
				 pushInStack_stall_o = pushInStack_stall_sm2;
				 kernelStall_o = kernelStall_sm2;
				 kernelDone_o = kernelDone_sm2;
			end
			
			3: begin	
				/*Issue ouput*/
				 issuedWarp_o = issuedWarp_sm3;
				 issuedPacketValid_o = issuedPacketValid_sm3;
				 issuedPacket_o = issuedPacket_sm3;							
				 issuedMask_o = issuedMask_sm3;
				
				 reconv_o = reconv_sm3;
				
				 issuedSync_o = issuedSync_sm3;
				 issuedExit_o = issuedExit_sm3;
				/*~Issue ouput*/
				
				/*Cache */
				 PC_o = PC_sm3;
				 PCadd1_o = PCadd1_sm3;
				/*~Cache */
				
				 ctaid_x_o = ctaid_x_sm3;
				 ctaid_y_o = ctaid_y_sm3;
				 ctaid_z_o = ctaid_z_sm3;
				
				 pushInStack_stall_o = pushInStack_stall_sm3;
				 kernelStall_o = kernelStall_sm3;
				 kernelDone_o = kernelDone_sm3;
			end
		endcase
	end

endmodule