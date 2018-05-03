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
/*
Simple PTX
2012/11/26
*/


//---------------------------------------------

//---------------------------------------------


`define INSTRUCTION_NOP	      	4'b0000     // Void
`define INSTRUCTION_INT_R      	4'b0001     // Int Unit R
`define INSTRUCTION_INT_I      	4'b0010   	// Int Unit I
`define INSTRUCTION_FP_R      	4'b0011     // FP Unit R
`define INSTRUCTION_FP_I      	4'b0100     // FP Unit I
`define INSTRUCTION_SF_R      	4'b0101     // SFU R
`define INSTRUCTION_SF_I      	4'b0110     // SFU I
`define INSTRUCTION_LS      	4'b0111     // LOAD/STORE 
`define INSTRUCTION_CF      	4'b1000  	// Control FLow


//**Nop**
`define 	NOP	7'b0000000


//**Arithmetic**
`define 	ADD_S32		7'b0000001// R: <rs, rt, rd, ru>; R[rd] = R[rs] + R[rt]
`define 	SUB_S32		7'b0000010// R: <rs, rt, rd, ru>; R[rd] = R[rs] - R[rt]
`define 	MUL_LO_S32	7'b0000011// R: <rs, rt, rd, ru>; R[rd] = Lo(R[rs] * R[rt])
`define 	MUL_HI_S32	7'b0000100// R: <rs, rt, rd, ru>; R[rd] = Hi(R[rs] * R[rt])
`define 	MAD_S32		7'b0000101// R: <rs, rt, rd, ru>; R[rd] = (R[rs] * R[rt]) + R[ru]
`define 	DIV_S32		7'b0000110// R: <rs, rt, rd, ru>; R[rd] = R[rs] / R[rt]
`define 	REM_S32		7'b0000111// R: <rs, rt, rd, ru>; R[rd] = R[rs] % R[rt]
`define 	ABS_S32		7'b0001000// R: <rs, rt, rd, ru>; R[rd] = |R[rs]|
`define 	NEG_S32		7'b0001001// R: <rs, rt, rd, ru>; R[rd] = 0 - R[rs]
`define 	MIN_S32		7'b0001010// R: <rs, rt, rd, ru>; R[rd] = (R[rs] < R[rt]) ? R[rs]:R[rt]
`define 	MAX_S32		7'b0001011// R: <rs, rt, rd, ru>; R[rd] = (R[rs] > R[rt]) ? R[rs]:R[rt]

`define 	ADDI_S32	7'b1000001// I: <rs, rt,  Imm  >; R[rt] = R[rs] + SignExtImm
`define 	SUBI_S32	7'b1000010// I: <rs, rt,  Imm  >; R[rt] = R[rs] - SignExtImm
`define 	MULI_LO_S32	7'b1000011// I: <rs, rt,  Imm  >; R[rt] = Lo(R[rs] * SignExtImm)
`define 	MULI_HI_S32	7'b1000100// I: <rs, rt,  Imm  >; R[rt] = Hi(R[rs] + SignExtImm)
`define 	DIVI_S32	7'b1000110// I: <rs, rt,  Imm  >; R[rt] = R[rs] / SignExtImm
`define 	REMI_S32	7'b1000111// I: <rs, rt,  Imm  >; R[rt] = R[rs] % SignExtImm
`define 	MINI_S32	7'b1001010// I: <rs, rt,  Imm  >; R[rt] = (R[rs] < SignExtImm) ? R[rs]:SignExtImm
`define 	MAXI_S32	7'b1001011// I: <rs, rt,  Imm  >; R[rt] = (R[rs] > SignExtImm) ? R[rs]:SignExtImm

`define 	SETP_EQ_S32		7'b0010000// R: <rs, rt, rd, ru>; R[rd] = (R[rs] == R[rt])
`define 	SETP_NE_S32		7'b0010001// R: <rs, rt, rd, ru>; R[rd] = (R[rs] != R[rt])
`define 	SETP_LT_S32		7'b0010010// R: <rs, rt, rd, ru>; R[rd] = (R[rs] < R[rt])
`define 	SETP_LE_S32		7'b0010011// R: <rs, rt, rd, ru>; R[rd] = (R[rs] <= R[rt])
`define 	SETP_GT_S32		7'b0010100// R: <rs, rt, rd, ru>; R[rd] = (R[rs] > R[rt])
`define 	SETP_GE_S32		7'b0010101// R: <rs, rt, rd, ru>; R[rd] = (R[rs] >= R[rt])

`define 	SETPI_EQ_S32	7'b1010000// I: <rs, rt,  Imm  >; R[rt] = (R[rs] == SignExtImm)
`define 	SETPI_NE_S32	7'b1010001// I: <rs, rt,  Imm  >; R[rt] = (R[rs] != SignExtImm)
`define 	SETPI_LT_S32	7'b1010010// I: <rs, rt,  Imm  >; R[rt] = (R[rs] < SignExtImm)
`define 	SETPI_LE_S32	7'b1010011// I: <rs, rt,  Imm  >; R[rt] = (R[rs] <= SignExtImm)
`define 	SETPI_GT_S32	7'b1010100// I: <rs, rt,  Imm  >; R[rt] = (R[rs] > SignExtImm)
`define 	SETPI_GE_S32	7'b1010101// I: <rs, rt,  Imm  >; R[rt] = (R[rs] >= SignExtImm)

`define 	MOV		7'b0100000// I: <rs, rt,  Imm  >; R[rt] = R[rs]			//*INSTRUCTION_INT_I
`define 	MOVI	7'b1100000// I: <rs, rt,  Imm  >; R[rt] = SignExtImm
`define 	MOV_SR	7'b0111000// I: <rs, rt,  Imm  >; R[rt] = SR[rs]

`define 	SELP	7'b0100010// R: <rs, rt, rd, ru>; R[rd] = R[ru] ? R[rs]:R[rt]
`define 	CVT_F32_S32		7'b0100011// I: <rs, rt,  Imm  >; R[rt] = S32_to_F32(R[rs])
`define 	CVT_S32_F32		7'b0100100// I: <rs, rt,  Imm  >; R[rt] = F32_to_S32(R[rs])


//**Logical**
`define 	AND		7'b0100101// R: <rs, rt, rd, ru>; R[rd] = R[rs] & R[rt]
`define 	OR		7'b0100110// R: <rs, rt, rd, ru>; R[rd] = R[rs] | R[rt]
`define 	XOR		7'b0100111// R: <rs, rt, rd, ru>; R[rd] = R[rs] ^ R[rt]
`define 	NOT		7'b0101000// R: <rs, rt, rd, ru>; R[rd] = ~R[rs]
`define 	CNOT	7'b0101001// R: <rs, rt, rd, ru>; R[rd] = (R[rs] == 0) ? 1:0
`define 	SHL		7'b0101010// R: <rs, rt, rd, ru>; R[rd] = R[rs] << R[rt]
`define 	SHR		7'b0101011// R: <rs, rt, rd, ru>; R[rd] = R[rs] >> R[rt]

`define 	ANDI	7'b1100101// I: <rs, rt,  Imm  >; R[rt] = R[rs] & SignExtImm
`define 	ORI		7'b1100110// I: <rs, rt,  Imm  >; R[rt] = R[rs] | SignExtImm
`define 	XORI	7'b1100111// I: <rs, rt,  Imm  >; R[rt] = R[rs] ^ SignExtImm
`define 	SHLI	7'b1101010// I: <rs, rt,  Imm  >; R[rt] = R[rs] << SignExtImm
`define 	SHRI	7'b1101011// I: <rs, rt,  Imm  >; R[rt] = R[rs] >> SignExtImm


//**Memory Access**
`define 	LD_GLOBAL	7'b0110001// I: <rs, rt,  Imm  >; R[rt] = Data_Memory(R[rs] + SignExtImm)
`define 	LD_SHARED	7'b0110010// I: <rs, rt,  Imm  >; R[rt] = Shared_Memory(R[rs] + SignExtImm)
`define 	ST_GLOBAL	7'b0110011// I: <rs, rt,  Imm  >; Data_Memory(R[rs] + SignExtImm) = R[rt]
`define 	ST_SHARED	7'b0110100// I: <rs, rt,  Imm  >; Shared_Memory(R[rs] + SignExtImm) = R[rt]


//**Control flow**
`define 	BRA			7'b0110101// J: < RPC , Target >; PC = {Target}

`define 	BAR_SYNC	7'b1111110
`define 	EXIT		7'b1111111




//**FLoat Arithmetic**
`define 	ADD_F32		7'b0000001// R: <rs, rt, rd, ru>; R[rd] = R[rs] + R[rt]
`define 	SUB_F32		7'b0000010// R: <rs, rt, rd, ru>; R[rd] = R[rs] - R[rt]
`define 	MUL_LO_F32	7'b0000011// R: <rs, rt, rd, ru>; R[rd] = Lo(R[rs] * R[rt])
`define 	MUL_HI_F32	7'b0000100// R: <rs, rt, rd, ru>; R[rd] = Hi(R[rs] * R[rt])
`define 	MAD_F32		7'b0000101// R: <rs, rt, rd, ru>; R[rd] = (R[rs] * R[rt]) + R[ru]
`define 	DIV_F32		7'b0000110// R: <rs, rt, rd, ru>; R[rd] = R[rs] / R[rt]
`define 	REM_F32		7'b0000111// R: <rs, rt, rd, ru>; R[rd] = R[rs] % R[rt]
`define 	ABS_F32		7'b0001000// R: <rs, rt, rd, ru>; R[rd] = |R[rs]|
`define 	NEG_F32		7'b0001001// R: <rs, rt, rd, ru>; R[rd] = 0 - R[rs]
`define 	MIN_F32		7'b0001010// R: <rs, rt, rd, ru>; R[rd] = (R[rs] < R[rt]) ? R[rs]:R[rt]
`define 	MAX_F32		7'b0001011// R: <rs, rt, rd, ru>; R[rd] = (R[rs] > R[rt]) ? R[rs]:R[rt]

`define 	ADDI_F32	7'b1000001// I: <rs, rt,  Imm  >; R[rt] = R[rs] + SignExtImm
`define 	SUBI_F32	7'b1000010// I: <rs, rt,  Imm  >; R[rt] = R[rs] - SignExtImm
`define 	MULI_LO_F32	7'b1000011// I: <rs, rt,  Imm  >; R[rt] = Lo(R[rs] * SignExtImm)
`define 	MULI_HI_F32	7'b1000100// I: <rs, rt,  Imm  >; R[rt] = Hi(R[rs] + SignExtImm)
`define 	DIVI_F32	7'b1000110// I: <rs, rt,  Imm  >; R[rt] = R[rs] / SignExtImm
`define 	REMI_F32	7'b1000111// I: <rs, rt,  Imm  >; R[rt] = R[rs] % SignExtImm
`define 	MINI_F32	7'b1001010// I: <rs, rt,  Imm  >; R[rt] = (R[rs] < SignExtImm) ? R[rs]:SignExtImm
`define 	MAXI_F32	7'b1001011// I: <rs, rt,  Imm  >; R[rt] = (R[rs] > SignExtImm) ? R[rs]:SignExtImm