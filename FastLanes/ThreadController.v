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

//not configurable yet!!!
module ThreadController(
		input reset,
		input clk,
		
		input stall_i,
		
		input [`SIZE_CORE-1:0] simdEnMask_i,
		
		
		input issuedSync_i,
		input issuedExit_i,
		
		input [`NUM_WARP_LOG-1:0] issuedWarp_i,
		input issuedPacketValid_i,						
		input [`SIZE_CORE-1:0] issuedMask_i,
		
		//output ctaSync_o,
		output reg ctaExit_o,
		output reg [`NUM_WARP_LOG-1:0] exitWarp_o,
		
		output [`SIZE_CORE-1:0] exitLaneMask_o,	//according to issue Warp
		output [`SIZE_CORE-1:0] syncLaneMask_o	//according to issue Warp		
		);
	
	
	
	
										
	//******Sync and Exit******
	reg [`SIZE_CORE-1:0] threadSync [`NUM_WARP-1:0];
	reg [`SIZE_CORE-1:0] threadExit [`NUM_WARP-1:0];
	reg ctaSync;
	reg ctaExit;
	
	assign syncLaneMask_o = threadSync[issuedWarp_i];
	assign exitLaneMask_o = threadExit[issuedWarp_i];
	
	always @(*) begin
		if(issuedPacketValid_i && issuedSync_i) begin
			ctaSync = &(threadSync[issuedWarp_i] | issuedMask_i);		
		end
		else begin
			ctaSync = &(threadSync[issuedWarp_i]);
		end
		
		
		if(issuedPacketValid_i && issuedExit_i) begin
			ctaExit = &(threadExit[issuedWarp_i] | issuedMask_i);		
		end
		else begin
			ctaExit = &(threadExit[issuedWarp_i]);
		end
	end
	//need to be modified after post-DAC?
	//assign ctaSync = &((issuedPacketValid_i && issuedSync_i) ? (threadSync[issuedWarp_i] | issuedMask_i) : threadSync[issuedWarp_i]);//(&threadSync[0]) && (&threadSync[1]) && (&threadSync[2]) && (&threadSync[3]);
	//assign ctaExit = &(threadExit[issuedWarp_i] | issuedMask_i);
	//assign ctaSync_o = ctaSync;
	//assign ctaExit_o = ctaExit;
	
	always @(posedge clk) begin
	
		if(reset) begin: TC_RESET			
			integer i;
			for(i=0; i<`NUM_WARP; i = i+1) begin
				threadSync[i] <= ~simdEnMask_i;
			end
			
			for(i=0; i<`NUM_WARP; i = i+1) begin
				threadExit[i] <= ~simdEnMask_i;
			end
			/*
			threadSync[0] <= ~simdEnMask_i;
			threadSync[1] <= ~simdEnMask_i;
			threadSync[2] <= ~simdEnMask_i;
			threadSync[3] <= ~simdEnMask_i;
			
			threadExit[0] <= ~simdEnMask_i;
			threadExit[1] <= ~simdEnMask_i;
			threadExit[2] <= ~simdEnMask_i;
			threadExit[3] <= ~simdEnMask_i;
			*/
			
			ctaExit_o <= 0;
			exitWarp_o <= 0;
		end
		else begin
			if(~stall_i) begin
				ctaExit_o <= ctaExit;
				exitWarp_o <= issuedWarp_i;
				
				
				//**Sync Operation**
				if(ctaSync) begin	//if last cycle synced(May remain some bug?)
					threadSync[issuedWarp_i] <= ~simdEnMask_i;
				end
				else if(issuedPacketValid_i && issuedSync_i) begin
					threadSync[issuedWarp_i] <= threadSync[issuedWarp_i] | issuedMask_i;		
				end
				else begin
				end
				
				
				//**Exit Operation**
				if(ctaExit) begin
					threadExit[issuedWarp_i] <= ~simdEnMask_i;
				end
				else if(issuedPacketValid_i && issuedExit_i) begin
					threadExit[issuedWarp_i] <= threadExit[issuedWarp_i] | issuedMask_i;		
				end
				else begin
				end
				
			end
		end
	end
	
	
endmodule