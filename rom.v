// rom.v
// 
// 16bit rom block with 4k of memory
//
// AVM rom block in Verilog 
//
// This is an implementation of AVM in C for experimenation purposes.
// It is both an AVM interpretr and an assembler for the instruction set.
//
// (C) 2016 David J. Goehrig
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
// 
// 1. Redistributions of source code must retain the above copyright notice, 
// this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation 
// and/or other materials provided with the distribution.
// 
// 3. Neither the name of the copyright holder nor the names of its contributors 
// may be used to endorse or promote products derived from this software without
// specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF 
// THE POSSIBILITY OF SUCH DAMAGE.
//


`include "avm.vh"

module rom (
	input clock,
	input re,
	input [`BITS-1:0] src_addr,
	output [`BITS-1:0] data_out);

	reg [10:0] _src;

	always @* begin
		_src <= src_addr[10:0];
	end

	SB_RAM2048x2 #(
`include "rom00.blk"
	) _rom00 (
		.RDATA(data_out[1:0]),
		.RADDR(_src),
		.RCLK(clock),
		.RCLKE(1'b1),
		.RE(re),
		.WDATA(2'bxx),
		.WADDR(11'b0),
		.WCLK(clock),
		.WCLKE(1'b0),
		.WE(1'b0),
		.MASK(16'h0000));

	SB_RAM2048x2 #(
`include "rom01.blk"
	) _rom01 (
		.RDATA(data_out[3:2]),
		.RADDR(_src),
		.RCLK(clock),
		.RCLKE(1'b1),
		.RE(re),
		.WDATA(2'bxx),
		.WADDR(11'b0),
		.WCLK(clock),
		.WCLKE(1'b0),
		.WE(1'b0),
		.MASK(16'h0000));

	SB_RAM2048x2 #(
`include "rom02.blk"
	) _rom02 (
		.RDATA(data_out[5:4]),
		.RADDR(_src),
		.RCLK(clock),
		.RCLKE(1'b1),
		.RE(re),
		.WDATA(2'bxx),
		.WADDR(11'b0),
		.WCLK(clock),
		.WCLKE(1'b0),
		.WE(1'b0),
		.MASK(16'h0000));

	SB_RAM2048x2 #(
`include "rom03.blk"
	) _rom03 (
		.RDATA(data_out[7:6]),
		.RADDR(_src),
		.RCLK(clock),
		.RCLKE(1'b1),
		.RE(re),
		.WDATA(2'bxx),
		.WADDR(11'b0),
		.WCLK(clock),
		.WCLKE(1'b0),
		.WE(1'b0),
		.MASK(16'h0000));

	SB_RAM2048x2 #(
`include "rom04.blk"
	) _rom04 (
		.RDATA(data_out[9:8]),
		.RADDR(_src),
		.RCLK(clock),
		.RCLKE(1'b1),
		.RE(re),
		.WDATA(2'bxx),
		.WADDR(11'b0),
		.WCLK(clock),
		.WCLKE(1'b0),
		.WE(1'b0),
		.MASK(16'h0000));

	SB_RAM2048x2 #(
`include "rom05.blk"
		) _rom05 (
		.RDATA(data_out[11:10]),
		.RADDR(_src),
		.RCLK(clock),
		.RCLKE(1'b1),
		.RE(re),
		.WDATA(2'bxx),
		.WADDR(11'b0),
		.WCLK(clock),
		.WCLKE(1'b0),
		.WE(1'b0),
		.MASK(16'h0000));

	SB_RAM2048x2 #(
`include "rom06.blk"	
	) _rom06 (
		.RDATA(data_out[13:12]),
		.RADDR(_src),
		.RCLK(clock),
		.RCLKE(1'b1),
		.RE(re),
		.WDATA(2'bxx),
		.WADDR(11'b0),
		.WCLK(clock),
		.WCLKE(1'b0),
		.WE(1'b0),
		.MASK(16'h0000));

	SB_RAM2048x2 #(
`include "rom07.blk"	
	) _rom07 (
		.RDATA(data_out[15:14]),
		.RADDR(_src),
		.RCLK(clock),
		.RCLKE(1'b1),
		.RE(re),
		.WDATA(2'bxx),
		.WADDR(11'b0),
		.WCLK(clock),
		.WCLKE(1'b0),
		.WE(1'b0),
		.MASK(16'h0000));

endmodule
//
