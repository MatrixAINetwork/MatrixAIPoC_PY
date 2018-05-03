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

module FrontEnd(
				input reset,
				input clk,		
				input clkX4,
				input [1:0]clkPhase,
				
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
				output [`NUM_WARP_LOG-1:0] issuedWarp_o,
				output issuedPacketValid_o,
				output [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
							+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
							:0] issuedPacket_o,							
				output [`SIZE_CORE-1:0] issuedMask_o,
				
				output reconv_o,
				
				output issuedSync_o,
				output issuedExit_o,
				/*~Issue ouput*/
				
				/*Cache output*/
				output [`SIZE_PC-1:0] PC_o,
				output [`SIZE_PC-1:0] PCadd1_o,
				/*~Cache output*/
				
				output [`SIZE_PREDEFINED-1:0] ctaid_x_o,
				output [`SIZE_PREDEFINED-1:0] ctaid_y_o,
				output [`SIZE_PREDEFINED-1:0] ctaid_z_o,
				
				output pushInStack_stall_o,
				output kernelStall_o,
				output kernelDone_o
				
);

	parameter sm_id = 0;

	/*system parameters*/
	wire [`SIZE_PREDEFINED-1:0] nctaid_x;
	wire [`SIZE_PREDEFINED-1:0] nctaid_y;
	wire [`SIZE_PREDEFINED-1:0] nctaid_z;	
	wire [`SIZE_PREDEFINED-1:0] ntid_x;
	wire [`SIZE_PREDEFINED-1:0] ntid_y;
	wire [`SIZE_PREDEFINED-1:0] ntid_z;
	wire [`NUM_WARP_LOG-1:0] nctaSM;	//if 4 ,then 4-1 = 2'b11
	wire [`NUM_WARP-1:0] ctaEnMask;
	wire [`SIZE_CORE_LOG-1:0] nlaneSM;	//if 8 ,then 8-1 = 3'b111
	wire [`SIZE_CORE-1:0] simdEnMask;
	/*~system parameters*/
	
	wire [`SIZE_PREDEFINED-1:0] ctaid_x;
	wire [`SIZE_PREDEFINED-1:0] ctaid_y;
	wire [`SIZE_PREDEFINED-1:0] ctaid_z;
	wire ctaRun;
	wire [`NUM_WARP-1:0] ctaRunMask;	
	wire kernelDone;
	
	
	wire ctaExit;
	wire [`NUM_WARP_LOG-1:0] exitWarp;
	
	wire issuedSync;
	wire issuedExit;

	
	wire [`NUM_WARP-1:0] warpRun;
	wire [`NUM_WARP_LOG-1:0] instWarp;
	
	wire[`SIZE_PC-1:0] PC;
	wire[`SIZE_PC-1:0] PCadd1;
	wire[`SIZE_INSTRUCTION-1:0] instruction0;
	wire[`SIZE_INSTRUCTION-1:0] instruction1;
	
	wire instPacket0Valid;
	wire instPacket1Valid;
	wire [`SIZE_INSTRUCTION+`SIZE_PC-1:0] instPacket0;
	wire [`SIZE_INSTRUCTION+`SIZE_PC-1:0] instPacket1;
	wire [`SIZE_PC-1:0] fetchPC0;
	wire [`SIZE_PC-1:0] fetchPC1;
	/*wire [`NUM_WARP_LOG-1:0] instWarp_l1;
	wire instPacket0Valid_l1;
	wire instPacket1Valid_l1;
	wire [`SIZE_INSTRUCTION+`SIZE_PC-1:0] instPacket0_l1;
	wire [`SIZE_INSTRUCTION+`SIZE_PC-1:0] instPacket1_l1;*/
	//**
	wire [`NUM_WARP_LOG-1:0] decodedWarp;
	wire [`SIZE_PC-1:0] decodedPC0;
	wire [`SIZE_PC-1:0] decodedPC1;
	wire decodedPacket0Valid;
	wire decodedPacket1Valid;
	wire [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
							+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
							:0] decodedPacket0;
	wire [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
							+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
							:0] decodedPacket1;	
	//**					
	wire toSelectReady;
	wire [`NUM_WARP_LOG-1:0] toSelectWarp;
	wire [`NUM_ENTRY_LOG-1:0] toSelectEntry;
	wire [`SIZE_PC-1:0] toSelectPC;
	wire toSelectPacketValid;
	wire [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
							+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
							:0] toSelectPacket;
	//**
	wire [`NUM_WARP_LOG-1:0] selectedWarp;
	wire [`NUM_ENTRY_LOG-1:0] selectedEntry;
	wire [`SIZE_PC-1:0] selectedPC;
	wire [`SIZE_OPCODE-1:0] selectedOpcode;
	wire selectedPacketValid;
	wire [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
							+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
							:0] selectedPacket;
	wire [`NUM_WARP-1:0] warpValidVector;
	wire [`NUM_WARP-1:0] instValidVector0;
	wire [`NUM_WARP-1:0] instValidVector1;
	//**
	wire [`NUM_WARP_LOG-1:0] issuedWarp;
	wire [`SIZE_PC-1:0] issuedPC;
	wire [`SIZE_OPCODE-1:0] issuedOpcode;
	wire issuedPacketValid;
	wire [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
				+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
				:0] issuedPacket;						
	wire [`SIZE_CORE-1:0] issuedMask;	
	wire [`SIZE_CORE-1:0] exitLaneMask;
	wire [`SIZE_CORE-1:0] syncLaneMask;	
	/*wire [`NUM_WARP_LOG-1:0] issuedWarp_l1;
	wire issuedPacketValid_l1;
	wire [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
				+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
				:0] issuedPacket_l1;						
	wire [`SIZE_CORE-1:0] issuedMask_l1;*/
	//**
	wire pushInStack_stall;
	wire [`SIZE_CORE-1:0] TopActiveMask;
	wire [`SIZE_PC-1:0] TopRPC;
	wire [`SIZE_PC-1:0] TopPC;
	
	wire branch;
	wire reconv;
	//**
	wire [`NUM_WARP_LOG-1:0] fuWarp;
	
	//**
	
	wire [`NUM_WARP_LOG-1:0] intuWarp;
	wire intuPacketValid;
	wire [`SIZE_CORE-1:0] intuMask;
	wire [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
			:0]intuPacketLane0;
			
	wire [`NUM_WARP_LOG-1:0] loadWarp;
	wire loadPacketValid;
	wire [`SIZE_CORE-1:0] loadMask;					
	wire [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane0;
	
	
			
	wire [`NUM_WARP_LOG-1:0] instWarp_l1;
	wire instPacket0Valid_l1;
	wire instPacket1Valid_l1;
	wire [`SIZE_INSTRUCTION+`SIZE_PC-1:0] instPacket0_l1;
	wire [`SIZE_INSTRUCTION+`SIZE_PC-1:0] instPacket1_l1;
	
	wire [`NUM_WARP_LOG-1:0] issuedWarp_l1;
	wire [`SIZE_CORE-1:0] predMask;
	wire [`SIZE_PC-1:0] branchTarget;
	wire [`SIZE_PC-1:0] branchReconv;
	wire [`SIZE_PC-1:0] branchPC;
	
	wire sbintuValid;
	assign sbintuValid = (intuSM_i == sm_id);
	
	wire kernelStall;
	assign kernelStall =  kernelDone || (~ctaRun);
	
	
	
/*FrontEnd Interface*/
	assign frontEndStall = stall_i;
	assign freeze = freeze_i;
	
	/*system parameters*/
	assign nctaid_x = nctaid_x_i;
	assign nctaid_y = nctaid_y_i;
	assign nctaid_z = nctaid_z_i;	
	assign ntid_x = ntid_x_i;
	assign ntid_y = ntid_y_i;
	assign ntid_z = ntid_z_i;
	assign nctaSM = nctaSM_i;	//if 4 _i = ;then 4-1 = 2'b11
	assign ctaEnMask = ctaEnMask_i;
	assign nlaneSM = nlaneSM_i;	//if 8 _i = ;then 8-1 = 3'b111
	assign simdEnMask = simdEnMask_i;
	
	assign fuWarp = fuWarp_i;
	/*~system parameters*/
				
	/*interface with Cache*/
	assign instruction0 = instruction0_i;
	assign instruction1 = instruction1_i;
	/*~interface with Cache*/
	
	/*intu Commit*/
	assign intuWarp = intuWarp_i;
	assign intuPacketValid = intuPacketValid_i;
	assign intuMask = intuMask_i;
	assign intuPacketLane0 = intuPacketLane0_i;
	/*~intu Commit*/
	
	/*Load Commit*/
	assign loadWarp = loadWarp_i;
	assign loadPacketValid = loadPacketValid_i;
	assign loadMask =loadMask_i;
	assign loadPacketLane0 = loadPacketLane0_i;
	/*~Load Commit*/
	
	/*OpCol to SIMT_Stack*/
	assign issuedWarp_l1 = issuedWarp_l1_i;
	assign branch = branch_i;
	assign predMask = predMask_i;
	assign branchTarget = branchTarget_i;
	assign branchReconv = branchReconv_i;
	assign branchPC = branchPC_i;
	/*~OpCol to SIMT_Stack*/
	
	
	/*Issue ouput*/
	assign issuedWarp_o = issuedWarp;
	assign issuedPacketValid_o = issuedPacketValid;
	assign issuedPacket_o = issuedPacket;							
	assign issuedMask_o = issuedMask;
	
	assign reconv_o = reconv;
	
	assign issuedSync_o = issuedSync;
	assign issuedExit_o = issuedExit;
	/*~Issue ouput*/
	
	/*Cache output*/
	assign PC_o = PC;
	assign PCadd1_o = PCadd1;
	/*~Cache output*/
	
	assign ctaid_x_o = ctaid_x;
	assign ctaid_y_o = ctaid_y;
	assign ctaid_z_o = ctaid_z;
	
	assign pushInStack_stall_o = pushInStack_stall;
	assign kernelStall_o = kernelStall;
	assign kernelDone_o = kernelDone;
/*~FrontEnd Interface*/			
	
	
	
	CTAController
		ctaController(
			.reset(reset),
			.clk(clk),
			
			.stall_i(1'b0 || frontEndStall),//only stall when freeze
			
			.ctaExit_i(ctaExit),
			.exitWarp_i(exitWarp),
			
			.nctaid_x_i(nctaid_x),
			.nctaid_y_i(nctaid_y),
			.nctaid_z_i(nctaid_z),
			.nctaSM_i(nctaSM),
			.ctaEnMask_i(ctaEnMask),
			
			.fuWarp_i(fuWarp),
			
			.ctaid_x_o(ctaid_x),
			.ctaid_y_o(ctaid_y),
			.ctaid_z_o(ctaid_z),
			
			.ctaRun_o(ctaRun),
			.ctaRunMask_o(ctaRunMask),
			.kernelDone_o(kernelDone)
			
			);		
	
		
	ThreadController
		threadController(
			.reset(reset),//Front-End restarts when current cta exits.
			.clk(clk),
			
			.stall_i(kernelStall || frontEndStall),//only stall when freeze
			
			.simdEnMask_i(simdEnMask),
			
			.issuedSync_i(issuedSync),
			.issuedExit_i(issuedExit),
			
			.issuedWarp_i(issuedWarp),
			.issuedPacketValid_i(issuedPacketValid),						
			.issuedMask_i(issuedMask),
								
			
			//.ctaSync_o(ctaSync),
			.ctaExit_o(ctaExit),
			.exitWarp_o(exitWarp),
			//.exitWarpMask_o(),//need to modify
			
			.exitLaneMask_o(exitLaneMask),//according to issue Warp
			.syncLaneMask_o(syncLaneMask)//according to issue Warp		
			);

		
	Fetch fetch(
		.reset(reset),
		.clk(clk),
		
		.stall_i(kernelStall || (~pushInStack_stall && branch) || frontEndStall),
		
		.warpRunEnable_i(ctaRunMask),
		
		.ctaExit_i(ctaExit),
		.exitWarp_i(exitWarp),
		
		.reconv_i(reconv),
		.reconvWarp_i(selectedWarp),
		.reconvPC_i(TopPC),
		
		.warpValidVector_i(warpValidVector),
		
		.selectedWarp_i(toSelectWarp),
		.selectedEntry_i(toSelectEntry),
		.selectedPacketValid_i(toSelectPacketValid),
		
		/*interface with Cache*/
		.PC_o(PC),
		.PCadd1_o(PCadd1),
		.instruction0_i(instruction0),
		.instruction1_i(instruction1),
		/*~interface with Cache*/
		
		.instWarp_o(instWarp),
		.instPacket0Valid_o(instPacket0Valid),
		.instPacket0_o(instPacket0),
		.instPacket1Valid_o(instPacket1Valid),
		.instPacket1_o(instPacket1),
		
		.warpRun_o(warpRun)
	);

	FetchToDecode fetchtodecode(	
					.reset(reset),
					.clk(clk),
					
					.instWarp_i(instWarp),
					.instPacket0Valid_i(instPacket0Valid),
					.instPacket0_i(instPacket0),
					.instPacket1Valid_i(instPacket1Valid),
					.instPacket1_i(instPacket1),					
					
					.flush_i(reconv),
					.flushWarp_i(selectedWarp),
					.stall_i(kernelStall || (~pushInStack_stall && branch) || frontEndStall),
					
					.instWarp_o(instWarp_l1),
					.instPacket0Valid_o(instPacket0Valid_l1),
					.instPacket0_o(instPacket0_l1),
					.instPacket1Valid_o(instPacket1Valid_l1),
					.instPacket1_o(instPacket1_l1)
					);

	Decode  decode(	
				.reset(reset),
                .clk(clk),
				
				.instWarp_i(instWarp_l1),
				.instPacket0Valid_i(instPacket0Valid_l1),
				.instPachet0_i(instPacket0_l1),
				.instPacket1Valid_i(instPacket1Valid_l1),
				.instPachet1_i(instPacket1_l1),
				
				.decodedWarp_o(decodedWarp),
				.decodedPacket0Valid_o(decodedPacket0Valid),
				.decodedPacket0_o(decodedPacket0),
				.decodedPacket1Valid_o(decodedPacket1Valid),
				.decodedPacket1_o(decodedPacket1)						
				);
				
	InstBuffer instBuffer(
				.reset(reset),
                .clk(clk),				
				
				.decodedWarp_i(decodedWarp),
				.decodedPacket0Valid_i(decodedPacket0Valid),
				.decodedPacket0_i(decodedPacket0),
				.decodedPacket1Valid_i(decodedPacket1Valid),
				.decodedPacket1_i(decodedPacket1),
						
				.hazardVector0_i(0),//useless now
				.hazardVector1_i(0),//useless now
				
				
				//.toSelectReady_i(1'b1),//without ScoreBoard
				.toSelectReady_i(toSelectReady),//add ScoreBoard
				
				
				.flush_i(reconv),
				.flushWarp_i(selectedWarp),
				.stall_i(kernelStall || (~pushInStack_stall && branch) || frontEndStall),
				
				
				.warpValidVector_o(warpValidVector),
				.instValidVector0_o(instValidVector0),
				.instValidVector1_o(instValidVector1),
				
				.toSelectWarp_o(toSelectWarp),
				.toSelectEntry_o(toSelectEntry),
				.toSelectPacketValid_o(toSelectPacketValid),
				.toSelectPacket_o(toSelectPacket),
				
				.selectedWarp_o(selectedWarp),
				.selectedEntry_o(selectedEntry),
				.selectedPacketValid_o(selectedPacketValid),	
				.selectedPacket_o(selectedPacket)
				);

	
	ScoreBoard
		scoreBoard(
				.reset(reset),
				.clk(clk),
				
				.stall_i(1'b0/* || frontEndStall*/),
				
				.toSelectWarp_i(toSelectWarp),
				.toSelectPacketValid_i(toSelectPacketValid),
				.toSelectPacket_i(toSelectPacket),
				
				.intuWarp_i(intuWarp),
				.intuPacketValid_i(intuPacketValid && sbintuValid),
				.intuMask_i(intuMask),//useless 
				.intuPacketLane0_i(intuPacketLane0),//only need lane0 now			
				
				.loadWarp_i(loadWarp),
				.loadCommit_i(loadPacketValid),//???
				.loadMask_i(loadMask),//useless
				.loadPacketLane0_i(loadPacketLane0),//only need lane0 now
				
				
				.toSelectReady_o(toSelectReady)
				
				);
	
	Issue issue(	
	       .reset(reset),
	       .clk(clk),
	       
				.selectedWarp_i(selectedWarp),
				.selectedPacketValid_i(selectedPacketValid),
				.selectedPacket_i(selectedPacket),
				.ActiveMask_i(TopActiveMask & (~syncLaneMask) & (~exitLaneMask)),	//need to be modified
				.TopRPC_i(TopRPC),
				
				.issuedWarp_o(issuedWarp),
				.issuedPacketValid_o(issuedPacketValid),
				.issuedPacket_o(issuedPacket),							
				.issuedMask_o(issuedMask),
				
				.reconv_o(reconv),
				
				.issuedSync_o(issuedSync),
				.issuedExit_o(issuedExit)
				
				);

	
	SIMTStack simtStack(	
				.clk(clk),
				.reset(reset),
				
				.stall_i(kernelStall || frontEndStall),
				
				.branch_i(branch),
				.branchWarp_i(issuedWarp_l1),
				.predMask_i(predMask),
				.pushTarget_i(branchTarget),
				.pushReconv_i(branchReconv),
				.pushPC_i(branchPC),
			
				.reconv_i(reconv),
				.issuedWarp_i(issuedWarp),
				
				.pushInStack_stall_o(pushInStack_stall),
				.TopPC_o(TopPC),
				.TopRPC_o(TopRPC),
				
				.TopActiveMask_o(TopActiveMask)
				);
				
	  assign fetchPC0 = instPacket0[`SIZE_PC-1:0];
	  assign fetchPC1 = instPacket1[`SIZE_PC-1:0];
	  assign decodedPC0 = decodedPacket0[`SIZE_PC*3-1:`SIZE_PC*2];
	  assign decodedPC1 = decodedPacket1[`SIZE_PC*3-1:`SIZE_PC*2];
	  assign toSelectPC = toSelectPacket[`SIZE_PC*3-1:`SIZE_PC*2];
	  assign selectedPC = selectedPacket[`SIZE_PC*3-1:`SIZE_PC*2];
	  assign selectedOpcode = selectedPacket[`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1:`SIZE_RP+1+3*`SIZE_PC];
	  assign issuedPC = issuedPacket[`SIZE_PC*3-1:`SIZE_PC*2];
	  assign issuedOpcode = issuedPacket[`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1:`SIZE_RP+1+3*`SIZE_PC];
endmodule