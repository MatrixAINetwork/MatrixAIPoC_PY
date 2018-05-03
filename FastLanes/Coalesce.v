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

//8 Lanes
module Coalesce(
			input reset,
			input clk,
			input stall,
					
			input load_i,
			input store_i,
			input ldst_global_i, 
			
			input ldst_shared_i,
			input [`NUM_WARP_LOG-1:0] ldstWarp_i,
			input ldstPacketValid_i,
			input [`SIZE_CORE-1:0] ldstMask_i,
			input [`SIZE_REGFILE_BR - 1 : 0 ] ldstReg_i,
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
			output [`SIZE_ADDR * `SIZE_CORE - 1 : 0] GlobalAddrPacket_o,
			output [`SIZE_DATA * `SIZE_CORE - 1 : 0] GlobalStoreDataPacket_o,
			output [`SIZE_CORE + `NUM_WARP_LOG + `SIZE_REGFILE_BR + 2 : 0] GlobalInfoPacket_o,
			output [`SIZE_ADDR - 1 : 0] Coalesce2L1_o,
			output [`SIZE_CORE_LOG  : 0] SegNum,
			output reg ldst_global_o, 
			
			output reg ldst_shared_o,
			output reg stall_input, //不能给输入信�			output unfinished  //coalesce 未完成，持续输出
			output reg working
			);
			reg SAME;
			
			reg load_pre;
			reg store_pre;
			reg ldst_global_pre; 
			
			reg ldst_shared_pre;
			reg [`NUM_WARP_LOG-1:0] ldstWarp_pre;
			reg ldstPacketValid_pre;
			reg [`SIZE_CORE-1:0] ldstMask_pre;
			reg [`SIZE_REGFILE_BR - 1 : 0 ] ldstReg_pre;
			
	        reg [`SIZE_ADDR-1:0] addr0_pre;
	        reg [`SIZE_ADDR-1:0] addr1_pre;
	        reg [`SIZE_ADDR-1:0] addr2_pre;
	        reg [`SIZE_ADDR-1:0] addr3_pre;
	        reg [`SIZE_ADDR-1:0] addr4_pre;
	        reg [`SIZE_ADDR-1:0] addr5_pre;
	        reg [`SIZE_ADDR-1:0] addr6_pre;
	        reg [`SIZE_ADDR-1:0] addr7_pre;
	        reg [`SIZE_ADDR-1:0] addr8_pre;
	        reg [`SIZE_ADDR-1:0] addr9_pre;
	        reg [`SIZE_ADDR-1:0] addr10_pre;
	        reg [`SIZE_ADDR-1:0] addr11_pre;
	        reg [`SIZE_ADDR-1:0] addr12_pre;
	        reg [`SIZE_ADDR-1:0] addr13_pre;
	        reg [`SIZE_ADDR-1:0] addr14_pre;
	        reg [`SIZE_ADDR-1:0] addr15_pre;
	        reg [`SIZE_ADDR-1:0] addr16_pre;
	        reg [`SIZE_ADDR-1:0] addr17_pre;
	        reg [`SIZE_ADDR-1:0] addr18_pre;
	        reg [`SIZE_ADDR-1:0] addr19_pre;
	        reg [`SIZE_ADDR-1:0] addr20_pre;
	        reg [`SIZE_ADDR-1:0] addr21_pre;
	        reg [`SIZE_ADDR-1:0] addr22_pre;
	        reg [`SIZE_ADDR-1:0] addr23_pre;
	        reg [`SIZE_ADDR-1:0] addr24_pre;
	        reg [`SIZE_ADDR-1:0] addr25_pre;
	        reg [`SIZE_ADDR-1:0] addr26_pre;
	        reg [`SIZE_ADDR-1:0] addr27_pre;
	        reg [`SIZE_ADDR-1:0] addr28_pre;
	        reg [`SIZE_ADDR-1:0] addr29_pre;
	        reg [`SIZE_ADDR-1:0] addr30_pre;
	        reg [`SIZE_ADDR-1:0] addr31_pre;			

	        reg [`SIZE_DATA-1:0] storeData0_pre;
	        reg [`SIZE_DATA-1:0] storeData1_pre;
	        reg [`SIZE_DATA-1:0] storeData2_pre;
	        reg [`SIZE_DATA-1:0] storeData3_pre;
	        reg [`SIZE_DATA-1:0] storeData4_pre;
	        reg [`SIZE_DATA-1:0] storeData5_pre;
	        reg [`SIZE_DATA-1:0] storeData6_pre;
	        reg [`SIZE_DATA-1:0] storeData7_pre;
	        reg [`SIZE_DATA-1:0] storeData8_pre;
	        reg [`SIZE_DATA-1:0] storeData9_pre;
	        reg [`SIZE_DATA-1:0] storeData10_pre;
	        reg [`SIZE_DATA-1:0] storeData11_pre;
	        reg [`SIZE_DATA-1:0] storeData12_pre;
	        reg [`SIZE_DATA-1:0] storeData13_pre;
	        reg [`SIZE_DATA-1:0] storeData14_pre;
	        reg [`SIZE_DATA-1:0] storeData15_pre;
	        reg [`SIZE_DATA-1:0] storeData16_pre;
	        reg [`SIZE_DATA-1:0] storeData17_pre;
	        reg [`SIZE_DATA-1:0] storeData18_pre;
	        reg [`SIZE_DATA-1:0] storeData19_pre;
	        reg [`SIZE_DATA-1:0] storeData20_pre; 
	        reg [`SIZE_DATA-1:0] storeData21_pre;
	        reg [`SIZE_DATA-1:0] storeData22_pre;
	        reg [`SIZE_DATA-1:0] storeData23_pre;
	        reg [`SIZE_DATA-1:0] storeData24_pre;
	        reg [`SIZE_DATA-1:0] storeData25_pre;
	        reg [`SIZE_DATA-1:0] storeData26_pre;
	        reg [`SIZE_DATA-1:0] storeData27_pre;
	        reg [`SIZE_DATA-1:0] storeData28_pre;
	        reg [`SIZE_DATA-1:0] storeData29_pre;
	        reg [`SIZE_DATA-1:0] storeData30_pre;
	        reg [`SIZE_DATA-1:0] storeData31_pre;	
	always @(posedge clk)
	begin
		load_pre <= load_i;
		store_pre <= store_i;
		ldst_global_pre <= ldst_global_i; 			
		ldst_shared_pre <= ldst_shared_i;
		ldstWarp_pre <= ldstWarp_i;
		ldstPacketValid_pre <= ldstPacketValid_i;
		ldstMask_pre <= ldstMask_i;
		ldstReg_pre <= ldstReg_i;
			 addr0_pre <= addr0_i;
	         addr1_pre <= addr1_i;
	         addr2_pre <= addr2_i;
	         addr3_pre <= addr3_i;
	         addr4_pre <= addr4_i;
	         addr5_pre <= addr5_i;
	         addr6_pre <= addr6_i;
	         addr7_pre <= addr7_i;
	         addr8_pre <= addr8_i;
	         addr9_pre <= addr9_i;
	         addr10_pre <= addr10_i;
	         addr11_pre <= addr11_i;
	         addr12_pre <= addr12_i;
	         addr13_pre <= addr13_i;
	         addr14_pre <= addr14_i;
	         addr15_pre <= addr15_i;
	         addr16_pre <= addr16_i;
	         addr17_pre <= addr17_i;
	         addr18_pre <= addr18_i;
	         addr19_pre <= addr19_i;
	         addr20_pre <= addr20_i;
	         addr21_pre <= addr21_i;
	         addr22_pre <= addr22_i;
	         addr23_pre <= addr23_i;
	         addr24_pre <= addr24_i;
	         addr25_pre <= addr25_i;
	         addr26_pre <= addr26_i;
	         addr27_pre <= addr27_i;
	         addr28_pre <= addr28_i;
	         addr29_pre <= addr29_i;
	         addr30_pre <= addr30_i;
	         addr31_pre <= addr31_i;			

	         storeData0_pre <= storeData0_i;
	         storeData1_pre <= storeData1_i;
	         storeData2_pre <= storeData2_i;
	         storeData3_pre <= storeData3_i;
	         storeData4_pre <= storeData4_i;
	         storeData5_pre <= storeData5_i;
	         storeData6_pre <= storeData6_i;
	         storeData7_pre <= storeData7_i;
	         storeData8_pre <= storeData8_i;
	         storeData9_pre <= storeData9_i;
	         storeData10_pre <= storeData10_i;
	         storeData11_pre <= storeData11_i;
	         storeData12_pre <= storeData12_i;
	         storeData13_pre <= storeData13_i;
	         storeData14_pre <= storeData14_i;
	         storeData15_pre <= storeData15_i;
	         storeData16_pre <= storeData16_i;
	         storeData17_pre <= storeData17_i;
	         storeData18_pre <= storeData18_i;
	         storeData19_pre <= storeData19_i;
	         storeData20_pre <= storeData20_i;
	         storeData21_pre <= storeData21_i;
	         storeData22_pre <= storeData22_i;
	         storeData23_pre <= storeData23_i;
	         storeData24_pre <= storeData24_i;
	         storeData25_pre <= storeData25_i;
	         storeData26_pre <= storeData26_i;
	         storeData27_pre <= storeData27_i;
	         storeData28_pre <= storeData28_i;
	         storeData29_pre <= storeData29_i;
	         storeData30_pre <= storeData30_i;
	         storeData31_pre <= storeData31_i;	
	end	
	wire compare;
	assign 	compare = (load_pre == load_i)&
		(store_pre == store_i)&
		(ldst_global_pre == ldst_global_i)& ( 			
		ldst_shared_pre == ldst_shared_i)& (
		ldstWarp_pre == ldstWarp_i)& (
		ldstPacketValid_pre == ldstPacketValid_i)& (
		ldstMask_pre == ldstMask_i)& (
		ldstReg_pre == ldstReg_i)& (
			 addr0_pre == addr0_i)& (
	         addr1_pre == addr1_i)& (
	         addr2_pre == addr2_i)& (
	         addr3_pre == addr3_i)& (
	         addr4_pre == addr4_i)& (
	         addr5_pre == addr5_i)& (
	         addr6_pre == addr6_i)& (
	         addr7_pre == addr7_i)& (
	         addr8_pre == addr8_i)& (
	         addr9_pre == addr9_i)& (
	         addr10_pre == addr10_i)& (
	         addr11_pre == addr11_i)& (
	         addr12_pre == addr12_i)& (
	         addr13_pre == addr13_i)& (
	         addr14_pre == addr14_i)& (
	         addr15_pre == addr15_i)& (
	         addr16_pre == addr16_i)& (
	         addr17_pre == addr17_i)& (
	         addr18_pre == addr18_i)& (
	         addr19_pre == addr19_i)& (
	         addr20_pre == addr20_i)& (
	         addr21_pre == addr21_i)& (
	         addr22_pre == addr22_i)& (
	         addr23_pre == addr23_i)& (
	         addr24_pre == addr24_i)& (
	         addr25_pre == addr25_i)& (
	         addr26_pre == addr26_i)& (
	         addr27_pre == addr27_i)& (
	         addr28_pre == addr28_i)& (
	         addr29_pre == addr29_i)& (
	         addr30_pre == addr30_i)& (
	         addr31_pre == addr31_i)& (			

	         storeData0_pre == storeData0_i)& (
	         storeData1_pre == storeData1_i)& (
	         storeData2_pre == storeData2_i)& (
	         storeData3_pre == storeData3_i)& (
	         storeData4_pre == storeData4_i)& (
	         storeData5_pre == storeData5_i)& (
	         storeData6_pre == storeData6_i)& (
	         storeData7_pre == storeData7_i)& (
	         storeData8_pre == storeData8_i)& (
	         storeData9_pre == storeData9_i)& (
	         storeData10_pre == storeData10_i)& (
	         storeData11_pre == storeData11_i)& (
	         storeData12_pre == storeData12_i)& (
	         storeData13_pre == storeData13_i)& (
	         storeData14_pre == storeData14_i)& (
	         storeData15_pre == storeData15_i)& (
	         storeData16_pre == storeData16_i)& (
	         storeData17_pre == storeData17_i)& (
	         storeData18_pre == storeData18_i)& (
	         storeData19_pre == storeData19_i)& (
	         storeData20_pre == storeData20_i)& (
	         storeData21_pre == storeData21_i)& (
	         storeData22_pre == storeData22_i)& (
	         storeData23_pre == storeData23_i)& (
	         storeData24_pre == storeData24_i)& (
	         storeData25_pre == storeData25_i)& (
	         storeData26_pre == storeData26_i)& (
	         storeData27_pre == storeData27_i)& (
	         storeData28_pre == storeData28_i)& (
	         storeData29_pre == storeData29_i)& (
	         storeData30_pre == storeData30_i)& (
	         storeData31_pre == storeData31_i);
	always @(*)
	begin
	if(compare)
				begin
				SAME = 1;
				end
				else begin
				SAME = 0;
				end
	end
			
			
	
	reg [`SIZE_CORE-1:0] Mask;
	reg [`SIZE_REGFILE_BR - 1 : 0 ] ldstReg;

	wire [`SIZE_CORE-1:0] outmask;
	wire [`SIZE_CORE-1:0] Pre;
	wire [`SIZE_CORE_LOG-1:0] FirstOne; 
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
	
 
    reg [`SIZE_ADDR-1:0]       addr0;
    reg [`SIZE_ADDR-1:0]       addr1;
    reg [`SIZE_ADDR-1:0]       addr2;
    reg [`SIZE_ADDR-1:0]       addr3;
    reg [`SIZE_ADDR-1:0]       addr4;
    reg [`SIZE_ADDR-1:0]       addr5;
    reg [`SIZE_ADDR-1:0]       addr6;
    reg [`SIZE_ADDR-1:0]       addr7;
    reg [`SIZE_ADDR-1:0]       addr8;
    reg [`SIZE_ADDR-1:0]       addr9;
    reg [`SIZE_ADDR-1:0]       addr10;
    reg [`SIZE_ADDR-1:0]       addr11;
    reg [`SIZE_ADDR-1:0]       addr12;
    reg [`SIZE_ADDR-1:0]       addr13;
    reg [`SIZE_ADDR-1:0]       addr14;
    reg [`SIZE_ADDR-1:0]       addr15;
    reg [`SIZE_ADDR-1:0]       addr16;
    reg [`SIZE_ADDR-1:0]       addr17;
    reg [`SIZE_ADDR-1:0]       addr18;
    reg [`SIZE_ADDR-1:0]       addr19;
    reg [`SIZE_ADDR-1:0]       addr20;
    reg [`SIZE_ADDR-1:0]       addr21;
    reg [`SIZE_ADDR-1:0]       addr22;
    reg [`SIZE_ADDR-1:0]       addr23;
    reg [`SIZE_ADDR-1:0]       addr24;
    reg [`SIZE_ADDR-1:0]       addr25;
    reg [`SIZE_ADDR-1:0]       addr26;
    reg [`SIZE_ADDR-1:0]       addr27;
    reg [`SIZE_ADDR-1:0]       addr28;
    reg [`SIZE_ADDR-1:0]       addr29;
    reg [`SIZE_ADDR-1:0]       addr30;
    reg [`SIZE_ADDR-1:0]       addr31;
	
	reg [`SIZE_DATA-1:0]  storeData0;
	reg [`SIZE_DATA-1:0]  storeData1;
	reg [`SIZE_DATA-1:0]  storeData2;
	reg [`SIZE_DATA-1:0]  storeData3;
	reg [`SIZE_DATA-1:0]  storeData4;
	reg [`SIZE_DATA-1:0]  storeData5;
	reg [`SIZE_DATA-1:0]  storeData6;
	reg [`SIZE_DATA-1:0]  storeData7;
	reg [`SIZE_DATA-1:0]  storeData8;
	reg [`SIZE_DATA-1:0]  storeData9;
	reg [`SIZE_DATA-1:0]  storeData10;
	reg [`SIZE_DATA-1:0]  storeData11;
	reg [`SIZE_DATA-1:0]  storeData12;
	reg [`SIZE_DATA-1:0]  storeData13;
	reg [`SIZE_DATA-1:0]  storeData14;
	reg [`SIZE_DATA-1:0]  storeData15;
	reg [`SIZE_DATA-1:0]  storeData16;
	reg [`SIZE_DATA-1:0]  storeData17;
	reg [`SIZE_DATA-1:0]  storeData18;
	reg [`SIZE_DATA-1:0]  storeData19;
	reg [`SIZE_DATA-1:0]  storeData20;
	reg [`SIZE_DATA-1:0]  storeData21;
	reg [`SIZE_DATA-1:0]  storeData22;
	reg [`SIZE_DATA-1:0]  storeData23;
	reg [`SIZE_DATA-1:0]  storeData24;
	reg [`SIZE_DATA-1:0]  storeData25;
	reg [`SIZE_DATA-1:0]  storeData26;
	reg [`SIZE_DATA-1:0]  storeData27;
	reg [`SIZE_DATA-1:0]  storeData28;
	reg [`SIZE_DATA-1:0]  storeData29;
	reg [`SIZE_DATA-1:0]  storeData30;
	reg [`SIZE_DATA-1:0]  storeData31;

	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg0;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg1;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg2;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg3;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg4;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg5;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg6;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg7;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg8;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg9;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg10;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg11;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg12;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg13;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg14;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg15;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg16;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg17;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg18;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg19;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg20;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg21;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg22;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg23;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg24;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg25;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg26;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg27;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg28;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg29;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg30;
	wire [`SIZE_ADDR- `SIZE_SEGMENT_BYTES_LOG - 1:0] addrSeg31;
	assign addrSeg0= addr0[ `SIZE_ADDR - 1 : `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg1 = addr1[`SIZE_ADDR - 1 : `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg2 = addr2[`SIZE_ADDR - 1 : `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg3 = addr3[`SIZE_ADDR - 1 : `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg4= addr4[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg5= addr5[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg6= addr6[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg7= addr7[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg8= addr8[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg9= addr9[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg10= addr10[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg11= addr11[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg12= addr12[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg13= addr13[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg14= addr14[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg15= addr15[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg16= addr16[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg17= addr17[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg18= addr18[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg19= addr19[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg20= addr20[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg21= addr21[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg22= addr22[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg23= addr23[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg24= addr24[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg25= addr25[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg26= addr26[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg27= addr27[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg28= addr28[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg29= addr29[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg30= addr30[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];
	assign addrSeg31= addr31[`SIZE_ADDR - 1: `SIZE_SEGMENT_BYTES_LOG];

	wire [`SIZE_ADDR - 1:0] FirstOneAddr;
	assign  Coalesce2L1_o = working?FirstOneAddr:0;
	
	assign SegNum = outmask[0] + outmask[1] + outmask[2] + outmask[3] + outmask[4] + outmask[5] + outmask[6] + outmask[7] + outmask[8] + 
				outmask[9] + outmask[10] + outmask[11] + outmask[12] + outmask[13] + outmask[14] + outmask[15] + outmask[16] + outmask[17] + 
				outmask[18] + outmask[19] + outmask[20] + outmask[21] + outmask[22] + outmask[23] + outmask[24] + outmask[25] + outmask[26] + 
				outmask[27] + outmask[28] + outmask[29] + outmask[30] + outmask[31]; 
	reg [`NUM_WARP_LOG-1:0] ldstWarp;
	reg ldstPacketValid;
	reg load_o; 
	reg store_o;
	reg [1:0] WorkingCondition;
	always @(*)
	begin
		if(reset)
		begin
			WorkingCondition = 0;
			stall_input = 0;
			end
		else if(~stall)
		begin
		case(WorkingCondition)
		0:
		begin
			if((load_i | store_i )&( ldstMask_i != 0 )& ~SAME)
			begin
				stall_input =  1;
				WorkingCondition = 1;
			end
		end
			
		1:
		begin
			if(working)
			begin
				WorkingCondition = 2;
				stall_input = 1;
			end
		end
		2:
		begin
			if(Mask == outmask)
			begin
				WorkingCondition = 3;	
				stall_input = 1;				
			end
		end
		3:	
		begin
			if(~working)
			begin
				WorkingCondition = 0;
				stall_input = 0;
			end
		end
			
		endcase
		end
	end
	
	
	always @ ( posedge clk)
	begin
		if(reset)
		begin
			Mask <= 0;
			working <= 0;
			load_o <= 0;	
			store_o <= 0;
			ldstWarp <= 0;
			ldstReg <= 0; 
			ldstPacketValid <= 0;
			ldst_global_o <= 0; 		
			ldst_shared_o <= 0;
			addr0 <= 0;
		addr1 <= 0;
		addr2 <= 0;
		addr3 <= 0;
		addr4 <= 0;
		addr5 <= 0;
		addr6 <= 0;
		addr7 <= 0;
		addr8 <= 0;
		addr9 <= 0;
		addr10 <= 0;
		addr11 <= 0;
		addr12 <= 0;
		addr13 <= 0;
		addr14 <= 0;
		addr15 <= 0;
		addr16 <= 0;
		addr17 <= 0;
		addr18 <= 0;
		addr19 <= 0;
		addr20 <= 0;
		addr21 <= 0;
		addr22 <= 0;
		addr23 <= 0;
		addr24 <= 0;
		addr25 <= 0;
		addr26 <= 0;
		addr27 <= 0;
		addr28 <= 0;
		addr29 <= 0;
		addr30 <= 0;
		addr31 <= 0;
		storeData0 <= 0;
		storeData1 <= 0;
		storeData2 <= 0;
		storeData3 <= 0;
		storeData4 <= 0;
		storeData5 <= 0;
		storeData6 <= 0;
		storeData7 <= 0;
		storeData8 <= 0;
		storeData9 <= 0;
		storeData10 <= 0;
		storeData11 <= 0;
		storeData12 <= 0;
		storeData13 <= 0;
		storeData14 <= 0;
		storeData15 <= 0;
		storeData16 <= 0;
		storeData17 <= 0;
		storeData18 <= 0;
		storeData19 <= 0;
		storeData20 <= 0;
		storeData21 <= 0;
		storeData22 <= 0;
		storeData23 <= 0;
		storeData24 <= 0;
		storeData25 <= 0;
		storeData26 <= 0;
		storeData27 <= 0;
		storeData28 <= 0;
		storeData29 <= 0;
		storeData30 <= 0;
		storeData31 <= 0;

		end
		else if (~stall)
		begin
			if(( load_i | store_i) & (~working)&(~SAME) & ( ldstMask_i != 0 ))
			begin
				load_o <= load_i;
				store_o <= store_i;
				Mask <= ldstMask_i;
				working <= 1;
				ldstReg <= ldstReg_i;
				ldstWarp <= ldstWarp_i;
				ldstPacketValid <= ldstPacketValid_i;
				ldst_global_o <= ldst_global_i; 			
			   ldst_shared_o <= ldst_shared_i;			 	
					addr0 <= addr0_i[`SIZE_ADDR-1:0];
					addr1 <= addr1_i[`SIZE_ADDR-1:0];
	            addr2 <= addr2_i[`SIZE_ADDR-1:0];
	            addr3 <= addr3_i[`SIZE_ADDR-1:0];
	            addr4 <= addr4_i[`SIZE_ADDR-1:0];
	            addr5 <= addr5_i[`SIZE_ADDR-1:0];
	            addr6 <= addr6_i[`SIZE_ADDR-1:0];
	            addr7 <= addr7_i[`SIZE_ADDR-1:0];
	            addr8 <= addr8_i[`SIZE_ADDR-1:0];
	            addr9 <= addr9_i[`SIZE_ADDR-1:0];
	            addr10 <= addr10_i[`SIZE_ADDR-1:0];
	            addr11 <= addr11_i[`SIZE_ADDR-1:0];
	            addr12 <= addr12_i[`SIZE_ADDR-1:0];
	            addr13 <= addr13_i[`SIZE_ADDR-1:0];
	            addr14 <= addr14_i[`SIZE_ADDR-1:0];
	            addr15 <= addr15_i[`SIZE_ADDR-1:0];
	            addr16 <= addr16_i[`SIZE_ADDR-1:0];
	            addr17 <= addr17_i[`SIZE_ADDR-1:0];
	            addr18 <= addr18_i[`SIZE_ADDR-1:0];
	            addr19 <= addr19_i[`SIZE_ADDR-1:0];
	            addr20 <= addr20_i[`SIZE_ADDR-1:0];
	            addr21 <= addr21_i[`SIZE_ADDR-1:0];
	            addr22 <= addr22_i[`SIZE_ADDR-1:0];
	            addr23 <= addr23_i[`SIZE_ADDR-1:0];
	            addr24 <= addr24_i[`SIZE_ADDR-1:0];
	            addr25 <= addr25_i[`SIZE_ADDR-1:0];
	            addr26 <= addr26_i[`SIZE_ADDR-1:0];
	            addr27 <= addr27_i[`SIZE_ADDR-1:0];
	            addr28 <= addr28_i[`SIZE_ADDR-1:0];
	            addr29 <= addr29_i[`SIZE_ADDR-1:0];
	            addr30 <= addr30_i[`SIZE_ADDR-1:0];
	            addr31 <= addr31_i[`SIZE_ADDR-1:0];
				
			storeData0 <= storeData0_i;
			storeData1 <= storeData1_i;
			storeData2 <= storeData2_i;
			storeData3 <= storeData3_i;
			storeData4 <= storeData4_i;
			storeData5 <= storeData5_i;
			storeData6 <= storeData6_i;
			storeData7 <= storeData7_i;
			storeData8 <= storeData8_i;
			storeData9 <= storeData9_i;
			storeData10 <= storeData10_i;
			storeData11 <= storeData11_i;
			storeData12 <= storeData12_i;
			storeData13 <= storeData13_i;
			storeData14 <= storeData14_i;
			storeData15 <= storeData15_i;
			storeData16 <= storeData16_i;
			storeData17 <= storeData17_i;
			storeData18 <= storeData18_i;
			storeData19 <= storeData19_i;
			storeData20 <= storeData20_i;
			storeData21 <= storeData21_i;
			storeData22 <= storeData22_i;
			storeData23 <= storeData23_i;
			storeData24 <= storeData24_i;
			storeData25 <= storeData25_i;
			storeData26 <= storeData26_i;
			storeData27 <= storeData27_i;
			storeData28 <= storeData28_i;
			storeData29 <= storeData29_i;
			storeData30 <= storeData30_i;
			storeData31 <= storeData31_i;				
			end
			else if(working) begin
				Mask <= Mask ^ outmask;
					
				if(Mask == outmask)
				begin
					working <= 0;
				end
			end	
		end	
	end
			assign	GlobalAddrPacket_o = {
	           	(working & outmask[31])?addr31:0,
	           	(working & outmask[30])?addr30:0,
	           	(working & outmask[29])?addr29:0,
	           	(working & outmask[28])?addr28:0,
	           	(working & outmask[27])?addr27:0,
	           	(working & outmask[26])?addr26:0,
	           	(working & outmask[25])?addr25:0,
	           	(working & outmask[24])?addr24:0,
	           	(working & outmask[23])?addr23:0,
	           	(working & outmask[22])?addr22:0,
	           	(working & outmask[21])?addr21:0,
	           	(working & outmask[20])?addr20:0,
	           	(working & outmask[19])?addr19:0,
	           	(working & outmask[18])?addr18:0,
	           	(working & outmask[17])?addr17:0,
	           	(working & outmask[16])?addr16:0,
					(working & outmask[15])?addr15:0,
	           	(working & outmask[14])?addr14:0,
	           	(working & outmask[13])?addr13:0,
	           	(working & outmask[12])?addr12:0,
	           	(working & outmask[11])?addr11:0,
	           	(working & outmask[10])?addr10:0,
	           	(working & outmask[9])?addr9:0,
	           	(working & outmask[8])?addr8:0,
	           	(working & outmask[7])?addr7:0,
	           	(working & outmask[6])?addr6:0,
	           	(working & outmask[5])?addr5:0,
	           	(working & outmask[4])?addr4:0,
	           	(working & outmask[3])?addr3:0,
	           	(working & outmask[2])?addr2:0,
	           	(working & outmask[1])?addr1:0,
	           	(working & outmask[0])?addr0:0		
				};
			assign	GlobalStoreDataPacket_o = {
	           	(working & outmask[31])?storeData31:0,
	           	(working & outmask[30])?storeData30:0,
	           	(working & outmask[29])?storeData29:0,
	           	(working & outmask[28])?storeData28:0,
	           	(working & outmask[27])?storeData27:0,
	           	(working & outmask[26])?storeData26:0,
	           	(working & outmask[25])?storeData25:0,
	           	(working & outmask[24])?storeData24:0,
	           	(working & outmask[23])?storeData23:0,
	           	(working & outmask[22])?storeData22:0,
	           	(working & outmask[21])?storeData21:0,
	           	(working & outmask[20])?storeData20:0,
	           	(working & outmask[19])?storeData19:0,
	           	(working & outmask[18])?storeData18:0,
	           	(working & outmask[17])?storeData17:0,
	           	(working & outmask[16])?storeData16:0,
					(working & outmask[15])?storeData15:0,
	           	(working & outmask[14])?storeData14:0,
	           	(working & outmask[13])?storeData13:0,
	           	(working & outmask[12])?storeData12:0,
	           	(working & outmask[11])?storeData11:0,
	           	(working & outmask[10])?storeData10:0,
	           	(working & outmask[9])?storeData9:0,
	           	(working & outmask[8])?storeData8:0,
	           	(working & outmask[7])?storeData7:0,
	           	(working & outmask[6])?storeData6:0,
	           	(working & outmask[5])?storeData5:0,
	           	(working & outmask[4])?storeData4:0,
	           	(working & outmask[3])?storeData3:0,
	           	(working & outmask[2])?storeData2:0,
	           	(working & outmask[1])?storeData1:0,
	           	(working & outmask[0])?storeData0:0	
					
				};
		assign GlobalInfoPacket_o  = {
							(working & 1'b1)?outmask:`SIZE_CORE_LOG'b0,
							(working & 1'b1)?ldstWarp:`NUM_WARP_LOG'b0,
							(working & 1'b1)?ldstReg:`SIZE_REGFILE_BR'b0,
							(working & 1'b1)?ldstPacketValid:1'b0,
							(working & 1'b1)?load_o:1'b0,
							(working & 1'b1)?store_o:1'b0
				};	 
			
	FirstAddr firstAddr( 
			.      addr0(      addr0),
			.      addr1(      addr1),
			.      addr2(      addr2),
			.      addr3(      addr3),
			.      addr4(      addr4),
			.      addr5(      addr5),
			.      addr6(      addr6),
			.      addr7(      addr7),
			.      addr8(      addr8),
			.      addr9(      addr9),
			.      addr10(      addr10),
			.      addr11(      addr11),
			.      addr12(      addr12),
			.      addr13(      addr13),
			.      addr14(      addr14),
			.      addr15(      addr15),
			.      addr16(      addr16),
			.      addr17(      addr17),
			.      addr18(      addr18),
			.      addr19(      addr19),
			.      addr20(      addr20),
			.      addr21(      addr21),
			.      addr22(      addr22),
			.      addr23(      addr23),
			.      addr24(      addr24),
			.      addr25(      addr25),
			.      addr26(      addr26),
			.      addr27(      addr27),
			.      addr28(      addr28),
			.      addr29(      addr29),
			.      addr30(      addr30),
			.      addr31(      addr31),
			.Mask(Mask),
		.FirstOne(FirstOne),
		.FirstOneAddr(FirstOneAddr),
		.outmask(outmask)
		);				

 

endmodule