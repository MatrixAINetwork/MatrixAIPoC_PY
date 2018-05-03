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
// Create Date:    22:35:49 05/13/2013 
// Design Name: 
// Module Name:    LSUOutUnit 
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
module LSUOutUnit(
			input clk,
			input reset,
			input stall_i,
			
			input RAM_Out,
			input [`SIZE_CORE + `NUM_WARP_LOG + `SIZE_REGFILE_BR + 2:0] InfoRamInfo_o,
			input [`SIZE_CORE * `SIZE_ADDR - 1 :0 ] InfoRamAddr_o,
			input [`SIZE_CORE * `SIZE_DATA - 1 :0 ] InfoRamData_o,
			input DDR3_rdy,
			input DDR3_w_rdy,
			input DDR3_n_rdy,
			input DDR3OutPacketWorking_i,
			output reg [`SIZE_CORE * `SIZE_ADDR - 1 :0 ] InfoRamAddr_o_o,
			output reg [`SIZE_CORE - 1 : 0 ] lane_mask_o,
			output reg [27:0] RAM2DDR3_addr_o,
			output reg [63:0] RAM2DDR3_mask_o,
			output reg [511:0] RAM2DDR3_din_o,
			output reg RAM2DDR3_we_o,
			output reg [`NUM_WARP_LOG - 1 :0] RAM2DDR3_ldstWarp_o,
			output reg [`SIZE_REGFILE_BR - 1 :0] RAM2DDR3_ldstReg_o,
			output reg load_o,
			output reg store_o,
			output reg LSUOut_working,
			output reg SAME
    );
	reg load_o_pre,store_o_pre;
	reg [27:0] RAM2DDR3_addr_o_pre;
	reg [`SIZE_CORE - 1 :0] lane_mask,out_mask;
	wire [`SIZE_CORE_LOG :0] SegNum;
	assign SegNum = out_mask[0]+out_mask[1]+out_mask[2]+out_mask[3]+out_mask[4]+out_mask[5]+out_mask[6]+out_mask[7]+out_mask[8]+out_mask[9]
								+out_mask[10]+out_mask[11]+out_mask[12]+out_mask[13]+out_mask[14]+out_mask[15]+out_mask[16]+out_mask[17]+out_mask[18]+
								out_mask[19]+out_mask[20]+out_mask[21]+out_mask[22]+out_mask[23]+out_mask[24]+out_mask[25]+out_mask[26]+out_mask[27]+
								out_mask[28]+out_mask[29]+out_mask[30]+out_mask[31];
	
	reg [`SIZE_CORE + `NUM_WARP_LOG + `SIZE_REGFILE_BR + 2:0] InfoRamInfo;
	reg [`SIZE_CORE * `SIZE_ADDR - 1 :0 ] InfoRamAddr;
	reg [`SIZE_CORE * `SIZE_DATA - 1 :0 ] InfoRamData;
	reg [27:0] RAM2DDR3_addr;
	reg [63:0] RAM2DDR3_mask;
	reg [511:0] RAM2DDR3_din;
	reg RAM2DDR3_we; 
	
	wire [`SIZE_CORE_LOG - 1 :0] FirstOne;
	reg [`SIZE_SEGMENT_BYTES_LOG - 1 :0 ] offset;
	reg [`SIZE_DATA - 1 :0] din;
	always @(*)
	begin 
		case(FirstOne)
		5'b00000: begin offset = InfoRamAddr[ `SIZE_ADDR * 0 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 0];
				din = InfoRamData[0 * 32 + 31 : 0 * 32]; end
		5'b00001: begin offset = InfoRamAddr[ `SIZE_ADDR * 1 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 1];
				din = InfoRamData[1 * 32 + 31 : 1 * 32]; end
		5'b00010: begin offset = InfoRamAddr[ `SIZE_ADDR * 2 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 2];
				din = InfoRamData[2 * 32 + 31 : 2 * 32]; end
		5'b00011: begin offset = InfoRamAddr[ `SIZE_ADDR * 3 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 3];
				din = InfoRamData[3 * 32 + 31 : 3 * 32]; end
		5'b00100: begin offset = InfoRamAddr[ `SIZE_ADDR * 4 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 4];
				din = InfoRamData[4 * 32 + 31 : 4 * 32]; end
		5'b00101: begin offset = InfoRamAddr[ `SIZE_ADDR * 5 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 5];
				din = InfoRamData[5 * 32 + 31 : 5 * 32]; end
		5'b00110: begin offset = InfoRamAddr[ `SIZE_ADDR * 6 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 6];
				din = InfoRamData[6 * 32 + 31 : 6 * 32]; end
		5'b00111: begin offset = InfoRamAddr[ `SIZE_ADDR * 7 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 7];
				din = InfoRamData[7 * 32 + 31 : 7 * 32]; end
		5'b01000: begin offset = InfoRamAddr[ `SIZE_ADDR * 8 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 8];
				din = InfoRamData[8 * 32 + 31 : 8 * 32]; end
		5'b01001: begin offset = InfoRamAddr[ `SIZE_ADDR * 9 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 9];
				din = InfoRamData[9 * 32 + 31 : 9 * 32]; end
		5'b01010: begin offset = InfoRamAddr[ `SIZE_ADDR * 10 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 10];
				din = InfoRamData[10 * 32 + 31 : 10 * 32]; end
		5'b01011: begin offset = InfoRamAddr[ `SIZE_ADDR * 11 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 11];
				din = InfoRamData[11 * 32 + 31 : 11 * 32]; end
		5'b01100: begin offset = InfoRamAddr[ `SIZE_ADDR * 12 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 12];
				din = InfoRamData[12 * 32 + 31 : 12 * 32]; end
		5'b01101: begin offset = InfoRamAddr[ `SIZE_ADDR * 13 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 13];
				din = InfoRamData[13 * 32 + 31 : 13 * 32]; end
		5'b01110: begin offset = InfoRamAddr[ `SIZE_ADDR * 14 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 14];
				din = InfoRamData[14 * 32 + 31 : 14 * 32]; end
		5'b01111: begin offset = InfoRamAddr[ `SIZE_ADDR * 15 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 15];
				din = InfoRamData[15 * 32 + 31 : 15 * 32]; end
		5'b10000: begin offset = InfoRamAddr[ `SIZE_ADDR * 16 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 16];
				din = InfoRamData[16 * 32 + 31 : 16 * 32]; end
		5'b10001: begin offset = InfoRamAddr[ `SIZE_ADDR * 17 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 17];
				din = InfoRamData[17 * 32 + 31 : 17 * 32]; end
		5'b10010: begin offset = InfoRamAddr[ `SIZE_ADDR * 18 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 18];
				din = InfoRamData[18 * 32 + 31 : 18 * 32]; end
		5'b10011: begin offset = InfoRamAddr[ `SIZE_ADDR * 19 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 19];
				din = InfoRamData[19 * 32 + 31 : 19 * 32]; end
		5'b10100: begin offset = InfoRamAddr[ `SIZE_ADDR * 20 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 20];
				din = InfoRamData[20 * 32 + 31 : 20 * 32]; end
		5'b10101: begin offset = InfoRamAddr[ `SIZE_ADDR * 21 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 21];
				din = InfoRamData[21 * 32 + 31 : 21 * 32]; end
		5'b10110: begin offset = InfoRamAddr[ `SIZE_ADDR * 22 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 22];
				din = InfoRamData[22 * 32 + 31 : 22 * 32]; end
		5'b10111: begin offset = InfoRamAddr[ `SIZE_ADDR * 23 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 23];
				din = InfoRamData[23 * 32 + 31 : 23 * 32]; end
		5'b11000: begin offset = InfoRamAddr[ `SIZE_ADDR * 24 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 24];
				din = InfoRamData[24 * 32 + 31 : 24 * 32]; end
		5'b11001: begin offset = InfoRamAddr[ `SIZE_ADDR * 25 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 25];
				din = InfoRamData[25 * 32 + 31 : 25 * 32]; end
		5'b11010: begin offset = InfoRamAddr[ `SIZE_ADDR * 26 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 26];
				din = InfoRamData[26 * 32 + 31 : 26 * 32]; end
		5'b11011: begin offset = InfoRamAddr[ `SIZE_ADDR * 27 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 27];
				din = InfoRamData[27 * 32 + 31 : 27 * 32]; end
		5'b11100: begin offset = InfoRamAddr[ `SIZE_ADDR * 28 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 28];
				din = InfoRamData[28 * 32 + 31 : 28 * 32]; end
		5'b11101: begin offset = InfoRamAddr[ `SIZE_ADDR * 29 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 29];
				din = InfoRamData[29 * 32 + 31 : 29 * 32]; end
		5'b11110: begin offset = InfoRamAddr[ `SIZE_ADDR * 30 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 30];
				din = InfoRamData[30 * 32 + 31 : 30 * 32]; end
		5'b11111: begin offset = InfoRamAddr[ `SIZE_ADDR * 31 + `SIZE_SEGMENT_BYTES_LOG - 1 : `SIZE_ADDR * 31];
				din = InfoRamData[31 * 32 + 31 : 31 * 32]; end
		endcase
	end
 	always @(*)
	begin
	if(RAM_Out & ~stall_i)
	begin
 			case(FirstOne)
			5'b00000:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (0 + 1) - 1 : `SIZE_ADDR * 0];
			5'b00001:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (1 + 1) - 1 : `SIZE_ADDR * 1];
			5'b00010:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (2 + 1) - 1 : `SIZE_ADDR * 2];
			5'b00011:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (3 + 1) - 1 : `SIZE_ADDR * 3];
			5'b00100:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (4 + 1) - 1 : `SIZE_ADDR * 4];
			5'b00101:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (5 + 1) - 1 : `SIZE_ADDR * 5];
			5'b00110:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (6 + 1) - 1 : `SIZE_ADDR * 6];
			5'b00111:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (7 + 1) - 1 : `SIZE_ADDR * 7];
			5'b01000:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (8 + 1) - 1 : `SIZE_ADDR * 8];
			5'b01001:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (9 + 1) - 1 : `SIZE_ADDR * 9];
			5'b01010:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (10 + 1) - 1 : `SIZE_ADDR * 10];
			5'b01011:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (11 + 1) - 1 : `SIZE_ADDR * 11];
			5'b01100:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (12 + 1) - 1 : `SIZE_ADDR * 12];
			5'b01101:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (13 + 1) - 1 : `SIZE_ADDR * 13];
			5'b01110:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (14 + 1) - 1 : `SIZE_ADDR * 14];
			5'b01111:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (15 + 1) - 1 : `SIZE_ADDR * 15];
			5'b10000:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (16 + 1) - 1 : `SIZE_ADDR * 16];
			5'b10001:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (17 + 1) - 1 : `SIZE_ADDR * 17];
			5'b10010:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (18 + 1) - 1 : `SIZE_ADDR * 18];
			5'b10011:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (19 + 1) - 1 : `SIZE_ADDR * 19];
			5'b10100:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (20 + 1) - 1 : `SIZE_ADDR * 20];
			5'b10101:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (21 + 1) - 1 : `SIZE_ADDR * 21];
			5'b10110:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (22 + 1) - 1 : `SIZE_ADDR * 22];
			5'b10111:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (23 + 1) - 1 : `SIZE_ADDR * 23];
			5'b11000:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (24 + 1) - 1 : `SIZE_ADDR * 24];
			5'b11001:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (25 + 1) - 1 : `SIZE_ADDR * 25];
			5'b11010:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (26 + 1) - 1 : `SIZE_ADDR * 26];
			5'b11011:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (27 + 1) - 1 : `SIZE_ADDR * 27];
			5'b11100:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (28 + 1) - 1 : `SIZE_ADDR * 28];
			5'b11101:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (29 + 1) - 1 : `SIZE_ADDR * 29];
			5'b11110:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (30 + 1) - 1 : `SIZE_ADDR * 30];
			5'b11111:RAM2DDR3_addr = InfoRamAddr[ `SIZE_ADDR * (31 + 1) - 1 : `SIZE_ADDR * 31];
			endcase
		end
	end
	
	reg [`NUM_WARP_LOG - 1 :0] RAM2DDR3_ldstWarp;
	reg [`SIZE_REGFILE_BR - 1 :0] RAM2DDR3_ldstReg;
	reg load;
	reg store;
	always @ ( posedge clk)
	begin
		if(reset)
		begin
			InfoRamInfo <= 0;
			InfoRamAddr <= 0;
			InfoRamData <= 0;
			RAM2DDR3_mask <= 0;
			RAM2DDR3_din <= 0;
			RAM2DDR3_we <= 0;
			RAM2DDR3_ldstWarp <= 0;
			RAM2DDR3_ldstReg <= 0;
			lane_mask <= 0;	
			load <= 0;
			store <= 0;
			out_mask <= 0;
			RAM2DDR3_addr_o <= 0;
			RAM2DDR3_mask_o <= 0;
			RAM2DDR3_din_o <= 0;
			RAM2DDR3_we_o <= 0;
			RAM2DDR3_ldstWarp_o <= 0;
			RAM2DDR3_ldstReg_o <= 0;
			load_o <= 0;
			store_o <= 0;
			LSUOut_working <= 0;
			load_o_pre <= 0;
			store_o_pre <= 0;
			RAM2DDR3_addr_o_pre <= 0;
			SAME <= 0;
		end
		else if(~stall_i)
		begin
			if(RAM_Out)
			begin
			out_mask <= InfoRamInfo_o[`SIZE_CORE + `NUM_WARP_LOG + `SIZE_REGFILE_BR + 2:`NUM_WARP_LOG + `SIZE_REGFILE_BR + 3];
			lane_mask <= InfoRamInfo_o[`SIZE_CORE + `NUM_WARP_LOG + `SIZE_REGFILE_BR + 2:`NUM_WARP_LOG + `SIZE_REGFILE_BR + 3];
			InfoRamInfo <= InfoRamInfo_o;
			InfoRamAddr <= InfoRamAddr_o;
			InfoRamData <= InfoRamData_o;	
			RAM2DDR3_we <= InfoRamInfo_o[0];
			LSUOut_working <= 1;

			load <= InfoRamInfo_o[1];
			store <= InfoRamInfo_o[0];
			RAM2DDR3_ldstWarp <= InfoRamInfo_o[`NUM_WARP_LOG + `SIZE_REGFILE_BR + 2 : `SIZE_REGFILE_BR + 3];
			RAM2DDR3_ldstReg <= InfoRamInfo_o[`SIZE_REGFILE_BR + 2 : 3];
			load_o <= 0;
			store_o <= 0;
			end			
			else if( SegNum == 0 & LSUOut_working & ~DDR3OutPacketWorking_i & ~DDR3_n_rdy)
			begin
				LSUOut_working <= 0;
				RAM2DDR3_mask_o <= RAM2DDR3_mask;
				RAM2DDR3_din_o <= RAM2DDR3_din;
				RAM2DDR3_addr_o <= RAM2DDR3_addr;
				RAM2DDR3_we_o <= RAM2DDR3_we;
				load_o <= load;
				store_o <= RAM2DDR3_we;
				RAM2DDR3_we_o <= store;
				RAM2DDR3_ldstWarp_o <= RAM2DDR3_ldstWarp;
				RAM2DDR3_ldstReg_o <= RAM2DDR3_ldstReg;
				lane_mask_o <= lane_mask;
				InfoRamAddr_o_o <= InfoRamAddr;
				load_o_pre <= load;
				store_o_pre <= store;
				RAM2DDR3_addr_o_pre <= RAM2DDR3_addr_o;
			end			
			else if(LSUOut_working)
			begin
				out_mask[FirstOne] <= 0;
				case(offset)
				5'b00000:	begin RAM2DDR3_mask[0 + 3 : 0] <= 4'b1111;
				RAM2DDR3_din[0 * 8 + 31 : 0 * 8] <= din; end
				5'b00001:	begin RAM2DDR3_mask[1 + 3 : 1] <= 4'b1111;
				RAM2DDR3_din[1 * 8 + 31 : 1 * 8] <= din; end
				5'b00010:	begin RAM2DDR3_mask[2 + 3 : 2] <= 4'b1111;
				RAM2DDR3_din[2 * 8 + 31 : 2 * 8] <= din; end
				5'b00011:	begin RAM2DDR3_mask[3 + 3 : 3] <= 4'b1111;
				RAM2DDR3_din[3 * 8 + 31 : 3 * 8] <= din; end
				5'b00100:	begin RAM2DDR3_mask[4 + 3 : 4] <= 4'b1111;
				RAM2DDR3_din[4 * 8 + 31 : 4 * 8] <= din; end
				5'b00101:	begin RAM2DDR3_mask[5 + 3 : 5] <= 4'b1111;
				RAM2DDR3_din[5 * 8 + 31 : 5 * 8] <= din; end
				5'b00110:	begin RAM2DDR3_mask[6 + 3 : 6] <= 4'b1111;
				RAM2DDR3_din[6 * 8 + 31 : 6 * 8] <= din; end
				5'b00111:	begin RAM2DDR3_mask[7 + 3 : 7] <= 4'b1111;
				RAM2DDR3_din[7 * 8 + 31 : 7 * 8] <= din; end
				5'b01000:	begin RAM2DDR3_mask[8 + 3 : 8] <= 4'b1111;
				RAM2DDR3_din[8 * 8 + 31 : 8 * 8] <= din; end
				5'b01001:	begin RAM2DDR3_mask[9 + 3 : 9] <= 4'b1111;
				RAM2DDR3_din[9 * 8 + 31 : 9 * 8] <= din; end
				5'b01010:	begin RAM2DDR3_mask[10 + 3 : 10] <= 4'b1111;
				RAM2DDR3_din[10 * 8 + 31 : 10 * 8] <= din; end
				5'b01011:	begin RAM2DDR3_mask[11 + 3 : 11] <= 4'b1111;
				RAM2DDR3_din[11 * 8 + 31 : 11 * 8] <= din; end
				5'b01100:	begin RAM2DDR3_mask[12 + 3 : 12] <= 4'b1111;
				RAM2DDR3_din[12 * 8 + 31 : 12 * 8] <= din; end
				5'b01101:	begin RAM2DDR3_mask[13 + 3 : 13] <= 4'b1111;
				RAM2DDR3_din[13 * 8 + 31 : 13 * 8] <= din; end
				5'b01110:	begin RAM2DDR3_mask[14 + 3 : 14] <= 4'b1111;
				RAM2DDR3_din[14 * 8 + 31 : 14 * 8] <= din; end
				5'b01111:	begin RAM2DDR3_mask[15 + 3 : 15] <= 4'b1111;
				RAM2DDR3_din[15 * 8 + 31 : 15 * 8] <= din; end
				5'b10000:	begin RAM2DDR3_mask[16 + 3 : 16] <= 4'b1111;
				RAM2DDR3_din[16 * 8 + 31 : 16 * 8] <= din; end
				5'b10001:	begin RAM2DDR3_mask[17 + 3 : 17] <= 4'b1111;
				RAM2DDR3_din[17 * 8 + 31 : 17 * 8] <= din; end
				5'b10010:	begin RAM2DDR3_mask[18 + 3 : 18] <= 4'b1111;
				RAM2DDR3_din[18 * 8 + 31 : 18 * 8] <= din; end
				5'b10011:	begin RAM2DDR3_mask[19 + 3 : 19] <= 4'b1111;
				RAM2DDR3_din[19 * 8 + 31 : 19 * 8] <= din; end
				5'b10100:	begin RAM2DDR3_mask[20 + 3 : 20] <= 4'b1111;
				RAM2DDR3_din[20 * 8 + 31 : 20 * 8] <= din; end
				5'b10101:	begin RAM2DDR3_mask[21 + 3 : 21] <= 4'b1111;
				RAM2DDR3_din[21 * 8 + 31 : 21 * 8] <= din; end
				5'b10110:	begin RAM2DDR3_mask[22 + 3 : 22] <= 4'b1111;
				RAM2DDR3_din[22 * 8 + 31 : 22 * 8] <= din; end
				5'b10111:	begin RAM2DDR3_mask[23 + 3 : 23] <= 4'b1111;
				RAM2DDR3_din[23 * 8 + 31 : 23 * 8] <= din; end
				5'b11000:	begin RAM2DDR3_mask[24 + 3 : 24] <= 4'b1111;
				RAM2DDR3_din[24 * 8 + 31 : 24 * 8] <= din; end
				5'b11001:	begin RAM2DDR3_mask[25 + 3 : 25] <= 4'b1111;
				RAM2DDR3_din[25 * 8 + 31 : 25 * 8] <= din; end
				5'b11010:	begin RAM2DDR3_mask[26 + 3 : 26] <= 4'b1111;
				RAM2DDR3_din[26 * 8 + 31 : 26 * 8] <= din; end
				5'b11011:	begin RAM2DDR3_mask[27 + 3 : 27] <= 4'b1111;
				RAM2DDR3_din[27 * 8 + 31 : 27 * 8] <= din; end
				5'b11100:	begin RAM2DDR3_mask[28 + 3 : 28] <= 4'b1111;
				RAM2DDR3_din[28 * 8 + 31 : 28 * 8] <= din; end
				5'b11101:	begin RAM2DDR3_mask[29 + 3 : 29] <= 4'b1111;
				RAM2DDR3_din[29 * 8 + 31 : 29 * 8] <= din; end
				5'b11110:	begin RAM2DDR3_mask[30 + 3 : 30] <= 4'b1111;
				RAM2DDR3_din[30 * 8 + 31 : 30 * 8] <= din; end
				5'b11111:	begin RAM2DDR3_mask[31 + 3 : 31] <= 4'b1111;
				RAM2DDR3_din[31 * 8 + 31 : 31 * 8] <= din; end
				endcase
			end
			else if(DDR3_rdy | DDR3_w_rdy) begin
			/*InfoRamInfo <= 0;
			InfoRamAddr <= 0;
			InfoRamData <= 0;
			RAM2DDR3_addr <= 0;
			RAM2DDR3_mask <= 0;
			RAM2DDR3_din <= 0;
			RAM2DDR3_we <= 0;
			RAM2DDR3_ldstWarp <= 0;
			RAM2DDR3_ldstReg <= 0;
			lane_mask <= 0;	
			load <= 0;
			store <= 0;
			out_mask <= 0; 
			RAM2DDR3_addr_o <= 0;
			RAM2DDR3_mask_o <= 0;
			RAM2DDR3_din_o <= 0;
			RAM2DDR3_we_o <= 0;
			RAM2DDR3_ldstWarp_o <= 0;
			RAM2DDR3_ldstReg_o <= 0;*/
			load_o <= 0;
			store_o <= 0;
			//RAM2DDR3_we_o <= 0;
			/*lane_mask_o <= 0;*/
			end
			
			if((load_o_pre == load )&( store_o_pre == store )&( RAM2DDR3_addr_o == RAM2DDR3_addr) & ~DDR3_n_rdy)
				SAME <= 1;
			else 
				SAME <= 0;
		end	
		
	end
	
	FirstOne firstOne(
	.Mask(out_mask ),
	.FirstOne(FirstOne)
	);
	

endmodule
 
module FirstOne(
		input [`SIZE_CORE - 1 :0] Mask,
		output [`SIZE_CORE_LOG - 1 :0] FirstOne
); 
	wire [`SIZE_CORE - 1 :0] Pre;
	assign Pre[0] = Mask[0];
	assign Pre[1] = Mask[1] | Mask[0];
	assign Pre[2] = Mask[2] | Mask[1]| Mask[0];
	assign Pre[3] = Mask[3] | Mask[2]| Mask[1]| Mask[0];
	assign Pre[4] = Mask[4] | Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[5] = Mask[5] | Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[6] = Mask[6] | Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[7] = Mask[7] | Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[8] = Mask[8] | Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[9] = Mask[9] | Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[10] = Mask[10] | Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[11] = Mask[11] | Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[12] = Mask[12] | Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[13] = Mask[13] | Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[14] = Mask[14] | Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[15] = Mask[15] | Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[16] = Mask[16] | Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[17] = Mask[17] | Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[18] = Mask[18] | Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[19] = Mask[19] | Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[20] = Mask[20] | Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[21] = Mask[21] | Mask[20]| Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[22] = Mask[22] | Mask[21]| Mask[20]| Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[23] = Mask[23] | Mask[22]| Mask[21]| Mask[20]| Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[24] = Mask[24] | Mask[23]| Mask[22]| Mask[21]| Mask[20]| Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[25] = Mask[25] | Mask[24]| Mask[23]| Mask[22]| Mask[21]| Mask[20]| Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[26] = Mask[26] | Mask[25]| Mask[24]| Mask[23]| Mask[22]| Mask[21]| Mask[20]| Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[27] = Mask[27] | Mask[26]| Mask[25]| Mask[24]| Mask[23]| Mask[22]| Mask[21]| Mask[20]| Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[28] = Mask[28] | Mask[27]| Mask[26]| Mask[25]| Mask[24]| Mask[23]| Mask[22]| Mask[21]| Mask[20]| Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[29] = Mask[29] | Mask[28]| Mask[27]| Mask[26]| Mask[25]| Mask[24]| Mask[23]| Mask[22]| Mask[21]| Mask[20]| Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[30] = Mask[30] | Mask[29]| Mask[28]| Mask[27]| Mask[26]| Mask[25]| Mask[24]| Mask[23]| Mask[22]| Mask[21]| Mask[20]| Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];
	assign Pre[31] = Mask[31] | Mask[30]| Mask[29]| Mask[28]| Mask[27]| Mask[26]| Mask[25]| Mask[24]| Mask[23]| Mask[22]| Mask[21]| Mask[20]| Mask[19]| Mask[18]| Mask[17]| Mask[16]| Mask[15]| Mask[14]| Mask[13]| Mask[12]| Mask[11]| Mask[10]| Mask[9]| Mask[8]| Mask[7]| Mask[6]| Mask[5]| Mask[4]| Mask[3]| Mask[2]| Mask[1]| Mask[0];

	assign FirstOne = 32-Pre[0]-Pre[1]-Pre[2]-Pre[3]-Pre[4]-Pre[5]-Pre[6]-Pre[7]-Pre[8]-Pre[9]-Pre[10]-Pre[11]-Pre[12]-Pre[13]-Pre[14]-Pre[15]-Pre[16]-Pre[17]-Pre[18]-Pre[19]-Pre[20]-Pre[21]-Pre[22]-Pre[23]-Pre[24]-Pre[25]-Pre[26]-Pre[27]-Pre[28]-Pre[29]-Pre[30]-Pre[31];
endmodule