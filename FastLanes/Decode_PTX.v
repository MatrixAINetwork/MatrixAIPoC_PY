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
`include "SimplePTX_ISA.v"

module Decode_PTX(	input reset,
					input clk,
				
					input [`SIZE_INSTRUCTION+`SIZE_PC-1:0] instPachet_i,
				
					output 	[`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
							+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
							:0] decodedPacket_o
					);
	wire [`SIZE_INSTRUCTION-1:0] instruction;
	wire [`SIZE_PC-1:0] pc;
	
	
	
	
	//**Packet Signal**
	wire 							predValid;
	wire [`SIZE_RP-1:0] 			instPred;
	wire [`SIZE_OPCODE-1:0]         opcode;
	wire [`SIZE_REGFILE:0] 			instLogical1;
	wire [`SIZE_REGFILE:0] 			instLogical2;
	wire [`SIZE_REGFILE:0] 			instLogical3;
	wire [`SIZE_REGFILE:0] 			instDest;
	wire [`SIZE_IMMEDIATE-1:0] 		instImmediate;
	wire [`SIZE_PC-1:0] 			instTarget;
	wire [`SIZE_PC-1:0] 			instReconv;
	wire [`INST_TYPES_LOG-1:0] 		instFU;
	reg 					instLoad;
	reg 					instStore;
	reg 					instbranch; 
	reg 					instSync;
	reg						instExit;
	reg 					instSRValid;
	reg	[`LDST_SPACE_LOG-1:0]	ldstSpace;
	//****	
	
	assign decodedPacket_o      = {	
									ldstSpace,
									instSRValid,
									instExit,
									instSync,
									instbranch,
									instStore,
									instLoad,
									instFU,
									instImmediate,
									instDest,
									instLogical3,
									instLogical2,
									instLogical1,
									opcode,
									instPred,
									predValid,
									pc,
									instTarget,
									instReconv
									};

	
	assign instruction = instPachet_i[`SIZE_INSTRUCTION+`SIZE_PC-1:`SIZE_PC];
	assign pc = instPachet_i[`SIZE_PC-1:0];
	
	/* Following extracts source registers, destination register, immediate field and 
	 * target address from instruction. Bit-0 of each wire is set to 1 if the field
	 * is valid for the corresponding instruction.
	 */
	 
	wire [`SIZE_REGFILE-1:0] 			instRs;
	wire [`SIZE_REGFILE-1:0] 			instRt;
	wire [`SIZE_REGFILE-1:0] 			instRd;
	wire [`SIZE_REGFILE-1:0] 			instRu;		
	reg [`SIZE_REGFILE-1:0] 			instSource1;
	reg [`SIZE_REGFILE-1:0] 			instSource2;
	reg [`SIZE_REGFILE-1:0] 			instSource3;
	reg [`SIZE_REGFILE-1:0] 			instDestReg;
	reg instSource1Valid;
	reg instSource2Valid;
	reg instSource3Valid;
	reg instDestRegValid;
	wire [`SIZE_OPCODE_USED-1:0]		opcode_used;
	
	assign instPred = instruction[`SIZE_INSTRUCTION-32+`SIZE_OPCODE+`SIZE_RP-1:`SIZE_INSTRUCTION-32+`SIZE_OPCODE];
	assign predValid = instruction[`SIZE_INSTRUCTION-32+`SIZE_OPCODE+`SIZE_RP+1];
	assign opcode = instruction[`SIZE_INSTRUCTION-16:`SIZE_INSTRUCTION-16-`SIZE_OPCODE];
	assign instRs = instruction[`SIZE_RS+`SIZE_RT+`SIZE_RD+`SIZE_RU-1:`SIZE_RT+`SIZE_RD+`SIZE_RU];
	assign instRt = instruction[`SIZE_RT+`SIZE_RD+`SIZE_RU-1:`SIZE_RD+`SIZE_RU];
	assign instRd = instruction[`SIZE_RD+`SIZE_RU-1:`SIZE_RU];
	assign instRu = instruction[`SIZE_RU-1:0];
	assign instImmediate = instruction[`SIZE_IMMEDIATE-1:0];
	assign instReconv = instruction[`SIZE_RECONV+`SIZE_TARGET-1:`SIZE_TARGET];
	assign instTarget = instruction[`SIZE_TARGET-1:0];	
	
	assign opcode_used = opcode[`SIZE_OPCODE_USED-1:0];
	assign instFU = opcode[`INST_TYPES_LOG+`SIZE_OPCODE_USED-1:`SIZE_OPCODE_USED];

	assign instLogical1 = {instSource1, instSource1Valid};
	assign instLogical2 = {instSource2, instSource2Valid};
	assign instLogical3 = {instSource3, instSource3Valid};
	assign instDest = {instDestReg, instDestRegValid};
			
			
			
	always @(*) begin: INST_TYPE_DECODE
		case(instFU)
		`INSTRUCTION_NOP: begin
			instSource1 = 0;
			instSource2 = 0;
			instSource3 = 0;
			instDestReg = 0;
		end
		
		`INSTRUCTION_INT_R: begin
			instSource1 = instRs;
			instSource2 = instRt;
			instSource3 = instRu;
			instDestReg = instRd;
		end
		
		`INSTRUCTION_INT_I: begin
			instSource1 = instRs;
			instSource2 = 0;
			instSource3 = 0;
			instDestReg = instRt;
		end		
		
		`INSTRUCTION_FP_R: begin
			instSource1 = instRs;
			instSource2 = instRt;
			instSource3 = instRu;
			instDestReg = instRd;
		end
		
		`INSTRUCTION_FP_I: begin
			instSource1 = instRs;
			instSource2 = 0;
			instSource3 = 0;
			instDestReg = instRt;
		end
		
		`INSTRUCTION_SF_R: begin
			instSource1 = instRs;
			instSource2 = instRt;
			instSource3 = instRu;
			instDestReg = instRd;
		end
		
		`INSTRUCTION_SF_I: begin
			instSource1 = instRs;
			instSource2 = 0;
			instSource3 = 0;
			instDestReg = instRt;
		end
		
		`INSTRUCTION_LS: begin
			instSource1 = instRs;
			instSource2 = instRt;
			instSource3 = 0;
			instDestReg = instRt;
		end
		
		`INSTRUCTION_CF: begin
			instSource1 = 0;
			instSource2 = 0;
			instSource3 = 0;
			instDestReg = 0;
		end
		
		default: begin
		
		end
		endcase
	end
	
	
	
	
	
	
	always @(*) begin: DECODE	
		case(opcode_used)
			`NOP: begin
				instSource1Valid 	= 0;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 0;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			
			//**Arithmetic**
			`ADD_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`SUB_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`MUL_LO_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`MUL_HI_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`MAD_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 1'b1;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`DIV_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`REM_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`ABS_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`NEG_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`MIN_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`MAX_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			
			
			
			//**
			`ADDI_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`SUBI_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`MULI_LO_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`MULI_HI_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`ADDI_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`DIVI_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`REMI_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`MINI_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`MAXI_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			
			
			
			//**
			`SETP_EQ_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`SETP_NE_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`SETP_LT_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`SETP_LE_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`SETP_GT_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`SETP_GE_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			
			
			
			//**
			`SETPI_EQ_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`SETPI_NE_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`SETPI_LT_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`SETPI_LE_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`SETPI_GT_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`SETPI_GE_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			
			
			
			//**
			`MOV: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`MOVI: begin
				instSource1Valid 	= 0;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`MOV_SR: begin
				instSource1Valid 	= 0;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 1'b1;
				ldstSpace		= 0;
			end
			
			`SELP: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 1'b1;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`CVT_F32_S32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`CVT_S32_F32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			
			
			
			//**Logical**
			`AND: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`OR: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`XOR: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`NOT: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`CNOT: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`SHL: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`SHR: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			
			
			
			//**
			`ANDI: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`ORI: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`XORI: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`SHLI: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`SHRI: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			
			
			
			//**Memory Access**
			`LD_GLOBAL: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 1'b1;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= `LDST_GLOBAL;
			end
			
			`LD_SHARED: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 1'b1;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= `LDST_SHARED;
			end
			
			`ST_GLOBAL: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 0;
				instLoad		= 0;
				instStore		= 1'b1;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= `LDST_GLOBAL;
			end
			
			`ST_SHARED: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 0;
				instLoad		= 0;
				instStore		= 1'b1;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= `LDST_SHARED;
			end
			
			
			


			
			//*Control Flow*
			`BRA: begin
				instSource1Valid 	= 0;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 0;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 1'b1;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`BAR_SYNC: begin
				instSource1Valid 	= 0;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 0;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 1'b1;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`EXIT: begin
				instSource1Valid 	= 0;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 0;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 1'b1;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			
			
			
			
			//**Float Arithmetic**
			`ADD_F32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`SUB_F32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`MUL_LO_F32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`MUL_HI_F32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`MAD_F32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 1'b1;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`DIV_F32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`REM_F32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`ABS_F32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`NEG_F32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`MIN_F32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`MAX_F32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 1'b1;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			
			
			
			//**
			`ADDI_F32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`SUBI_F32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`MULI_LO_F32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`MULI_HI_F32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`ADDI_F32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`DIVI_F32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`REMI_F32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`MINI_F32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end
			
			`MAXI_F32: begin
				instSource1Valid 	= 1'b1;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 1'b1;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;
				ldstSpace		= 0;
			end			
			
			default: begin
				instSource1Valid 	= 0;
				instSource2Valid 	= 0;
				instSource3Valid 	= 0;
				instDestRegValid 		= 0;
				instLoad		= 0;
				instStore		= 0;
				instbranch		= 0;	
				instSync		= 0;
				instExit		= 0;
				instSRValid		= 0;			
				ldstSpace		= 0;
			end
		endcase 	
	end
			
endmodule
