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

module ScoreBoard(
				input reset,
				input clk,
				
				input stall_i,
				
				//Check and Hold on
				input [`NUM_WARP_LOG-1:0] toSelectWarp_i,
				input toSelectPacketValid_i,
				input [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
							+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
							:0]toSelectPacket_i,
				
				
				/*intu Commit*/
				input [`NUM_WARP_LOG-1:0] intuWarp_i,
				input intuPacketValid_i,
				input [`SIZE_CORE-1:0] intuMask_i,
				input [`SIZE_DATA+`SIZE_REGFILE+1+`INST_TYPES_LOG-1
								:0]intuPacketLane0_i,
				/*~intu Commit*/
				
				/*Load Commit*/
				input [`NUM_WARP_LOG-1:0] loadWarp_i,
				input loadCommit_i,
				input [`SIZE_CORE-1:0] loadMask_i,
				input [`SIZE_DATA+`SIZE_REGFILE_BR-1:0] loadPacketLane0_i,
				/*~Load Commit*/
				
				
				output toSelectReady_o
				
				);
	
	
	//Check Registers
	wire [`SIZE_RP-1:0] toSelectPredReg;
	wire [`SIZE_REGFILE-1:0] toSelectSourceReg1;
	wire [`SIZE_REGFILE-1:0] toSelectSourceReg2;
	wire [`SIZE_REGFILE-1:0] toSelectSourceReg3;
	wire [`SIZE_REGFILE-1:0] toSelectDestReg;
	wire toSelectSource1Valid;
	wire toSelectSource2Valid;
	wire toSelectSource3Valid;
	wire toSelectDestValid;
	
	
	assign toSelectPredReg = toSelectPacket_i[`SIZE_RP+1+3*`SIZE_PC-1:1+3*`SIZE_PC];	
	assign toSelectSourceReg1 = toSelectPacket_i[`SIZE_REGFILE+1+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
										:1+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC];
	assign toSelectSourceReg2 = toSelectPacket_i[2*`SIZE_REGFILE+2+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
										:1+`SIZE_REGFILE+1+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC];
	assign toSelectSourceReg3 = toSelectPacket_i[3*`SIZE_REGFILE+3+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
										:1+2*`SIZE_REGFILE+2+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC];
	assign toSelectDestReg = toSelectPacket_i[4*`SIZE_REGFILE+4+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
										:1+3*`SIZE_REGFILE+3+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC];
										
	assign toSelectSource1Valid = toSelectPacket_i[`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC];
	assign toSelectSource2Valid = toSelectPacket_i[`SIZE_REGFILE+1+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC];
	assign toSelectSource3Valid = toSelectPacket_i[2*`SIZE_REGFILE+2+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC];
	assign toSelectDestValid = toSelectPacket_i[3*`SIZE_REGFILE+3+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC];
	
	
	wire [`NUM_WARP_LOG+`SIZE_RP-1:0] toSelectPred;
	wire [`SIZE_REG_TYPES_LOG-1:0] toSelectSource1_Type;
	wire [`REGFILE_BR_INDEX-1:0] toSelectSource1_BR;
	
	wire [`SIZE_REG_TYPES_LOG-1:0] toSelectSource2_Type;
	wire [`REGFILE_BR_INDEX-1:0] toSelectSource2_BR;
	
	wire [`SIZE_REG_TYPES_LOG-1:0] toSelectSource3_Type;
	wire [`REGFILE_BR_INDEX-1:0] toSelectSource3_BR;

	wire [`REGFILE_BR_INDEX-1:0] toSelectDest_BR;	
	
	assign toSelectPred = {toSelectWarp_i, toSelectPredReg};
	
	assign toSelectSource1_Type = toSelectSourceReg1[`SIZE_REGFILE-1:`SIZE_REGFILE-`SIZE_REG_TYPES_LOG];
	assign toSelectSource1_BR = {toSelectWarp_i, toSelectSourceReg1[`SIZE_REGFILE_BR-1:0]};
	
	assign toSelectSource2_Type = toSelectSourceReg2[`SIZE_REGFILE-1:`SIZE_REGFILE-`SIZE_REG_TYPES_LOG];
	assign toSelectSource2_BR = {toSelectWarp_i, toSelectSourceReg2[`SIZE_REGFILE_BR-1:0]};
	
	assign toSelectSource3_Type = toSelectSourceReg3[`SIZE_REGFILE-1:`SIZE_REGFILE-`SIZE_REG_TYPES_LOG];
	assign toSelectSource3_BR = {toSelectWarp_i, toSelectSourceReg3[`SIZE_REGFILE_BR-1:0]};
	
	assign toSelectDest_BR = {toSelectWarp_i, toSelectDestReg[`SIZE_REGFILE_BR-1:0] };
	
	
	//Commit Registers
		//INTU
		wire [`SIZE_REGFILE-1:0] intuDestReg;
		wire [`REGFILE_BR_INDEX-1:0] intuDest;
		wire intuDestValid;
		
		assign intuDestReg = intuPacketLane0_i [`SIZE_REGFILE+1+`INST_TYPES_LOG-1:1+`INST_TYPES_LOG];
		assign intuDest = {intuWarp_i, intuDestReg[`SIZE_REGFILE_BR-1:0]};
		assign intuDestValid = intuPacketLane0_i [1+`INST_TYPES_LOG-1];
		
		//Load
		wire [`SIZE_REGFILE-1:0] loadDestReg;
		wire [`REGFILE_BR_INDEX-1:0] loadDest;
		//wire loadDestValid;
		
		assign loadDestReg = loadPacketLane0_i [`SIZE_REGFILE_BR-1:0];
		assign loadDest = {loadWarp_i, loadDestReg[`SIZE_REGFILE_BR-1:0]};
		//assign loadDestValid = intuPacketLane0_i [1+`INST_TYPES_LOG-1];
	
	wire [`SIZE_CORE-1:0] pred_ava;
	wire [`SIZE_CORE-1:0] source1_ava;
	wire [`SIZE_CORE-1:0] source2_ava;
	wire [`SIZE_CORE-1:0] dest_ava;
	
	wire pred_ava_free;
	wire source1_ava_free;
	wire source2_ava_free;
	wire source3_ava_free;
	wire dest_ava_free;
	wire simd_ava_free;
	
	wire isintu;
	wire isload;
	reg prenotintu;//???
	reg prenotload;//???
	
	SRAM_4R4W_RESET #(`REGFILE_BR_DEPTH,`REGFILE_BR_INDEX,`SIZE_CORE)  
		regScoreBoard(
			.clk(clk),
			.reset(reset),
			
			//check
			.addr0_i(toSelectPred),
			.addr1_i(toSelectSource1_BR),
			.addr2_i(toSelectSource2_BR),
			.addr3_i(toSelectDest_BR),
			
			//hold on
				.addr0wr_i(toSelectDest_BR),
				.we0_i(toSelectPacketValid_i && toSelectDestValid && simd_ava_free && (~stall_i)),
				.data0wr_i(0),
			
			//commit
				.addr1wr_i(intuDest),
				.we1_i(intuPacketValid_i && intuDestValid && (~stall_i)),
				.data1wr_i(0/*~intuMask_i*/),
				
				.addr2wr_i(0),
				.we2_i(1'b0 && (~stall_i)),//fpu, to be modified?
				.data2wr_i(1'b0),
				
				.addr3wr_i(loadDest),
				.we3_i(loadCommit_i && (~stall_i)),//ldst, to be modified?
				.data3wr_i(0/*~loadMask_i*/),
			
			.data0_o(pred_ava),
			.data1_o(source1_ava),
			.data2_o(source2_ava),
			.data3_o(dest_ava)
			);
			

	assign pred_ava_free = (toSelectPredReg[`SIZE_RP-1:0] != 5'b00000)? ~(|pred_ava):1'b1;
	assign source1_ava_free = ((toSelectSource1_Type != `REG_TYPE_SR) && toSelectSource1Valid)? ~(|source1_ava):1'b1;
	assign source2_ava_free = ((toSelectSource2_Type != `REG_TYPE_SR) && toSelectSource2Valid)? ~(|source2_ava):1'b1;
	assign dest_ava_free = toSelectDestValid? ~(|dest_ava):1'b1;
	assign simd_ava_free = pred_ava_free && source1_ava_free && source2_ava_free;// && dest_ava_free;
	
	
	assign isintu = (intuPacketValid_i && intuDestValid) 
				&&((toSelectPred == intuDest) || (toSelectSource1_BR == intuDest) || (toSelectSource1_BR == intuDest));
	
	assign isload = (loadCommit_i) 
				&&((toSelectPred == loadDest) || (toSelectSource1_BR == loadDest) || (toSelectSource1_BR == loadDest));
				
	always @(clk) begin
		if(reset) begin
			prenotintu <= 0;
			prenotload <= 0;
		end
		else begin
			prenotintu <= (~isintu);
			prenotload <= (~isload);
		end
	end
	assign toSelectReady_o = simd_ava_free && prenotintu && prenotload;//???
	
endmodule