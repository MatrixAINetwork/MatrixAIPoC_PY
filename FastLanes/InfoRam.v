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
`define SIZE_RAM 32
`define SIZE_RAM_LOG 5
module InfoRAM(
			input clk,
			input reset,
			input stall_i,
			
			input [`SIZE_CORE + `NUM_WARP_LOG + `SIZE_REGFILE_BR + 2:0] InfoRamInfo_i,
			input [`SIZE_CORE * `SIZE_ADDR - 1 :0 ] InfoRamAddr_i,
			input [`SIZE_CORE * `SIZE_DATA - 1 :0 ] InfoRamData_i,
			input RAM_Write,
			input RAM_Out,
			input [`SIZE_RAM_LOG - 1 : 0] RAM_Out_Addr,
			
			output [`SIZE_RAM_LOG - 1 : 0] addr_write,
			output InfoRamFull,
			output [`SIZE_CORE + `NUM_WARP_LOG + `SIZE_REGFILE_BR + 2:0] InfoRamInfo_o,
			output [`SIZE_CORE * `SIZE_ADDR - 1 :0 ] InfoRamAddr_o,
			output [`SIZE_CORE * `SIZE_DATA - 1 :0 ] InfoRamData_o
			);	
		reg [`SIZE_RAM - 1 : 0 ] RamValid;
		wire [`SIZE_RAM_LOG - 1 : 0] FirstZero;
		reg [`SIZE_RAM_LOG - 1 : 0] num;

		wire [`SIZE_RAM_LOG - 1 : 0 ] addr_read;
		assign addr_read = RAM_Out_Addr;
		reg full;
		assign InfoRamFull = full;
		assign addr_write = FirstZero;
		always @(posedge clk)
		begin
			if(reset)
			begin
				RamValid <= 0;
				num <= 0;
				full <= 0;
			end
			else if(~stall_i & (RAM_Write | RAM_Out))
			begin
				if(RAM_Write & ~full)
				begin
					if(num == `SIZE_RAM - 1)
					begin
						full <= 1;
					end
					else begin
						RamValid[FirstZero] <= 1;
						num <= num + 1;
					end
					
				end
				else if(RAM_Out)
				begin
					if(RamValid[RAM_Out_Addr])
					begin
						RamValid[RAM_Out_Addr] <= 0;
						num <= num - 1;
						full <= 0;
					end
				end		
			end	
		end
		
		FirstZero firstZero(
			.RamValid(RamValid),
			.FirstZero(FirstZero)
		);

	
		IPCore_DisRAM_SimplePort #(`SIZE_RAM, `SIZE_RAM_LOG, 	`SIZE_CORE + `NUM_WARP_LOG + `SIZE_REGFILE_BR + 3)
		Info(
		  .a(FirstZero),//addr_write
		  .d(InfoRamInfo_i),//din
		  .dpra(addr_read),//addr_read
		  .clk(clk),
		  .we(RAM_Write && (~full) && (~stall_i)),
		  .dpo(InfoRamInfo_o)//dout
		);	
		
		IPCore_DisRAM_SimplePort #(`SIZE_RAM, `SIZE_RAM_LOG, `SIZE_CORE * `SIZE_ADDR )
		Addr(
		  .a(FirstZero),//addr_write
		  .d(InfoRamAddr_i),//din
		  .dpra(addr_read),//addr_read
		  .clk(clk),
		  .we(RAM_Write && (~full) && (~stall_i)),
		  .dpo(InfoRamAddr_o)//dout
		);	
		
		IPCore_DisRAM_SimplePort #(`SIZE_RAM, `SIZE_RAM_LOG,  `SIZE_CORE * `SIZE_DATA )
		Data(
		  .a(FirstZero),//addr_write
		  .d(InfoRamData_i),//din
		  .dpra(addr_read),//addr_read
		  .clk(clk),
		  .we(RAM_Write && (~full) && (~stall_i)),
		  .dpo(InfoRamData_o)//dout
		);
endmodule