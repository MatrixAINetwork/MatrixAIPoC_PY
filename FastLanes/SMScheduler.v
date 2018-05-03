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

module SMScheduler(
				input reset,
				input clk,
		
				input stall_i,
				
				input [`SIZE_SM_LOG-1:0] nSM_i,			//allowed SM number
				//input [`SIZE_SM-1:0] SMEnMask_i,	//follow "nSM_i"
				input [`SIZE_GRAN-1:0] granu_i,
				input swapDone_i,
				
				
				//notBraRcv
				input branch_i,
				input issuedbranch_i,
				input reconv_i,
				
				//notLdSt
				input lsuStallFront_i,
				input frontendLdSt_i,
				input issuedLdSt_i,
				input fuLdSt_i,
				input aguLdSt_i,
				
				
				output [`SIZE_SM_LOG-1:0] sm_o,
				output reg stallRun_o
);
	reg [`SIZE_SM_LOG-1:0] sm;
	reg [`SIZE_GRAN-1:0] cycCnt;
	
	wire notBraRcv;
	wire notLdSt;
	assign notBraRcv = ~reconv_i && ~issuedbranch_i && ~branch_i;
	assign notLdSt = lsuStallFront_i ? (~issuedLdSt_i && ~fuLdSt_i && ~aguLdSt_i) : (~frontendLdSt_i && ~issuedLdSt_i && ~fuLdSt_i);
	
	assign sm_o = sm;
	
	always @(posedge clk) begin
		if(reset) begin
			sm <= 0;
			cycCnt <= 0;
		end	
		
		else begin
			if(~stall_i) begin
				if(cycCnt < granu_i) begin
					stallRun_o <= 1'b0;
					cycCnt <= cycCnt + 1;
				end
				else begin
					if(notBraRcv && notLdSt) begin	//satisfy shifting condition
						if(swapDone_i) begin
							stallRun_o <= 1'b0;
							cycCnt <= 0;
							if(sm == nSM_i) sm <= 0;
							else sm <= sm + 1;
						end
						else if(~swapDone_i) begin
							stallRun_o <= 1'b1;
						end
					end
				end
			end
		end
	end
	

endmodule