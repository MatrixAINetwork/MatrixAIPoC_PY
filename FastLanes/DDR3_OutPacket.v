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
`define SIZE_SM_LOG 2
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:42:48 05/13/2013 
// Design Name: 
// Module Name:    DDR3_OutPacket 
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
module DDR3_OutPacket( 
			input clk,
			input reset,
			input stall_i,
			
			input [`SIZE_CORE * `SIZE_ADDR - 1 :0 ] InfoRamAddr_i,
			input [`SIZE_CORE - 1 : 0 ] lane_mask_i,
			input [`NUM_WARP_LOG - 1 :0] RAM2DDR3_ldstWarp_i,
			input [`SIZE_REGFILE_BR - 1 :0] RAM2DDR3_ldstReg_i,
			input load_i,
			input [511:0] dout_i,
			input rdy,				//read ready
			
			output reg [`NUM_WARP_LOG - 1 : 0] loadWarp_o,
			output reg loadPacketValid_o,
			output reg [`SIZE_CORE - 1 : 0] loadMask_o,		
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane0_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane1_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane2_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane3_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane4_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane5_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane6_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane7_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane8_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane9_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane10_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane11_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane12_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane13_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane14_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane15_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane16_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane17_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane18_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane19_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane20_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane21_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane22_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane23_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane24_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane25_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane26_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane27_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane28_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane29_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane30_o,
			output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane31_o,
			output reg working
    );
	 reg tempWaiting;
	assign DDR3OutPacketValid_o =  loadPacketValid_o;
	wire [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane;
	reg waitingDDR3;
	reg [`SIZE_CORE * `SIZE_ADDR - 1 :0 ] InfoRamAddr;
	reg [`SIZE_REGFILE_BR - 1 :0 ] RAM2DDR3_ldstReg;
	reg [`SIZE_CORE - 1 : 0 ] out_mask;
	wire [`SIZE_CORE_LOG - 1 :0] FirstOne;
	reg [511:0] dout;
	reg [`SIZE_CORE - 1 :0] lane_mask;
	wire [`SIZE_CORE_LOG :0] SegNum;
	assign SegNum = out_mask[0]+out_mask[1]+out_mask[2]+out_mask[3]+out_mask[4]+out_mask[5]+out_mask[6]+out_mask[7]+out_mask[8]+out_mask[9]
								+out_mask[10]+out_mask[11]+out_mask[12]+out_mask[13]+out_mask[14]+out_mask[15]+out_mask[16]+out_mask[17]+out_mask[18]+
								out_mask[19]+out_mask[20]+out_mask[21]+out_mask[22]+out_mask[23]+out_mask[24]+out_mask[25]+out_mask[26]+out_mask[27]+
								out_mask[28]+out_mask[29]+out_mask[30]+out_mask[31];
	
	reg [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset0;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset1;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset2;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset3;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset4;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset5;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset6;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset7;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset8;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset9;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset10;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset11;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset12;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset13;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset14;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset15;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset16;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset17;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset18;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset19;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset20;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset21;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset22;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset23;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset24;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset25;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset26;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset27;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset28;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset29;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset30;
	wire [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset31;

	assign offset0 = InfoRamAddr[`SIZE_SEGMENT_BYTES_LOG - 1:0];
	assign offset1 = InfoRamAddr[`SIZE_ADDR + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR];
	assign offset2 = InfoRamAddr[`SIZE_ADDR * 2 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 2];
	assign offset3 = InfoRamAddr[`SIZE_ADDR * 3 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 3];
	assign offset4 = InfoRamAddr[`SIZE_ADDR * 4 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 4];
	assign offset5 = InfoRamAddr[`SIZE_ADDR * 5 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 5];
	assign offset6 = InfoRamAddr[`SIZE_ADDR * 6 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 6];
	assign offset7 = InfoRamAddr[`SIZE_ADDR * 7 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 7];
	assign offset8 = InfoRamAddr[`SIZE_ADDR * 8 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 8];
	assign offset9 = InfoRamAddr[`SIZE_ADDR * 9 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 9];
	assign offset10 = InfoRamAddr[`SIZE_ADDR * 10 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 10];
	assign offset11 = InfoRamAddr[`SIZE_ADDR * 11 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 11];
	assign offset12 = InfoRamAddr[`SIZE_ADDR * 12 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 12];
	assign offset13 = InfoRamAddr[`SIZE_ADDR * 13 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 13];
	assign offset14 = InfoRamAddr[`SIZE_ADDR * 14 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 14];
	assign offset15 = InfoRamAddr[`SIZE_ADDR * 15 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 15];
	assign offset16 = InfoRamAddr[`SIZE_ADDR * 16 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 16];
	assign offset17 = InfoRamAddr[`SIZE_ADDR * 17 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 17];
	assign offset18 = InfoRamAddr[`SIZE_ADDR * 18 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 18];
	assign offset19 = InfoRamAddr[`SIZE_ADDR * 19 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 19];
	assign offset20 = InfoRamAddr[`SIZE_ADDR * 20 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 20];
	assign offset21 = InfoRamAddr[`SIZE_ADDR * 21 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 21];
	assign offset22 = InfoRamAddr[`SIZE_ADDR * 22 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 22];
	assign offset23 = InfoRamAddr[`SIZE_ADDR * 23 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 23];
	assign offset24 = InfoRamAddr[`SIZE_ADDR * 24 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 24];
	assign offset25 = InfoRamAddr[`SIZE_ADDR * 25 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 25];
	assign offset26 = InfoRamAddr[`SIZE_ADDR * 26 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 26];
	assign offset27 = InfoRamAddr[`SIZE_ADDR * 27 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 27];
	assign offset28 = InfoRamAddr[`SIZE_ADDR * 28 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 28];
	assign offset29 = InfoRamAddr[`SIZE_ADDR * 29 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 29];
	assign offset30 = InfoRamAddr[`SIZE_ADDR * 30 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 30];
	assign offset31 = InfoRamAddr[`SIZE_ADDR * 31 + `SIZE_SEGMENT_BYTES_LOG - 1	:	`SIZE_ADDR* 31];
	
	reg loadMask;
	always @(posedge clk)
	begin
		if(reset)
		begin
			waitingDDR3 <= 0;
			loadPacketValid_o <= 0;
			loadWarp_o <= 0;
			working <= 0;
			loadMask_o <= 0;					
			loadPacketLane0_o <= 0;
			loadPacketLane1_o <= 0;
			loadPacketLane2_o <= 0;
			loadPacketLane3_o <= 0;
			loadPacketLane4_o <= 0;
			loadPacketLane5_o <= 0;
			loadPacketLane6_o <= 0;
			loadPacketLane7_o <= 0;
			loadPacketLane8_o <= 0;
			loadPacketLane9_o <= 0;
			loadPacketLane10_o <= 0;
			loadPacketLane11_o <= 0;
			loadPacketLane12_o <= 0;
			loadPacketLane13_o <= 0;
			loadPacketLane14_o <= 0;
			loadPacketLane15_o <= 0;
			loadPacketLane16_o <= 0;
			loadPacketLane17_o <= 0;
			loadPacketLane18_o <= 0;
			loadPacketLane19_o <= 0;
			loadPacketLane20_o <= 0;
			loadPacketLane21_o <= 0;
			loadPacketLane22_o <= 0;
			loadPacketLane23_o <= 0;
			loadPacketLane24_o <= 0;
			loadPacketLane25_o <= 0;
			loadPacketLane26_o <= 0;
			loadPacketLane27_o <= 0;
			loadPacketLane28_o <= 0;
			loadPacketLane29_o <= 0;
			loadPacketLane30_o <= 0;
			loadPacketLane31_o <= 0;
			InfoRamAddr <= 0;
			RAM2DDR3_ldstReg <= 0;
			out_mask <= 0;
			lane_mask <= 0;
			dout <= 0;
			tempWaiting <= 0;
		end
		else if(~stall_i)
		begin
			if(load_i & ~waitingDDR3 & ~working & ~tempWaiting)
			begin
				waitingDDR3 <= 1;	
				loadPacketValid_o <= 0;
				loadWarp_o <= RAM2DDR3_ldstWarp_i;
				loadMask_o <= lane_mask_i;
				InfoRamAddr <= InfoRamAddr_i;				
				RAM2DDR3_ldstReg <= RAM2DDR3_ldstReg_i;
				out_mask <= lane_mask_i;
			end
			else if(waitingDDR3 & rdy & ~working)
			begin	
				working <= 1;
				waitingDDR3 <= 0;	
				dout <= dout_i;
			end	
			else if(tempWaiting)
			begin 	
				tempWaiting <= 0;
			end
			else if(SegNum == 0 & working)
			begin
				loadPacketValid_o <= 1;
				working <= 0;
				tempWaiting <= 1;
			end
			else if(~waitingDDR3 & working)
			begin
				loadPacketValid_o <= 0;
				out_mask[FirstOne] <= 0;
				case(FirstOne)
				5'b00000: loadPacketLane0_o <= loadPacketLane;
				5'b00001: loadPacketLane1_o <= loadPacketLane;
				5'b00010: loadPacketLane2_o <= loadPacketLane;
				5'b00011: loadPacketLane3_o <= loadPacketLane;
				5'b00100: loadPacketLane4_o <= loadPacketLane;
				5'b00101: loadPacketLane5_o <= loadPacketLane;
				5'b00110: loadPacketLane6_o <= loadPacketLane;
				5'b00111: loadPacketLane7_o <= loadPacketLane;
				5'b01000: loadPacketLane8_o <= loadPacketLane;
				5'b01001: loadPacketLane9_o <= loadPacketLane;
				5'b01010: loadPacketLane10_o <= loadPacketLane;
				5'b01011: loadPacketLane11_o <= loadPacketLane;
				5'b01100: loadPacketLane12_o <= loadPacketLane;
				5'b01101: loadPacketLane13_o <= loadPacketLane;
				5'b01110: loadPacketLane14_o <= loadPacketLane;
				5'b01111: loadPacketLane15_o <= loadPacketLane;
				5'b10000: loadPacketLane16_o <= loadPacketLane;
				5'b10001: loadPacketLane17_o <= loadPacketLane;
				5'b10010: loadPacketLane18_o <= loadPacketLane;
				5'b10011: loadPacketLane19_o <= loadPacketLane;
				5'b10100: loadPacketLane20_o <= loadPacketLane;
				5'b10101: loadPacketLane21_o <= loadPacketLane;
				5'b10110: loadPacketLane22_o <= loadPacketLane;
				5'b10111: loadPacketLane23_o <= loadPacketLane;
				5'b11000: loadPacketLane24_o <= loadPacketLane;
				5'b11001: loadPacketLane25_o <= loadPacketLane;
				5'b11010: loadPacketLane26_o <= loadPacketLane;
				5'b11011: loadPacketLane27_o <= loadPacketLane;
				5'b11100: loadPacketLane28_o <= loadPacketLane;
				5'b11101: loadPacketLane29_o <= loadPacketLane;
				5'b11110: loadPacketLane30_o <= loadPacketLane;
				5'b11111: loadPacketLane31_o <= loadPacketLane;		
				endcase
			end
			else loadPacketValid_o <= 0;
		end
	
	end
	always @(*)
	begin
			case(FirstOne)
			5'b00000:begin offset <= offset0;loadMask <= out_mask[0];end
			5'b00001:begin offset <= offset1;loadMask <= out_mask[1];end
			5'b00010:begin offset <= offset2;loadMask <= out_mask[2];end
			5'b00011:begin offset <= offset3;loadMask <= out_mask[3];end
			5'b00100:begin offset <= offset4;loadMask <= out_mask[4];end
			5'b00101:begin offset <= offset5;loadMask <= out_mask[5];end
			5'b00110:begin offset <= offset6;loadMask <= out_mask[6];end
			5'b00111:begin offset <= offset7;loadMask <= out_mask[7];end
			5'b01000:begin offset <= offset8;loadMask <= out_mask[8];end
			5'b01001:begin offset <= offset9;loadMask <= out_mask[9];end
			5'b01010:begin offset <= offset10;loadMask <= out_mask[10];end
			5'b01011:begin offset <= offset11;loadMask <= out_mask[11];end
			5'b01100:begin offset <= offset12;loadMask <= out_mask[12];end
			5'b01101:begin offset <= offset13;loadMask <= out_mask[13];end
			5'b01110:begin offset <= offset14;loadMask <= out_mask[14];end
			5'b01111:begin offset <= offset15;loadMask <= out_mask[15];end
			5'b10000:begin offset <= offset16;loadMask <= out_mask[16];end
			5'b10001:begin offset <= offset17;loadMask <= out_mask[17];end
			5'b10010:begin offset <= offset18;loadMask <= out_mask[18];end
			5'b10011:begin offset <= offset19;loadMask <= out_mask[19];end
			5'b10100:begin offset <= offset20;loadMask <= out_mask[20];end
			5'b10101:begin offset <= offset21;loadMask <= out_mask[21];end
			5'b10110:begin offset <= offset22;loadMask <= out_mask[22];end
			5'b10111:begin offset <= offset23;loadMask <= out_mask[23];end
			5'b11000:begin offset <= offset24;loadMask <= out_mask[24];end
			5'b11001:begin offset <= offset25;loadMask <= out_mask[25];end
			5'b11010:begin offset <= offset26;loadMask <= out_mask[26];end
			5'b11011:begin offset <= offset27;loadMask <= out_mask[27];end
			5'b11100:begin offset <= offset28;loadMask <= out_mask[28];end
			5'b11101:begin offset <= offset29;loadMask <= out_mask[29];end
			5'b11110:begin offset <= offset30;loadMask <= out_mask[30];end
			5'b11111:begin offset <= offset31;loadMask <= out_mask[31];end			
			endcase
	end
	Packet Packet(
				.offset(offset),
				.RAM2DDR3_ldstReg(RAM2DDR3_ldstReg),
				.dout(dout),
				.loadMask(loadMask),
				.loadPacketLane(loadPacketLane)
				);

	FirstOne firstOne(
	.Mask(out_mask ),
	.FirstOne(FirstOne)
	);
endmodule


module Packet(
	
	input [`SIZE_SEGMENT_BYTES_LOG - 1 :0] offset,
	input [`SIZE_REGFILE_BR - 1 :0] RAM2DDR3_ldstReg,
	input [511:0] dout,
	input loadMask,
	
	output reg [`SIZE_DATA + `SIZE_REGFILE_BR - 1 : 0] loadPacketLane
	);
	always @(*)
	begin
		case(offset)
				5'b00000:loadPacketLane = {loadMask?dout[0 * 8 + `SIZE_DATA - 1 :0 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b00001:loadPacketLane = {loadMask?dout[1 * 8 + `SIZE_DATA - 1 :2 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b00010:loadPacketLane = {loadMask?dout[2 * 8 + `SIZE_DATA - 1 :2 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b00011:loadPacketLane = {loadMask?dout[3 * 8 + `SIZE_DATA - 1 :3 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};				
				5'b00100:loadPacketLane = {loadMask?dout[4 * 8 + `SIZE_DATA - 1 :4 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b00101:loadPacketLane = {loadMask?dout[5 * 8 + `SIZE_DATA - 1 :5 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b00110:loadPacketLane = {loadMask?dout[6 * 8 + `SIZE_DATA - 1 :6 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b00111:loadPacketLane = {loadMask?dout[7 * 8 + `SIZE_DATA - 1 :7 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b01000:loadPacketLane = {loadMask?dout[8 * 8 + `SIZE_DATA - 1 :8 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b01001:loadPacketLane = {loadMask?dout[9 * 8 + `SIZE_DATA - 1 :9 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b01010:loadPacketLane = {loadMask?dout[10 * 8 + `SIZE_DATA - 1 :10 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b01011:loadPacketLane = {loadMask?dout[11 * 8 + `SIZE_DATA - 1 :11 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b01100:loadPacketLane = {loadMask?dout[12 * 8 + `SIZE_DATA - 1 :12 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b01101:loadPacketLane = {loadMask?dout[13 * 8 + `SIZE_DATA - 1 :13 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b01110:loadPacketLane = {loadMask?dout[14 * 8 + `SIZE_DATA - 1 :14 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b01111:loadPacketLane = {loadMask?dout[15 * 8 + `SIZE_DATA - 1 :15 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b10000:loadPacketLane = {loadMask?dout[16 * 8 + `SIZE_DATA - 1 :16 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b10001:loadPacketLane = {loadMask?dout[17 * 8 + `SIZE_DATA - 1 :17 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b10010:loadPacketLane = {loadMask?dout[18 * 8 + `SIZE_DATA - 1 :17 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b10011:loadPacketLane = {loadMask?dout[19 * 8 + `SIZE_DATA - 1 :19 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b10100:loadPacketLane = {loadMask?dout[20 * 8 + `SIZE_DATA - 1 :20 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b10101:loadPacketLane = {loadMask?dout[21 * 8 + `SIZE_DATA - 1 :21 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b10110:loadPacketLane = {loadMask?dout[22 * 8 + `SIZE_DATA - 1 :22 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b10111:loadPacketLane = {loadMask?dout[23 * 8 + `SIZE_DATA - 1 :23 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b11000:loadPacketLane = {loadMask?dout[24 * 8 + `SIZE_DATA - 1 :24 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b11001:loadPacketLane = {loadMask?dout[25 * 8 + `SIZE_DATA - 1 :25 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b11010:loadPacketLane = {loadMask?dout[26 * 8 + `SIZE_DATA - 1 :26 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b11011:loadPacketLane = {loadMask?dout[27 * 8 + `SIZE_DATA - 1 :27 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b11100:loadPacketLane = {loadMask?dout[28 * 8 + `SIZE_DATA - 1 :28 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b11101:loadPacketLane = {loadMask?dout[29 * 8 + `SIZE_DATA - 1 :29 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b11110:loadPacketLane = {loadMask?dout[30 * 8 + `SIZE_DATA - 1 :30 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				5'b11111:loadPacketLane = {loadMask?dout[31 * 8 + `SIZE_DATA - 1 :31 * 8] : `SIZE_DATA'b0 ,
								RAM2DDR3_ldstReg};
				endcase
	end

				
	endmodule
	
	
	