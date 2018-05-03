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

module Fetch(
		input reset,
		input clk,
		
		input stall_i,
		//input [`SIZE_SM-1:0] SM_i,
		
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

/*
	parameter SMid = 0;
	
	wire stall;
	assign stall = stall_i || (SM_i != SMid);
	wire selectedPacketValid;
	assign selectedPacketValid = selectedPacketValid_i && (SM_i == SMid);
*/
	wire stall;
	assign stall = stall_i;
	wire selectedPacketValid;
	assign selectedPacketValid = selectedPacketValid_i;
	
	
	/* Defining Program Counter register. */
	reg [`SIZE_PC-1:0] warpPC[`NUM_WARP-1:0];
	reg [`NUM_WARP-1:0] warpRun;	
	
	
	wire [`SIZE_PC-1:0] PC_ARB;
	wire [`SIZE_PC-1:0] PC;
	wire [`SIZE_PC-1:0] PCadd1;
	reg [`SIZE_PC-1:0] nextPC;
	
	
	reg [`NUM_ENTRY-1:0] instructionValid;
	wire [`SIZE_INSTRUCTION-1:0] instruction0, instruction1;
	
	reg [`NUM_WARP_LOG-1:0] preWarp;
	wire [`NUM_WARP_LOG-1:0] curWarp;
	wire [`NUM_WARP-1:0] warpEligeble;
	wire anyWarpFetched;
	
	reg [`NUM_WARP-1:0] instValidVector0;
	reg [`NUM_WARP-1:0] instValidVector1;
	wire [`NUM_WARP-1:0] warpValidVector_fetch;
	wire [`NUM_WARP-1:0] warpValidVector_final;
	
	assign warpRun_o = warpRun;
	
	assign PCadd1 = PC + 1;
	
	assign warpValidVector_fetch = instValidVector0 | instValidVector1;
	assign warpValidVector_final = warpValidVector_fetch;// | warpValidVector_i;
	assign anyWarpFetched = (~warpValidVector_final[curWarp]) && warpRun[curWarp] && ~((curWarp == reconvWarp_i) && (reconv_i));
	
	assign instWarp_o = curWarp;
	assign instPacket0Valid_o = instructionValid[0];
	assign instPacket1Valid_o = instructionValid[1];
	assign instPacket0_o = {  instruction0,
								PC	                        
	                         };
	assign instPacket1_o = {  instruction1,
								PCadd1	                        
							 };
							 

	
	assign instruction0 = instruction0_i;      
	assign instruction1 = instruction1_i;      
	assign PC_o = PC;
	assign PCadd1_o = PCadd1;
  
	/* To judege if the warp is finished. 
	*/
	always @(*) begin: WARPRUN_VALUE
		integer i;
		for(i=0; i<`NUM_WARP; i = i+1) begin
			warpRun[i] = (warpPC[i] != `WARP0_END) && (~reset) && warpRunEnable_i[i];
		end
	end	
	/*
	assign warpRun[0] = (warpPC[0] != `WARP0_END) && (~reset) && warpRunEnable[0];
	assign warpRun[1] = (warpPC[1] != `WARP1_END) && (~reset) && warpRunEnable[1];
	assign warpRun[2] = (warpPC[2] != `WARP2_END) && (~reset) && warpRunEnable[2];
	assign warpRun[3] = (warpPC[3] != `WARP3_END) && (~reset) && warpRunEnable[3];
	*/
	
	assign warpEligeble = (~warpValidVector_final) & warpRun;
  
  /* ARB: Round-Robin Arbiter
  */
  FetchArbiter fetchArbiter(
							.preWarp_i(preWarp),
							.warpEligeble_i(warpEligeble),
							.grantWarp_o(curWarp)
							);
  
	always @(*) begin: INST_VALID
	  if(anyWarpFetched) begin
	     instructionValid <= 2'b11;
	  end
	  else begin
	     instructionValid <= 2'b00;
	  end   
	end
  
  assign PC_ARB = warpPC[curWarp];
  assign PC = PC_ARB;  
  
  always @(*) begin: NEXT_PC
	 nextPC = PC + 2;     //2*SIZE_INSTRUCTION / 64 = 2
  end
  
  /* Following updates the nextPC to the Program Counter. 
  */
  always @(posedge clk) begin: WARP_PC_VALUE
	 if (reset) begin: WARP_PC_RESET
		integer i;
	    preWarp <= `PREWARP_START;
		
		for(i=0; i<`NUM_WARP; i = i+1) begin
			warpPC[i] <= `WARP0_START;
		end
		/*
		  warpPC[0] <= `WARP0_START;
		  warpPC[1] <= `WARP0_START;
		  warpPC[2] <= `WARP0_START;
		  warpPC[3] <= `WARP0_START;
		*/  
		  
		  instValidVector0 <= 0;
		  instValidVector1 <= 0;
	 end
	
	 else begin
		if(~stall_i) begin
			/*exit, so jump*/
			if(ctaExit_i) begin
				warpPC[exitWarp_i] <= `WARP0_START;
				instValidVector0[exitWarp_i] <= 1'b0;
				instValidVector1[exitWarp_i] <= 1'b0;
			end
			
	   		/*reconv, so jump*/
			else if(reconv_i) begin
				warpPC[reconvWarp_i] <= reconvPC_i;
				
				instValidVector0[reconvWarp_i] <= 1'b0;
				instValidVector1[reconvWarp_i] <= 1'b0;
			end
			
			if(anyWarpFetched) begin
				
				preWarp <= curWarp;
				
				instValidVector0[curWarp] <= 1'b1;
				instValidVector1[curWarp] <= 1'b1;
				/**/
				if(((~reconv_i) || (reconvWarp_i != curWarp)) && ((~ctaExit_i) || (exitWarp_i != curWarp)))begin
					warpPC[curWarp] <= nextPC; //???
				end		  
				else begin		  
				end			
			end
			else begin			
			end
			
			if(selectedPacketValid_i) begin
				case(selectedEntry_i)
					1'b0: begin
						instValidVector0[selectedWarp_i] <= 1'b0;
					end
					
					1'b1: begin
						instValidVector1[selectedWarp_i] <= 1'b0;
					end
				endcase
			end
			else begin
			end
		end
	end
  end
endmodule

