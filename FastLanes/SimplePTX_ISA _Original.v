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



//**Nop**
`define 	NOP	11'b0000_0000000


//**Arithmetic**
`define 	ADD_S32		11'b0001_0000001// R: <rs, rt, rd, ru>; R[rd] = R[rs] + R[rt]
`define 	SUB_S32		11'b0001_0000010// R: <rs, rt, rd, ru>; R[rd] = R[rs] - R[rt]
`define 	MUL_LO_S32	11'b0001_0000011// R: <rs, rt, rd, ru>; R[rd] = Lo(R[rs] * R[rt])
`define 	MUL_HI_S32	11'b0001_0000100// R: <rs, rt, rd, ru>; R[rd] = Hi(R[rs] * R[rt])
`define 	MAD_S32		11'b0001_0000101// R: <rs, rt, rd, ru>; R[rd] = (R[rs] * R[rt]) + R[ru]
`define 	DIV_S32		11'b0001_0000110// R: <rs, rt, rd, ru>; R[rd] = R[rs] / R[rt]
`define 	REM_S32		11'b0001_0000111// R: <rs, rt, rd, ru>; R[rd] = R[rs] % R[rt]
`define 	ABS_S32		11'b0001_0001000// R: <rs, rt, rd, ru>; R[rd] = |R[rs]|
`define 	NEG_S32		11'b0001_0001001// R: <rs, rt, rd, ru>; R[rd] = 0 - R[rs]
`define 	MIN_S32		11'b0001_0001010// R: <rs, rt, rd, ru>; R[rd] = (R[rs] < R[rt]) ? R[rs]:R[rt]
`define 	MAX_S32		11'b0001_0001011// R: <rs, rt, rd, ru>; R[rd] = (R[rs] > R[rt]) ? R[rs]:R[rt]

`define 	ADDI_S32	11'b0010_1000001// I: <rs, rt,  Imm  >; R[rt] = R[rs] + SignExtImm
`define 	SUBI_S32	11'b0010_1000010// I: <rs, rt,  Imm  >; R[rt] = R[rs] - SignExtImm
`define 	MULI_LO_S32	11'b0010_1000011// I: <rs, rt,  Imm  >; R[rt] = Lo(R[rs] * SignExtImm)
`define 	MULI_HI_S32	11'b0010_1000100// I: <rs, rt,  Imm  >; R[rt] = Hi(R[rs] + SignExtImm)
`define 	DIVI_S32	11'b0010_1000110// I: <rs, rt,  Imm  >; R[rt] = R[rs] / SignExtImm
`define 	REMI_S32	11'b0010_1000111// I: <rs, rt,  Imm  >; R[rt] = R[rs] % SignExtImm
`define 	MINI_S32	11'b0010_1001010// I: <rs, rt,  Imm  >; R[rt] = (R[rs] < SignExtImm) ? R[rs]:SignExtImm
`define 	MAXI_S32	11'b0010_1001011// I: <rs, rt,  Imm  >; R[rt] = (R[rs] > SignExtImm) ? R[rs]:SignExtImm

`define 	SETP_EQ_S32		11'b0001_0010000// R: <rs, rt, rd, ru>; R[rd] = (R[rs] == R[rt])
`define 	SETP_NE_S32		11'b0001_0010001// R: <rs, rt, rd, ru>; R[rd] = (R[rs] != R[rt])
`define 	SETP_LT_S32		11'b0001_0010010// R: <rs, rt, rd, ru>; R[rd] = (R[rs] < R[rt])
`define 	SETP_LE_S32		11'b0001_0010011// R: <rs, rt, rd, ru>; R[rd] = (R[rs] <= R[rt])
`define 	SETP_GT_S32		11'b0001_0010100// R: <rs, rt, rd, ru>; R[rd] = (R[rs] > R[rt])
`define 	SETP_GE_S32		11'b0001_0010101// R: <rs, rt, rd, ru>; R[rd] = (R[rs] >= R[rt])

`define 	SETPI_EQ_S32	11'b0010_1010000// I: <rs, rt,  Imm  >; R[rt] = (R[rs] == SignExtImm)
`define 	SETPI_NE_S32	11'b0010_1010001// I: <rs, rt,  Imm  >; R[rt] = (R[rs] != SignExtImm)
`define 	SETPI_LT_S32	11'b0010_1010010// I: <rs, rt,  Imm  >; R[rt] = (R[rs] < SignExtImm)
`define 	SETPI_LE_S32	11'b0010_1010011// I: <rs, rt,  Imm  >; R[rt] = (R[rs] <= SignExtImm)
`define 	SETPI_GT_S32	11'b0010_1010100// I: <rs, rt,  Imm  >; R[rt] = (R[rs] > SignExtImm)
`define 	SETPI_GE_S32	11'b0010_1010101// I: <rs, rt,  Imm  >; R[rt] = (R[rs] >= SignExtImm)

`define 	MOV		11'b0001_0100000// I: <rs, rt,  Imm  >; R[rt] = R[rs]
`define 	MOVI	11'b0010_1100000// I: <rs, rt,  Imm  >; R[rt] = SignExtImm
`define 	MOV_SR	11'b0001_0111000// I: <rs, rt,  Imm  >; R[rt] = SR[rs]

`define 	SELP	11'b0001_0100010// R: <rs, rt, rd, ru>; R[rd] = R[ru] ? R[rs]:R[rt]
`define 	CVT_F32_S32		11'b0010_0100011// I: <rs, rt,  Imm  >; R[rt] = S32_to_F32(R[rs])
`define 	CVT_S32_F32		11'b0010_0100100// I: <rs, rt,  Imm  >; R[rt] = F32_to_S32(R[rs])


//**Logical**
`define 	AND		11'b0001_0100101// R: <rs, rt, rd, ru>; R[rd] = R[rs] & R[rt]
`define 	OR		11'b0001_0100110// R: <rs, rt, rd, ru>; R[rd] = R[rs] | R[rt]
`define 	XOR		11'b0001_0100111// R: <rs, rt, rd, ru>; R[rd] = R[rs] ^ R[rt]
`define 	NOT		11'b0001_0101000// R: <rs, rt, rd, ru>; R[rd] = ~R[rs]
`define 	CNOT	11'b0001_0101001// R: <rs, rt, rd, ru>; R[rd] = (R[rs] == 0) ? 1:0
`define 	SHL		11'b0001_0101010// R: <rs, rt, rd, ru>; R[rd] = R[rs] << R[rt]
`define 	SHR		11'b0001_0101011// R: <rs, rt, rd, ru>; R[rd] = R[rs] >> R[rt]

`define 	ANDI	11'b0010_1100101// I: <rs, rt,  Imm  >; R[rt] = R[rs] & SignExtImm
`define 	ORI		11'b0010_1100110// I: <rs, rt,  Imm  >; R[rt] = R[rs] | SignExtImm
`define 	XORI	11'b0010_1100111// I: <rs, rt,  Imm  >; R[rt] = R[rs] ^ SignExtImm
`define 	SHLI	11'b0010_1101010// I: <rs, rt,  Imm  >; R[rt] = R[rs] << SignExtImm
`define 	SHRI	11'b0010_1101011// I: <rs, rt,  Imm  >; R[rt] = R[rs] >> SignExtImm


//**Memory Access**
`define 	LD_GLOBAL	11'b0111_0110001// I: <rs, rt,  Imm  >; R[rt] = Data_Memory(R[rs] + SignExtImm)
`define 	LD_SHARED	11'b0111_0110010// I: <rs, rt,  Imm  >; R[rt] = Shared_Memory(R[rs] + SignExtImm)
`define 	ST_GLOBAL	11'b0111_0110011// I: <rs, rt,  Imm  >; Data_Memory(R[rs] + SignExtImm) = R[rt]
`define 	ST_SHARED	11'b0111_0110100// I: <rs, rt,  Imm  >; Shared_Memory(R[rs] + SignExtImm) = R[rt]


//**Control flow**
`define 	BRA			11'b1000_0110101// J: < RPC , Target >; PC = {Target}

`define 	BAR_SYNC	11'b1000_1111110
`define 	EXIT		11'b1000_1111111




//**FLoat Arithmetic**
`define 	ADD_F32		11'b0011_0000001// R: <rs, rt, rd, ru>; R[rd] = R[rs] + R[rt]
`define 	SUB_F32		11'b0011_0000010// R: <rs, rt, rd, ru>; R[rd] = R[rs] - R[rt]
`define 	MUL_LO_F32	11'b0011_0000011// R: <rs, rt, rd, ru>; R[rd] = Lo(R[rs] * R[rt])
`define 	MUL_HI_F32	11'b0011_0000100// R: <rs, rt, rd, ru>; R[rd] = Hi(R[rs] * R[rt])
`define 	MAD_F32		11'b0011_0000101// R: <rs, rt, rd, ru>; R[rd] = (R[rs] * R[rt]) + R[ru]
`define 	DIV_F32		11'b0011_0000110// R: <rs, rt, rd, ru>; R[rd] = R[rs] / R[rt]
`define 	REM_F32		11'b0011_0000111// R: <rs, rt, rd, ru>; R[rd] = R[rs] % R[rt]
`define 	ABS_F32		11'b0011_0001000// R: <rs, rt, rd, ru>; R[rd] = |R[rs]|
`define 	NEG_F32		11'b0011_0001001// R: <rs, rt, rd, ru>; R[rd] = 0 - R[rs]
`define 	MIN_F32		11'b0011_0001010// R: <rs, rt, rd, ru>; R[rd] = (R[rs] < R[rt]) ? R[rs]:R[rt]
`define 	MAX_F32		11'b0011_0001011// R: <rs, rt, rd, ru>; R[rd] = (R[rs] > R[rt]) ? R[rs]:R[rt]

`define 	ADDI_F32	11'b0100_1000001// I: <rs, rt,  Imm  >; R[rt] = R[rs] + SignExtImm
`define 	SUBI_F32	11'b0100_1000010// I: <rs, rt,  Imm  >; R[rt] = R[rs] - SignExtImm
`define 	MULI_LO_F32	11'b0100_1000011// I: <rs, rt,  Imm  >; R[rt] = Lo(R[rs] * SignExtImm)
`define 	MULI_HI_F32	11'b0100_1000100// I: <rs, rt,  Imm  >; R[rt] = Hi(R[rs] + SignExtImm)
`define 	DIVI_F32	11'b0100_1000110// I: <rs, rt,  Imm  >; R[rt] = R[rs] / SignExtImm
`define 	REMI_F32	11'b0100_1000111// I: <rs, rt,  Imm  >; R[rt] = R[rs] % SignExtImm
`define 	MINI_F32	11'b0100_1001010// I: <rs, rt,  Imm  >; R[rt] = (R[rs] < SignExtImm) ? R[rs]:SignExtImm
`define 	MAXI_F32	11'b0100_1001011// I: <rs, rt,  Imm  >; R[rt] = (R[rs] > SignExtImm) ? R[rs]:SignExtImm