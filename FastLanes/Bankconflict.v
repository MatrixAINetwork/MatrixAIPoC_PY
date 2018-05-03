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
`define SIZE_SHARED_MEM 64 * 1024   // bytes
`define SIZE_SHARED_MEM_LOG 16
`define BankNum 16
`define BankNum_LOG 4
module BankConflict( 
			input reset,
			input clk,
			input stall,
					
			input load_i,
			input store_i,			

			input [`NUM_WARP_LOG-1:0] ldstWarp_i,
			input ldstPacketValid_i,
			input [`SIZE_CORE-1:0] ldstMask_i,
			
	        input [`SIZE_ADDR-1:0] addr0_i,
	        input [`SIZE_ADDR-1:0] addr1_i,
	        input [`SIZE_ADDR-1:0] addr2_i,
	        input [`SIZE_ADDR-1:0] addr3_i,
	        input [`SIZE_ADDR-1:0] addr4_i,
	        input [`SIZE_ADDR-1:0] addr5_i,
	        input [`SIZE_ADDR-1:0] addr6_i,
	        input [`SIZE_ADDR-1:0] addr7_i,
	        input [`SIZE_ADDR-1:0] addr8_i,
	        input [`SIZE_ADDR-1:0] addr9_i,
	        input [`SIZE_ADDR-1:0] addr10_i,
	        input [`SIZE_ADDR-1:0] addr11_i,
	        input [`SIZE_ADDR-1:0] addr12_i,
	        input [`SIZE_ADDR-1:0] addr13_i,
	        input [`SIZE_ADDR-1:0] addr14_i,
	        input [`SIZE_ADDR-1:0] addr15_i,
	        input [`SIZE_ADDR-1:0] addr16_i,
	        input [`SIZE_ADDR-1:0] addr17_i,
	        input [`SIZE_ADDR-1:0] addr18_i,
	        input [`SIZE_ADDR-1:0] addr19_i,
	        input [`SIZE_ADDR-1:0] addr20_i,
	        input [`SIZE_ADDR-1:0] addr21_i,
	        input [`SIZE_ADDR-1:0] addr22_i,
	        input [`SIZE_ADDR-1:0] addr23_i,
	        input [`SIZE_ADDR-1:0] addr24_i,
	        input [`SIZE_ADDR-1:0] addr25_i,
	        input [`SIZE_ADDR-1:0] addr26_i,
	        input [`SIZE_ADDR-1:0] addr27_i,
	        input [`SIZE_ADDR-1:0] addr28_i,
	        input [`SIZE_ADDR-1:0] addr29_i,
	        input [`SIZE_ADDR-1:0] addr30_i,
	        input [`SIZE_ADDR-1:0] addr31_i,			

	        input [`SIZE_DATA-1:0] storeData0_i,
	        input [`SIZE_DATA-1:0] storeData1_i,
	        input [`SIZE_DATA-1:0] storeData2_i,
	        input [`SIZE_DATA-1:0] storeData3_i,
	        input [`SIZE_DATA-1:0] storeData4_i,
	        input [`SIZE_DATA-1:0] storeData5_i,
	        input [`SIZE_DATA-1:0] storeData6_i,
	        input [`SIZE_DATA-1:0] storeData7_i,
	        input [`SIZE_DATA-1:0] storeData8_i,
	        input [`SIZE_DATA-1:0] storeData9_i,
	        input [`SIZE_DATA-1:0] storeData10_i,
	        input [`SIZE_DATA-1:0] storeData11_i,
	        input [`SIZE_DATA-1:0] storeData12_i,
	        input [`SIZE_DATA-1:0] storeData13_i,
	        input [`SIZE_DATA-1:0] storeData14_i,
	        input [`SIZE_DATA-1:0] storeData15_i,
	        input [`SIZE_DATA-1:0] storeData16_i,
	        input [`SIZE_DATA-1:0] storeData17_i,
	        input [`SIZE_DATA-1:0] storeData18_i,
	        input [`SIZE_DATA-1:0] storeData19_i,
	        input [`SIZE_DATA-1:0] storeData20_i,
	        input [`SIZE_DATA-1:0] storeData21_i,
	        input [`SIZE_DATA-1:0] storeData22_i,
	        input [`SIZE_DATA-1:0] storeData23_i,
	        input [`SIZE_DATA-1:0] storeData24_i,
	        input [`SIZE_DATA-1:0] storeData25_i,
	        input [`SIZE_DATA-1:0] storeData26_i,
	        input [`SIZE_DATA-1:0] storeData27_i,
	        input [`SIZE_DATA-1:0] storeData28_i,
	        input [`SIZE_DATA-1:0] storeData29_i,
	        input [`SIZE_DATA-1:0] storeData30_i,
	        input [`SIZE_DATA-1:0] storeData31_i,
			//----------------
			
			output reg [`SIZE_ADDR * `SIZE_CORE - 1 : 0] SharedAddrPacket_o,
			output reg [`SIZE_DATA * `SIZE_CORE - 1 : 0] SharedStoreDataPacket_o,
			output reg [`SIZE_CORE + `NUM_WARP_LOG + `SIZE_REGFILE_BR + 2 : 0] SharedInfoPacket_o,
			output wire [9 : 0] Delay,
			output reg BankConflictOut
			);

	wire [`BankNum_LOG + 1 : 0] BankIndex0;
	wire [`BankNum_LOG + 1 : 0] BankIndex1;
	wire [`BankNum_LOG + 1 : 0] BankIndex2;
	wire [`BankNum_LOG + 1 : 0] BankIndex3;
	wire [`BankNum_LOG + 1 : 0] BankIndex4;
	wire [`BankNum_LOG + 1 : 0] BankIndex5;
	wire [`BankNum_LOG + 1 : 0] BankIndex6;
	wire [`BankNum_LOG + 1 : 0] BankIndex7;
	wire [`BankNum_LOG + 1 : 0] BankIndex8;
	wire [`BankNum_LOG + 1 : 0] BankIndex9;
	wire [`BankNum_LOG + 1 : 0] BankIndex10;
	wire [`BankNum_LOG + 1 : 0] BankIndex11;
	wire [`BankNum_LOG + 1 : 0] BankIndex12;
	wire [`BankNum_LOG + 1 : 0] BankIndex13;
	wire [`BankNum_LOG + 1 : 0] BankIndex14;
	wire [`BankNum_LOG + 1 : 0] BankIndex15;
	wire [`BankNum_LOG + 1 : 0] BankIndex16;
	wire [`BankNum_LOG + 1 : 0] BankIndex17;
	wire [`BankNum_LOG + 1 : 0] BankIndex18;
	wire [`BankNum_LOG + 1 : 0] BankIndex19;
	wire [`BankNum_LOG + 1 : 0] BankIndex20;
	wire [`BankNum_LOG + 1 : 0] BankIndex21;
	wire [`BankNum_LOG + 1 : 0] BankIndex22;
	wire [`BankNum_LOG + 1 : 0] BankIndex23;
	wire [`BankNum_LOG + 1 : 0] BankIndex24;
	wire [`BankNum_LOG + 1 : 0] BankIndex25;
	wire [`BankNum_LOG + 1 : 0] BankIndex26;
	wire [`BankNum_LOG + 1 : 0] BankIndex27;
	wire [`BankNum_LOG + 1 : 0] BankIndex28;
	wire [`BankNum_LOG + 1 : 0] BankIndex29;
	wire [`BankNum_LOG + 1 : 0] BankIndex30;
	wire [`BankNum_LOG + 1 : 0] BankIndex31;
	
	assign BankIndex0 = addr0_i[`BankNum_LOG + 1 : 0];
	assign BankIndex1 = addr1_i[`BankNum_LOG + 1 : 0];
	assign BankIndex2 = addr2_i[`BankNum_LOG + 1 : 0];
	assign BankIndex3 = addr3_i[`BankNum_LOG + 1 : 0];
	assign BankIndex4 = addr4_i[`BankNum_LOG + 1 : 0];
	assign BankIndex5 = addr5_i[`BankNum_LOG + 1 : 0];
	assign BankIndex6 = addr6_i[`BankNum_LOG + 1 : 0];
	assign BankIndex7 = addr7_i[`BankNum_LOG + 1 : 0];
	assign BankIndex8 = addr8_i[`BankNum_LOG + 1 : 0];
	assign BankIndex9 = addr9_i[`BankNum_LOG + 1 : 0];
	assign BankIndex10 = addr10_i[`BankNum_LOG + 1 : 0];
	assign BankIndex11 = addr11_i[`BankNum_LOG + 1 : 0];
	assign BankIndex12 = addr12_i[`BankNum_LOG + 1 : 0];
	assign BankIndex13 = addr13_i[`BankNum_LOG + 1 : 0];
	assign BankIndex14 = addr14_i[`BankNum_LOG + 1 : 0];
	assign BankIndex15 = addr15_i[`BankNum_LOG + 1 : 0];
	assign BankIndex16 = addr16_i[`BankNum_LOG + 1 : 0];
	assign BankIndex17 = addr17_i[`BankNum_LOG + 1 : 0];
	assign BankIndex18 = addr18_i[`BankNum_LOG + 1 : 0];
	assign BankIndex19 = addr19_i[`BankNum_LOG + 1 : 0];
	assign BankIndex20 = addr20_i[`BankNum_LOG + 1 : 0];
	assign BankIndex21 = addr21_i[`BankNum_LOG + 1 : 0];
	assign BankIndex22 = addr22_i[`BankNum_LOG + 1 : 0];
	assign BankIndex23 = addr23_i[`BankNum_LOG + 1 : 0];
	assign BankIndex24 = addr24_i[`BankNum_LOG + 1 : 0];
	assign BankIndex25 = addr25_i[`BankNum_LOG + 1 : 0];
	assign BankIndex26 = addr26_i[`BankNum_LOG + 1 : 0];
	assign BankIndex27 = addr27_i[`BankNum_LOG + 1 : 0];
	assign BankIndex28 = addr28_i[`BankNum_LOG + 1 : 0];
	assign BankIndex29 = addr29_i[`BankNum_LOG + 1 : 0];
	assign BankIndex30 = addr30_i[`BankNum_LOG + 1 : 0];
	assign BankIndex31 = addr31_i[`BankNum_LOG + 1 : 0];
	
	reg [`SIZE_CORE_LOG - 1 : 0] BankConflict [`BankNum - 1 : 0];
	
	
	always @ (posedge clk)
	begin
		if(reset)
		begin
			SharedAddrPacket_o <= 0;
			SharedStoreDataPacket_o <= 0;
			SharedInfoPacket_o <= 0;
			//BankConflict[`BankNum - 1 : 0][`SIZE_CORE_LOG - 1 : 0] <= 0;
		end
		else if(~stall)
		begin
			SharedAddrPacket_o <= {
			 addr0_i,
	         addr1_i,
	         addr2_i,
	         addr3_i,
	         addr4_i,
	         addr5_i,
	         addr6_i,
	         addr7_i,
	         addr8_i,
	         addr9_i,
	         addr10_i,
	         addr11_i,
	         addr12_i,
	         addr13_i,
	         addr14_i,
	         addr15_i,
	         addr16_i,
	         addr17_i,
	         addr18_i,
	         addr19_i,
	         addr20_i,
	         addr21_i,
	         addr22_i,
	         addr23_i,
	         addr24_i,
	         addr25_i,
	         addr26_i,
	         addr27_i,
	         addr28_i,
	         addr29_i,
	         addr30_i,
	         addr31_i
			};			
		SharedStoreDataPacket_o <= {
			 storeData0_i,
	         storeData1_i,
	         storeData2_i,
	         storeData3_i,
	         storeData4_i,
	         storeData5_i,
	         storeData6_i,
	         storeData7_i,
	         storeData8_i,
	         storeData9_i,
	         storeData10_i,
	         storeData11_i,
	         storeData12_i,
	         storeData13_i,
	         storeData14_i,
	         storeData15_i,
	         storeData16_i,
	         storeData17_i,
	         storeData18_i,
	         storeData19_i,
	         storeData20_i,
	         storeData21_i,
	         storeData22_i,
	         storeData23_i,
	         storeData24_i,
	         storeData25_i,
	         storeData26_i,
	         storeData27_i,
	         storeData28_i,
	         storeData29_i,
	         storeData30_i,
	         storeData31_i
		
		};
		SharedInfoPacket_o <= {
							ldstMask_i,
							ldstWarp_i,
							ldstPacketValid_i,
							load_i
		};
		end
	
	end
		
endmodule