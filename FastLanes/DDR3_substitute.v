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

`define SIZE_MEM 1024*256
`define SIZE_MEM_LOG 18
`define SIZE_IO 512
`define SIZE_MSK 64

module DDR3_substitute(
			input clk,
			input reset,
			
			input [`SIZE_MEM_LOG-1:0] addr,		//Read address
			input [`SIZE_MSK-1:0] mask,
			input [`SIZE_IO-1:0] din,
			input we,				//write enable
					
			output [`SIZE_IO-1:0] dout,
			output reg rdy,				//read ready
			output reg w_rdy,			//write ready
			
			output initDone			//initDone <= 0 after reset; initDone <= 1 when initialization is done

);
	
	assign initDone = 1'b1;
	reg [`SIZE_MEM-1:0] preAddr;
	reg [5:0] count;
	
	always @(posedge clk) begin
		if(reset) begin
			count <= 0;
			w_rdy <= 0;
			rdy <= 0;
		end
		else begin
			preAddr <= addr;
			if(preAddr != addr) begin	//new task
				count <= 0;
				w_rdy <= 0;
				rdy <= 0;
			end
			else if(count >= 16) begin
				count <= 0;
				if(we == 1) w_rdy <= 1;
				else rdy <= 1;
			end
			else begin
				count <= count + 1;
			end			
		end
	end
	
	
	reg [7:0] dout_byte63;
	reg [7:0] dout_byte62;
	reg [7:0] dout_byte61;
	reg [7:0] dout_byte60;
	reg [7:0] dout_byte59;
	reg [7:0] dout_byte58;
	reg [7:0] dout_byte57;
	reg [7:0] dout_byte56;
	reg [7:0] dout_byte55;
	reg [7:0] dout_byte54;
	reg [7:0] dout_byte53;
	reg [7:0] dout_byte52;
	reg [7:0] dout_byte51;
	reg [7:0] dout_byte50;
	reg [7:0] dout_byte49;
	reg [7:0] dout_byte48;
	reg [7:0] dout_byte47;
	reg [7:0] dout_byte46;
	reg [7:0] dout_byte45;
	reg [7:0] dout_byte44;
	reg [7:0] dout_byte43;
	reg [7:0] dout_byte42;
	reg [7:0] dout_byte41;
	reg [7:0] dout_byte40;
	reg [7:0] dout_byte39;
	reg [7:0] dout_byte38;
	reg [7:0] dout_byte37;
	reg [7:0] dout_byte36;
	reg [7:0] dout_byte35;
	reg [7:0] dout_byte34;
	reg [7:0] dout_byte33;
	reg [7:0] dout_byte32;
	reg [7:0] dout_byte31;
	reg [7:0] dout_byte30;
	reg [7:0] dout_byte29;
	reg [7:0] dout_byte28;
	reg [7:0] dout_byte27;
	reg [7:0] dout_byte26;
	reg [7:0] dout_byte25;
	reg [7:0] dout_byte24;
	reg [7:0] dout_byte23;
	reg [7:0] dout_byte22;
	reg [7:0] dout_byte21;
	reg [7:0] dout_byte20;
	reg [7:0] dout_byte19;
	reg [7:0] dout_byte18;
	reg [7:0] dout_byte17;
	reg [7:0] dout_byte16;
	reg [7:0] dout_byte15;
	reg [7:0] dout_byte14;
	reg [7:0] dout_byte13;
	reg [7:0] dout_byte12;
	reg [7:0] dout_byte11;
	reg [7:0] dout_byte10;
	reg [7:0] dout_byte9;
	reg [7:0] dout_byte8;
	reg [7:0] dout_byte7;
	reg [7:0] dout_byte6;
	reg [7:0] dout_byte5;
	reg [7:0] dout_byte4;
	reg [7:0] dout_byte3;
	reg [7:0] dout_byte2;
	reg [7:0] dout_byte1;
	reg [7:0] dout_byte0;
	
	assign dout = {
						dout_byte63,
						dout_byte62,
						dout_byte61,
						dout_byte60,
						dout_byte59,
						dout_byte58,
						dout_byte57,
						dout_byte56,
						dout_byte55,
						dout_byte54,
						dout_byte53,
						dout_byte52,
						dout_byte51,
						dout_byte50,
						dout_byte49,
						dout_byte48,
						dout_byte47,
						dout_byte46,
						dout_byte45,
						dout_byte44,
						dout_byte43,
						dout_byte42,
						dout_byte41,
						dout_byte40,
						dout_byte39,
						dout_byte38,
						dout_byte37,
						dout_byte36,
						dout_byte35,
						dout_byte34,
						dout_byte33,
						dout_byte32,
						dout_byte31,
						dout_byte30,
						dout_byte29,
						dout_byte28,
						dout_byte27,
						dout_byte26,
						dout_byte25,
						dout_byte24,
						dout_byte23,
						dout_byte22,
						dout_byte21,
						dout_byte20,
						dout_byte19,
						dout_byte18,
						dout_byte17,
						dout_byte16,
						dout_byte15,
						dout_byte14,
						dout_byte13,
						dout_byte12,
						dout_byte11,
						dout_byte10,
						dout_byte9,
						dout_byte8,
						dout_byte7,
						dout_byte6,
						dout_byte5,
						dout_byte4,
						dout_byte3,
						dout_byte2,
						dout_byte1,
						dout_byte0
					};

	

	

	reg [7:0] sram [`SIZE_MEM-1:0];		//32M bit = 32bit*1024Reg*32Lane*32SM = 4194304 byte = 2^22 byte
	
	integer i;
	always @(posedge clk) begin
		if(reset == 1'b1) begin
			
			for(i=0;i<`SIZE_MEM;i=i+1) sram[i] <= i;
		end
		else begin
			if(we) begin
				if(mask[63]) sram[addr+63] <= din[64*8-1:63*8];
				if(mask[62]) sram[addr+62] <= din[63*8-1:62*8];
				if(mask[61]) sram[addr+61] <= din[62*8-1:61*8];
				if(mask[60]) sram[addr+60] <= din[61*8-1:60*8];
				if(mask[59]) sram[addr+59] <= din[60*8-1:59*8];
				if(mask[58]) sram[addr+58] <= din[59*8-1:58*8];
				if(mask[57]) sram[addr+57] <= din[58*8-1:57*8];
				if(mask[56]) sram[addr+56] <= din[57*8-1:56*8];
				if(mask[55]) sram[addr+55] <= din[56*8-1:55*8];
				if(mask[54]) sram[addr+54] <= din[55*8-1:54*8];
				if(mask[53]) sram[addr+53] <= din[54*8-1:53*8];
				if(mask[52]) sram[addr+52] <= din[53*8-1:52*8];
				if(mask[51]) sram[addr+51] <= din[52*8-1:51*8];
				if(mask[50]) sram[addr+50] <= din[51*8-1:50*8];
				if(mask[49]) sram[addr+49] <= din[50*8-1:49*8];
				if(mask[48]) sram[addr+48] <= din[49*8-1:48*8];
				if(mask[47]) sram[addr+47] <= din[48*8-1:47*8];
				if(mask[46]) sram[addr+46] <= din[47*8-1:46*8];
				if(mask[45]) sram[addr+45] <= din[46*8-1:45*8];
				if(mask[44]) sram[addr+44] <= din[45*8-1:44*8];
				if(mask[43]) sram[addr+43] <= din[44*8-1:43*8];
				if(mask[42]) sram[addr+42] <= din[43*8-1:42*8];
				if(mask[41]) sram[addr+41] <= din[42*8-1:41*8];
				if(mask[40]) sram[addr+40] <= din[41*8-1:40*8];
				if(mask[39]) sram[addr+39] <= din[40*8-1:39*8];
				if(mask[38]) sram[addr+38] <= din[39*8-1:38*8];
				if(mask[37]) sram[addr+37] <= din[38*8-1:37*8];
				if(mask[36]) sram[addr+36] <= din[37*8-1:36*8];
				if(mask[35]) sram[addr+35] <= din[36*8-1:35*8];
				if(mask[34]) sram[addr+34] <= din[35*8-1:34*8];
				if(mask[33]) sram[addr+33] <= din[34*8-1:33*8];
				if(mask[32]) sram[addr+32] <= din[33*8-1:32*8];
				if(mask[31]) sram[addr+31] <= din[32*8-1:31*8];
				if(mask[30]) sram[addr+30] <= din[31*8-1:30*8];
				if(mask[29]) sram[addr+29] <= din[30*8-1:29*8];
				if(mask[28]) sram[addr+28] <= din[29*8-1:28*8];
				if(mask[27]) sram[addr+27] <= din[28*8-1:27*8];
				if(mask[26]) sram[addr+26] <= din[27*8-1:26*8];
				if(mask[25]) sram[addr+25] <= din[26*8-1:25*8];
				if(mask[24]) sram[addr+24] <= din[25*8-1:24*8];
				if(mask[23]) sram[addr+23] <= din[24*8-1:23*8];
				if(mask[22]) sram[addr+22] <= din[23*8-1:22*8];
				if(mask[21]) sram[addr+21] <= din[22*8-1:21*8];
				if(mask[20]) sram[addr+20] <= din[21*8-1:20*8];
				if(mask[19]) sram[addr+19] <= din[20*8-1:19*8];
				if(mask[18]) sram[addr+18] <= din[19*8-1:18*8];
				if(mask[17]) sram[addr+17] <= din[18*8-1:17*8];
				if(mask[16]) sram[addr+16] <= din[17*8-1:16*8];
				if(mask[15]) sram[addr+15] <= din[16*8-1:15*8];
				if(mask[14]) sram[addr+14] <= din[15*8-1:14*8];
				if(mask[13]) sram[addr+13] <= din[14*8-1:13*8];
				if(mask[12]) sram[addr+12] <= din[13*8-1:12*8];
				if(mask[11]) sram[addr+11] <= din[12*8-1:11*8];
				if(mask[10]) sram[addr+10] <= din[11*8-1:10*8];
				if(mask[9]) sram[addr+9] <= din[10*8-1:9*8];
				if(mask[8]) sram[addr+8] <= din[9*8-1:8*8];
				if(mask[7]) sram[addr+7] <= din[8*8-1:7*8];
				if(mask[6]) sram[addr+6] <= din[7*8-1:6*8];
				if(mask[5]) sram[addr+5] <= din[6*8-1:5*8];
				if(mask[4]) sram[addr+4] <= din[5*8-1:4*8];
				if(mask[3]) sram[addr+3] <= din[4*8-1:3*8];
				if(mask[2]) sram[addr+2] <= din[3*8-1:2*8];
				if(mask[1]) sram[addr+1] <= din[2*8-1:1*8];
				if(mask[0]) sram[addr+0] <= din[1*8-1:0*8];
			end
			//else begin
				dout_byte63 <= sram[addr+63];
				dout_byte62 <= sram[addr+62];
				dout_byte61 <= sram[addr+61];
				dout_byte60 <= sram[addr+60];
				dout_byte59 <= sram[addr+59];
				dout_byte58 <= sram[addr+58];
				dout_byte57 <= sram[addr+57];
				dout_byte56 <= sram[addr+56];
				dout_byte55 <= sram[addr+55];
				dout_byte54 <= sram[addr+54];
				dout_byte53 <= sram[addr+53];
				dout_byte52 <= sram[addr+52];
				dout_byte51 <= sram[addr+51];
				dout_byte50 <= sram[addr+50];
				dout_byte49 <= sram[addr+49];
				dout_byte48 <= sram[addr+48];
				dout_byte47 <= sram[addr+47];
				dout_byte46 <= sram[addr+46];
				dout_byte45 <= sram[addr+45];
				dout_byte44 <= sram[addr+44];
				dout_byte43 <= sram[addr+43];
				dout_byte42 <= sram[addr+42];
				dout_byte41 <= sram[addr+41];
				dout_byte40 <= sram[addr+40];
				dout_byte39 <= sram[addr+39];
				dout_byte38 <= sram[addr+38];
				dout_byte37 <= sram[addr+37];
				dout_byte36 <= sram[addr+36];
				dout_byte35 <= sram[addr+35];
				dout_byte34 <= sram[addr+34];
				dout_byte33 <= sram[addr+33];
				dout_byte32 <= sram[addr+32];
				dout_byte31 <= sram[addr+31];
				dout_byte30 <= sram[addr+30];
				dout_byte29 <= sram[addr+29];
				dout_byte28 <= sram[addr+28];
				dout_byte27 <= sram[addr+27];
				dout_byte26 <= sram[addr+26];
				dout_byte25 <= sram[addr+25];
				dout_byte24 <= sram[addr+24];
				dout_byte23 <= sram[addr+23];
				dout_byte22 <= sram[addr+22];
				dout_byte21 <= sram[addr+21];
				dout_byte20 <= sram[addr+20];
				dout_byte19 <= sram[addr+19];
				dout_byte18 <= sram[addr+18];
				dout_byte17 <= sram[addr+17];
				dout_byte16 <= sram[addr+16];
				dout_byte15 <= sram[addr+15];
				dout_byte14 <= sram[addr+14];
				dout_byte13 <= sram[addr+13];
				dout_byte12 <= sram[addr+12];
				dout_byte11 <= sram[addr+11];
				dout_byte10 <= sram[addr+10];
				dout_byte9 <= sram[addr+9];
				dout_byte8 <= sram[addr+8];
				dout_byte7 <= sram[addr+7];
				dout_byte6 <= sram[addr+6];
				dout_byte5 <= sram[addr+5];
				dout_byte4 <= sram[addr+4];
				dout_byte3 <= sram[addr+3];
				dout_byte2 <= sram[addr+2];
				dout_byte1 <= sram[addr+1];
				dout_byte0 <= sram[addr+0];
			//end
		end
	end
	
endmodule