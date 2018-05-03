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
//----------------------------
//**Simulation Signal**
//----------------------------
`define SIZE_SIMULATION		32
//----------------------------



//----------------------------
//**Kernel Config**
//----------------------------
/*
`define	NCTA_X 			4
`define NCTA_Y 			2
`define NCTA_Z 			1
`define	NT_X 			8
`define NT_Y 			4
`define NT_Z 			1
*/
//----------------------------



//----------------------------
//**Fetch Config**
//----------------------------
`define ROM_DEPTH         512
`define ROM_DEPTH_LOG     9
	//*Fetch Config for Multi-Thread*
	`define PREWARP_START	  4'b11 		//???
	`define WARP0_START       32'b00000000_00000000_00000000_00000000
	`define WARP1_START       32'b00000000_00000000_00000000_00000010
	`define WARP2_START       32'b00000000_00000000_00000000_00000100
	`define WARP3_START       32'b00000000_00000000_00000000_00000110
	`define WARP0_END         32'b00000000_00000000_11111111_00000000
	`define WARP1_END         32'b00000000_00000000_11111111_00000010
	`define WARP2_END         32'b00000000_00000000_11111111_00000100
	`define WARP3_END         32'b00000000_00000000_11111111_00000110
	`define SIZE_ADDR         32//useless???
//----------------------------



//----------------------------
//**Multi-Thread and Multi-Fetch Config**
//----------------------------
`define SIZE_SM				4	
`define SIZE_SM_LOG			2
`define SIZE_GRAN			20			//max: 1024 cycles					
`define NUM_WARP      		4			//"SIZE_WARP"
`define NUM_WARP_LOG      	2			//"SIZE_WARP_LOG"
`define NUM_ENTRY     		2
`define NUM_ENTRY_LOG		1
//----------------------------
//**SIMD Config**
//----------------------------
`define SIZE_CORE               32		//"SIMD_WIDTH"
`define SIZE_CORE_LOG           5		//"SIMD_WIDTH_LOG"
`define SIMT_STACK_DEPTH		64	
`define SIMT_STACK_DEPTH_LOG	6
//----------------------------



//----------------------------
//**Data Design**
//----------------------------
`define SIZE_DATA              	32
`define SIZE_PREDEFINED			16
//----------------------------



//----------------------------
//**ISA Design**
//----------------------------
`define SIZE_PC           32
`define SIZE_INSTRUCTION  64
`define SIZE_RP		      5
`define SIZE_OPCODE       16
`define SIZE_OPCODE_USED  7
`define SIZE_REGFILE      8
`define SIZE_RS           8 
`define SIZE_RT           8
`define SIZE_RD           8 
`define SIZE_RU           8
`define SIZE_IMMEDIATE    16
`define SIZE_RECONV       16
`define SIZE_TARGET       16

	//----------------------------
	//*Register Access*
	`define SIZE_REGFILE_BR	    	5	//basic register
	`define SIZE_REGFILE_SR    		5	//special reg
	`define REGFILE_BR_DEPTH    	(`NUM_WARP*32)	
	`define REGFILE_BR_INDEX    	(`NUM_WARP_LOG+`SIZE_REGFILE_BR)	
	`define REGFILE_SR_DEPTH    	(`NUM_WARP*8)	
	`define REGFILE_SR_INDEX    	(`NUM_WARP_LOG+`SIZE_REGFILE_SR)
	//*Register Type*
	`define SIZE_REGFILE_TYPES		8
	`define SIZE_REG_TYPES_LOG   	3	
		//including:
		`define REG_TYPE_S				3'b000
		`define REG_TYPE_SR				3'b111
	
	//----------------------------
	//**Instruction Type**
	`define INSTRUCTION_TYPES      	16	//6
	`define INST_TYPES_LOG         	4
	
	
	//----------------------------
	//*Load/Store Space*
	`define LDST_SPACE	         	4
	`define LDST_SPACE_LOG         	2
		//including:
		`define LDST_GLOBAL             2'b00
		`define LDST_SHARED         	2'b01
		`define LDST_LOCAL              2'b10
		`define LDST_CONST       	    2'b11
	//*Load/Store Types*
	`define LDST_TYPES	         	4
	`define LDST_TYPES_LOG         	2
		//including:
		`define LDST_BYTE              	2'b00
		`define LDST_HALF_WORD         	2'b01
		`define LDST_WORD              	2'b10
		`define LDST_DOUBLE_WORD       	2'b11
		
	//----------------------------
	//*Predefined Register Code Number*
	`define SR_TID_X 				5'b00001
	`define SR_TID_Y 				5'b00010
	`define SR_TID_Z 				5'b00011
	`define SR_NTID_X 				5'b00100
	`define SR_NTID_Y 				5'b00101
	`define SR_NTID_Z 				5'b00110
	`define SR_CTAID_X 				5'b00111
	`define SR_CTAID_Y 				5'b01000
	`define SR_CTAID_Z 				5'b01001
	`define SR_NCTAID_X 			5'b01010
	`define SR_NCTAID_Y 			5'b01011
	`define SR_NCTAID_Z 			5'b01100
//----------------------------