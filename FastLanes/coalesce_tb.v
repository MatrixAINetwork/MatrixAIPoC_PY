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

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:32:33 05/18/2013
// Design Name:   Coalesce
// Module Name:   D:/ISE/LSU1.9/LSU1.8/coalesce_tb.v
// Project Name:  LSU1.5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Coalesce
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module coalesce_tb;

	// Inputs
	reg reset;
	reg clk;
	reg stall;
	reg load_i;
	reg store_i;
	reg [1:0] ldstWarp_i;
	reg ldstPacketValid_i;
	reg [31:0] ldstMask_i;
	reg [4:0] ldstReg_i;
	reg [31:0] addr0_i;
	reg [31:0] addr1_i;
	reg [31:0] addr2_i;
	reg [31:0] addr3_i;
	reg [31:0] addr4_i;
	reg [31:0] addr5_i;
	reg [31:0] addr6_i;
	reg [31:0] addr7_i;
	reg [31:0] addr8_i;
	reg [31:0] addr9_i;
	reg [31:0] addr10_i;
	reg [31:0] addr11_i;
	reg [31:0] addr12_i;
	reg [31:0] addr13_i;
	reg [31:0] addr14_i;
	reg [31:0] addr15_i;
	reg [31:0] addr16_i;
	reg [31:0] addr17_i;
	reg [31:0] addr18_i;
	reg [31:0] addr19_i;
	reg [31:0] addr20_i;
	reg [31:0] addr21_i;
	reg [31:0] addr22_i;
	reg [31:0] addr23_i;
	reg [31:0] addr24_i;
	reg [31:0] addr25_i;
	reg [31:0] addr26_i;
	reg [31:0] addr27_i;
	reg [31:0] addr28_i;
	reg [31:0] addr29_i;
	reg [31:0] addr30_i;
	reg [31:0] addr31_i;
	reg [31:0] storeData0_i;
	reg [31:0] storeData1_i;
	reg [31:0] storeData2_i;
	reg [31:0] storeData3_i;
	reg [31:0] storeData4_i;
	reg [31:0] storeData5_i;
	reg [31:0] storeData6_i;
	reg [31:0] storeData7_i;
	reg [31:0] storeData8_i;
	reg [31:0] storeData9_i;
	reg [31:0] storeData10_i;
	reg [31:0] storeData11_i;
	reg [31:0] storeData12_i;
	reg [31:0] storeData13_i;
	reg [31:0] storeData14_i;
	reg [31:0] storeData15_i;
	reg [31:0] storeData16_i;
	reg [31:0] storeData17_i;
	reg [31:0] storeData18_i;
	reg [31:0] storeData19_i;
	reg [31:0] storeData20_i;
	reg [31:0] storeData21_i;
	reg [31:0] storeData22_i;
	reg [31:0] storeData23_i;
	reg [31:0] storeData24_i;
	reg [31:0] storeData25_i;
	reg [31:0] storeData26_i;
	reg [31:0] storeData27_i;
	reg [31:0] storeData28_i;
	reg [31:0] storeData29_i;
	reg [31:0] storeData30_i;
	reg [31:0] storeData31_i;

	// Outputs
	wire [1023:0] GlobalAddrPacket_o;
	wire [1023:0] GlobalStoreDataPacket_o;
	wire [41:0] GlobalInfoPacket_o;
	wire [31:0] Coalesce2L1_o;
	wire [4:0] SegNum;
	wire stall_input;
	wire working;

	// Instantiate the Unit Under Test (UUT)
	Coalesce uut (
		.reset(reset), 
		.clk(clk), 
		.stall(stall), 
		.load_i(load_i), 
		.store_i(store_i), 
		.ldstWarp_i(ldstWarp_i), 
		.ldstPacketValid_i(ldstPacketValid_i), 
		.ldstMask_i(ldstMask_i), 
		.ldstReg_i(ldstReg_i), 
		.addr0_i(addr0_i), 
		.addr1_i(addr1_i), 
		.addr2_i(addr2_i), 
		.addr3_i(addr3_i), 
		.addr4_i(addr4_i), 
		.addr5_i(addr5_i), 
		.addr6_i(addr6_i), 
		.addr7_i(addr7_i), 
		.addr8_i(addr8_i), 
		.addr9_i(addr9_i), 
		.addr10_i(addr10_i), 
		.addr11_i(addr11_i), 
		.addr12_i(addr12_i), 
		.addr13_i(addr13_i), 
		.addr14_i(addr14_i), 
		.addr15_i(addr15_i), 
		.addr16_i(addr16_i), 
		.addr17_i(addr17_i), 
		.addr18_i(addr18_i), 
		.addr19_i(addr19_i), 
		.addr20_i(addr20_i), 
		.addr21_i(addr21_i), 
		.addr22_i(addr22_i), 
		.addr23_i(addr23_i), 
		.addr24_i(addr24_i), 
		.addr25_i(addr25_i), 
		.addr26_i(addr26_i), 
		.addr27_i(addr27_i), 
		.addr28_i(addr28_i), 
		.addr29_i(addr29_i), 
		.addr30_i(addr30_i), 
		.addr31_i(addr31_i), 
		.storeData0_i(storeData0_i), 
		.storeData1_i(storeData1_i), 
		.storeData2_i(storeData2_i), 
		.storeData3_i(storeData3_i), 
		.storeData4_i(storeData4_i), 
		.storeData5_i(storeData5_i), 
		.storeData6_i(storeData6_i), 
		.storeData7_i(storeData7_i), 
		.storeData8_i(storeData8_i), 
		.storeData9_i(storeData9_i), 
		.storeData10_i(storeData10_i), 
		.storeData11_i(storeData11_i), 
		.storeData12_i(storeData12_i), 
		.storeData13_i(storeData13_i), 
		.storeData14_i(storeData14_i), 
		.storeData15_i(storeData15_i), 
		.storeData16_i(storeData16_i), 
		.storeData17_i(storeData17_i), 
		.storeData18_i(storeData18_i), 
		.storeData19_i(storeData19_i), 
		.storeData20_i(storeData20_i), 
		.storeData21_i(storeData21_i), 
		.storeData22_i(storeData22_i), 
		.storeData23_i(storeData23_i), 
		.storeData24_i(storeData24_i), 
		.storeData25_i(storeData25_i), 
		.storeData26_i(storeData26_i), 
		.storeData27_i(storeData27_i), 
		.storeData28_i(storeData28_i), 
		.storeData29_i(storeData29_i), 
		.storeData30_i(storeData30_i), 
		.storeData31_i(storeData31_i), 
		.GlobalAddrPacket_o(GlobalAddrPacket_o), 
		.GlobalStoreDataPacket_o(GlobalStoreDataPacket_o), 
		.GlobalInfoPacket_o(GlobalInfoPacket_o), 
		.Coalesce2L1_o(Coalesce2L1_o), 
		.SegNum(SegNum), 
		.stall_input(stall_input), 
		.working(working)
	);

	reg [31:0] addr;
	reg [31:0] data;
	initial begin
		// Initialize Inputs
		addr = 32'b00000000_00000000_00000000_00000001;
		data = 32'b00000000_11111111_00000000_00000000;
		reset = 0;
		clk = 1;
		stall = 0;
		load_i = 0;
		store_i = 0;
		ldstWarp_i = 0;
		ldstPacketValid_i = 0;
		ldstMask_i = 0;
		ldstReg_i = 0;
		addr0_i = 0;
		addr1_i = 0;
		addr2_i = 0;
		addr3_i = 0;
		addr4_i = 0;
		addr5_i = 0;
		addr6_i = 0;
		addr7_i = 0;
		addr8_i = 0;
		addr9_i = 0;
		addr10_i = 0;
		addr11_i = 0;
		addr12_i = 0;
		addr13_i = 0;
		addr14_i = 0;
		addr15_i = 0;
		addr16_i = 0;
		addr17_i = 0;
		addr18_i = 0;
		addr19_i = 0;
		addr20_i = 0;
		addr21_i = 0;
		addr22_i = 0;
		addr23_i = 0;
		addr24_i = 0;
		addr25_i = 0;
		addr26_i = 0;
		addr27_i = 0;
		addr28_i = 0;
		addr29_i = 0;
		addr30_i = 0;
		addr31_i = 0;
		storeData0_i = 0;
		storeData1_i = 0;
		storeData2_i = 0;
		storeData3_i = 0;
		storeData4_i = 0;
		storeData5_i = 0;
		storeData6_i = 0;
		storeData7_i = 0;
		storeData8_i = 0;
		storeData9_i = 0;
		storeData10_i = 0;
		storeData11_i = 0;
		storeData12_i = 0;
		storeData13_i = 0;
		storeData14_i = 0;
		storeData15_i = 0;
		storeData16_i = 0;
		storeData17_i = 0;
		storeData18_i = 0;
		storeData19_i = 0;
		storeData20_i = 0;
		storeData21_i = 0;
		storeData22_i = 0;
		storeData23_i = 0;
		storeData24_i = 0;
		storeData25_i = 0;
		storeData26_i = 0;
		storeData27_i = 0;
		storeData28_i = 0;
		storeData29_i = 0;
		storeData30_i = 0;
		storeData31_i = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
		
	initial fork
	forever #5 clk <= ~clk;
	#10 reset <= 1;
	#20 reset <= 0;
	#40 load_i <= 1;
	#40 ldstWarp_i <= 5'b01001;
	#40 ldstPacketValid_i <= 1;
	#40 ldstMask_i <= 32'b11111111_11111111_11111111_11111111;
	#40 ldstReg_i <= 5'b10001;
	#40	addr0_i <= addr+0;
	#40	addr1_i <= addr+0;
	#40	addr2_i <= addr+100;
	#40	addr3_i <= addr+100;
	#40	addr4_i <= addr+200;
	#40	addr5_i <= addr+200;
	#40	addr6_i <= addr+300;
	#40	addr7_i <= addr+300;
	#40	addr8_i <= addr+400;
	#40	addr9_i <= addr+400;
	#40	addr10_i <= addr+500;
	#40	addr11_i <= addr+500;
	#40	addr12_i <= addr+600;
	#40	addr13_i <= addr+600;
	#40	addr14_i <= addr+700;
	#40	addr15_i <= addr+700;
	#40	addr16_i <= addr+800;
	#40	addr17_i <= addr+800;
	#40	addr18_i <= addr+900;
	#40	addr19_i <= addr+900;
	#40	addr20_i <= addr+1000;
	#40	addr21_i <= addr+1000;
	#40	addr22_i <= addr+1100;
	#40	addr23_i <= addr+1100;
	#40	addr24_i <= addr+1200;
	#40	addr25_i <= addr+1200;
	#40	addr26_i <= addr+1300;
	#40	addr27_i <= addr+1300;
	#40	addr28_i <= addr+1400;
	#40	addr29_i <= addr+1400;
	#40	addr30_i <= addr+1500;
	#40	addr31_i <= addr+1500;
	#40	storeData0_i <= data+0;
	#40	storeData1_i <= data+0;
	#40	storeData2_i <= data+1;
	#40	storeData3_i <= data+1;
	#40	storeData4_i <= data+2;
	#40	storeData5_i <= data+2;
	#40	storeData6_i <= data+3;
	#40	storeData7_i <= data+3;
	#40	storeData8_i <= data+4;
	#40	storeData9_i <= data+4;
	#40	storeData10_i <= data+5;
	#40	storeData11_i <= data+5;
	#40	storeData12_i <= data+6;
	#40	storeData13_i <= data+6;
	#40	storeData14_i <= data+7;
	#40	storeData15_i <= data+7;
	#40	storeData16_i <= data+8;
	#40	storeData17_i <= data+8;
	#40	storeData18_i <= data+9;
	#40	storeData19_i <= data+9;
	#40	storeData20_i <= data+10;
	#40	storeData21_i <= data+10;
	#40	storeData22_i <= data+11;
	#40	storeData23_i <= data+11;
	#40	storeData24_i <= data+12;
	#40	storeData25_i <= data+12;
	#40	storeData26_i <= data+13;
	#40	storeData27_i <= data+13;
	#40	storeData28_i <= data+14;
	#40	storeData29_i <= data+14;
	#40	storeData30_i <= data+15;
	#40	storeData31_i <= data+15;	
	join
endmodule

