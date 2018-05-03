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



module IPCore_BloRAM_SinglePort(
			  clka,
			  wea,
			  addra,
			  dina,
			  douta
			);

	/* Parameters */
	parameter SRAM_DEPTH = 32;//256;
	parameter SRAM_INDEX = 5;//8;
	parameter SRAM_WIDTH = 32;
	
	input clka;
	input [0 : 0] wea;
	input [SRAM_INDEX-1 : 0] addra;
	input [SRAM_WIDTH-1 : 0] dina;
	output reg [SRAM_WIDTH-1 : 0] douta;
	
	/* The SRAM reg */
	reg [SRAM_WIDTH-1:0] data [0:SRAM_DEPTH-1];

	integer i;

	/* Read operation */
	//assign douta = data[addra];

	/* Write operation */
	always @(posedge clka)	begin
		douta = data[addra];
		
		if(wea == 1'b1)		begin
			data[addra] <= dina;
		end
		else begin   
		end
	end
endmodule



/*
tdp_ram your_instance_name (
  .clka(clka), // input clka
  .wea(wea), // input [0 : 0] wea
  .addra(addra), // input [5 : 0] addra
  .dina(dina), // input [71 : 0] dina
  .douta(douta), // output [71 : 0] douta
  .clkb(clkb), // input clkb
  .web(web), // input [0 : 0] web
  .addrb(addrb), // input [5 : 0] addrb
  .dinb(dinb), // input [71 : 0] dinb
  .doutb(doutb) // output [71 : 0] doutb
);
*/
module IPCore_BloRAM_TrueDualPort_SIMT_Stack(
		  clka,
		  wea,
		  addra,
		  dina,
		  douta,
		  clkb,
		  web,
		  addrb,
		  dinb,
		  doutb
		);

	/* Parameters */
	parameter SRAM_DEPTH = 64;
	parameter SRAM_INDEX = 6;
	parameter SRAM_WIDTH = 72;
	
	input clka;
	input [0 : 0] wea;
	input [SRAM_INDEX-1 : 0] addra;
	input [SRAM_WIDTH-1 : 0] dina;
	output reg [SRAM_WIDTH-1 : 0] douta;
	input clkb;
	input [0 : 0] web;
	input [SRAM_INDEX-1 : 0] addrb;
	input [SRAM_WIDTH-1 : 0] dinb;
	output reg [SRAM_WIDTH-1 : 0] doutb;
	
	/* The SRAM reg */
	reg [SRAM_WIDTH-1:0] data [0:SRAM_DEPTH-1];

	/* Read operation */

	/* Write operation */
	always @(posedge clka)	begin
		douta = data[addra];
		
		if(wea == 1'b1)		begin
			data[addra] <= dina;
		end
		else begin   
		end
	
	end
	
	always @(posedge clkb)	begin
		doutb = data[addrb];
		
		if(web == 1'b1)		begin
			data[addrb] <= dinb;
		end
		else begin   
		end
	end
endmodule



	
	

/*
ram uut(
  .a(addr_w), // input [5 : 0] a
  .d(din), // input [31 : 0] d
  .dpra(addr_r), // input [5 : 0] dpra
  .clk(clk), // input clk
  .we(we), // input we
  .dpo(dout)
*/
module IPCore_DisRAM_SimplePort(
  a,//addr_write
  d,//din
  dpra,//addr_read
  clk,
  we,
  dpo//dout
);

	/* Parameters */
	parameter SRAM_DEPTH = 64;
	parameter SRAM_INDEX = 6;
	parameter DATA_WIDTH = 32;

	input [SRAM_INDEX-1 : 0] a;
	input [DATA_WIDTH-1 : 0] d;
	input [SRAM_INDEX-1 : 0] dpra;
	input clk;
	input we;
	output [DATA_WIDTH-1 : 0] dpo;
	
	/* The SRAM reg */
	reg [DATA_WIDTH-1:0] data [0:SRAM_DEPTH-1];

	/* Read operation */
	assign dpo = data[dpra];

	/* Write operation */
	always @(posedge clk)	begin
		//douta = data[addra];
		
		if(we == 1'b1)		begin
			data[a] <= d;
		end
		else begin   
		end
	end
endmodule
	
	
	
	
/*
pseudo_rom your_instance_name (
  .a(a), // input [8 : 0] a
  .d(d), // input [63 : 0] d
  .dpra(dpra), // input [8 : 0] dpra
  .clk(clk), // input clk
  .we(we), // input we
  .spo(spo), // output [63 : 0] spo
  .dpo(dpo) // output [63 : 0] dpo
);
*/
module IPCore_DisRAM_PyseudoRom(
  a, // input [8 : 0] PC0
  d, // input [63 : 0] == 64'b0
  dpra, // input [8 : 0] PC1
  clk, // input clk
  we, // input we		== 1'b0
  spo, // output [63 : 0] instruction0
  dpo // output [63 : 0] instruction1
);

	/* Parameters */
	parameter SRAM_DEPTH = 512;
	parameter SRAM_INDEX = 9;
	parameter DATA_WIDTH = 32;

	input [SRAM_INDEX-1 : 0] a;
	input [DATA_WIDTH-1 : 0] d;
	input [SRAM_INDEX-1 : 0] dpra;
	input clk;
	input we;
	output [DATA_WIDTH-1 : 0] spo;
	output [DATA_WIDTH-1 : 0] dpo;
	
	/* The SRAM reg */
	reg [DATA_WIDTH-1:0] data [0:SRAM_DEPTH-1];

	/* Read operation */
	assign spo = data[a];
	assign dpo = data[dpra];
	
	/* Write operation */
	always @(posedge clk)	begin
		//douta = data[addra];
		
		if(we == 1'b1)		begin
			data[a] <= d;
		end
		else begin   
		end
	end
endmodule







/*
IPCore_DualPort_Ram your_instance_name (
  .a(a), // input [8 : 0] a
  .d(d), // input [63 : 0] d
  .dpra(dpra), // input [8 : 0] dpra
  .clk(clk), // input clk
  .we(we), // input we
  .spo(spo), // output [63 : 0] spo
  .dpo(dpo) // output [63 : 0] dpo
);
*/
module IPCore_DualPort_DisRam(
  a, // input [8 : 0] 		addr0
  d, // input [63 : 0] 		din0
  dpra, // input [8 : 0] 	addr1
  clk, // input clk	
  we, // input we		
  spo, // output [63 : 0]	dout0 
  dpo // output [63 : 0] 	dout1
);

	/* Parameters */
	parameter SRAM_DEPTH = 512;
	parameter SRAM_INDEX = 9;
	parameter DATA_WIDTH = 32;

	input [SRAM_INDEX-1 : 0] a;
	input [DATA_WIDTH-1 : 0] d;
	input [SRAM_INDEX-1 : 0] dpra;
	input clk;
	input we;
	output [DATA_WIDTH-1 : 0] spo;
	output [DATA_WIDTH-1 : 0] dpo;
	
	/* The SRAM reg */
	reg [DATA_WIDTH-1:0] data [0:SRAM_DEPTH-1];

	/* Read operation */
	assign spo = data[a];
	assign dpo = data[dpra];
	
	/* Write operation */
	always @(posedge clk)	begin
		//douta = data[addra];
		
		if(we == 1'b1)		begin
			data[a] <= d;
		end
		else begin   
		end
	end
endmodule
