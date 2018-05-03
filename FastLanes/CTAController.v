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

module CTAController(
		input reset,
		input clk,
		
		input stall_i,
		
		input ctaExit_i,
		input [`NUM_WARP_LOG-1:0] exitWarp_i,
		
		//**Simulator System Parameters**
		input [`SIZE_PREDEFINED-1:0] nctaid_x_i,	//max cta id
		input [`SIZE_PREDEFINED-1:0] nctaid_y_i,
		input [`SIZE_PREDEFINED-1:0] nctaid_z_i,
		input [`NUM_WARP_LOG-1:0] nctaSM_i,			//allowed warp number in a SM
		input [`NUM_WARP-1:0] ctaEnMask_i,	//follow "ctaPerSM_i"
		//**
		
		input [`NUM_WARP_LOG-1:0] fuWarp_i,
		
		output [`SIZE_PREDEFINED-1:0] ctaid_x_o,
		output [`SIZE_PREDEFINED-1:0] ctaid_y_o,
		output [`SIZE_PREDEFINED-1:0] ctaid_z_o,
		
		output reg ctaRun_o,
		output [`NUM_WARP-1:0] ctaRunMask_o,
		output reg kernelDone_o
		
		);

	reg [`NUM_WARP_LOG-1:0] warp;
	reg [`SIZE_PREDEFINED-1:0] ctaid_x [`NUM_WARP-1:0];
	reg [`SIZE_PREDEFINED-1:0] ctaid_y [`NUM_WARP-1:0];
	reg [`SIZE_PREDEFINED-1:0] ctaid_z [`NUM_WARP-1:0];
	reg [`NUM_WARP-1:0] kernelDone;
	
	reg [`SIZE_PREDEFINED-1:0] ctaCounter;
	
	//pointers for setting cta indexes
	reg [`SIZE_PREDEFINED-1:0] pCtaid_x;
	reg [`SIZE_PREDEFINED-1:0] pCtaid_y;
	reg [`SIZE_PREDEFINED-1:0] pCtaid_z;
	reg pKernelDone;
		
	assign ctaid_x_o = ctaid_x[fuWarp_i];
	assign ctaid_y_o = ctaid_y[fuWarp_i];
	assign ctaid_z_o = ctaid_z[fuWarp_i];
	assign ctaRunMask_o = (~kernelDone) & ctaEnMask_i;
	
	reg resetState;
	//reg [`NUM_WARP_LOG-1:0] resetLdWarpCnt;
	
	always @(posedge clk) begin
		if(reset) begin
			ctaRun_o <= 0;
			warp <= 0;
		
			ctaCounter <= 0;
			pCtaid_x <= 0;
			pCtaid_y <= 0;
			pCtaid_z <= 0;
			pKernelDone <= 0;
			
			kernelDone <= 0;
			kernelDone_o <= 0;
			
			resetState <= 1'b1;
		end	
		
		else begin
			if(~stall_i) begin
				if(ctaExit_i && ctaRun_o) begin
					kernelDone_o <= |kernelDone;
					ctaRun_o <= 0;
					warp <= exitWarp_i;
				end
				
				else if(ctaRun_o == 0) begin
					if(resetState) begin
						if(warp == nctaSM_i) begin
							ctaRun_o <= 1;
							resetState <= 0;
						end
					end
					else begin
						ctaRun_o <= 1;
					end
					
					ctaid_x[warp] <= pCtaid_x;
					ctaid_y[warp] <= pCtaid_y;
					ctaid_z[warp] <= pCtaid_z;
					kernelDone[warp] <= pKernelDone;
					warp <= warp + 1;
					//ctaCounter++
					ctaCounter <= ctaCounter + 1;					
					
					
					//pCtaid.x++
					if(pCtaid_x < nctaid_x_i-1) begin
						pCtaid_x <= pCtaid_x + 1;
					end
					else begin						
						pCtaid_x <= 0;
						
						//pCtaid.y++
						if(pCtaid_y < nctaid_y_i-1) begin
							pCtaid_y <= pCtaid_y + 1;
						end
						else begin
							pCtaid_y <= 0;
						
							//pCtaid.z++
							if(pCtaid_z < nctaid_z_i-1) begin
							pCtaid_z <= pCtaid_z + 1;
							end
							else begin
								pCtaid_z <= 0;
								pKernelDone <= 1'b1;//Kernel Done
							end
						end
					end
				end					
				
			end
		end
	end
	
	
endmodule