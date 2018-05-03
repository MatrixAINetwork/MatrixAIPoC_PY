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
`include "MemoryParam.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:17:44 05/13/2013 
// Design Name: 
// Module Name:    stall_control 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
 module StallControl(
			input clk,
			input reset,
			input stall_i,
			input DDR3_rdy,
			input DDR3_w_rdy,
			input LSUOut2DDR3_en,
			input SAME_i,
			output reg DDR3_n_rdy
    );
	 reg DDR3_rdy_pre;
	 reg DDR3_w_rdy_pre;
	 reg WorkCondition;
	always @ (posedge clk)
	begin
	if(reset)
	begin
		DDR3_n_rdy <= 0;
		WorkCondition <= 0;
	end
	else if(~stall_i)
	begin
	DDR3_rdy_pre <= DDR3_rdy;
	DDR3_w_rdy_pre <= DDR3_w_rdy;
	case(WorkCondition)
	0:begin
		if(SAME_i)
		begin
			DDR3_n_rdy <= 0;
		end
		else if(LSUOut2DDR3_en)
		begin
			DDR3_n_rdy <= 1;
			WorkCondition <= 1;
		end
		end
	1:
		begin
		if(DDR3_rdy_pre == 0 & DDR3_rdy == 1)
			begin 
				WorkCondition <= 0;
				DDR3_n_rdy <= 0;
			end
		else if(DDR3_w_rdy_pre == 0 & DDR3_w_rdy == 1)
			begin
				WorkCondition <= 0;
				DDR3_n_rdy <= 0;
			end
		end
	endcase
	end
	end

endmodule
