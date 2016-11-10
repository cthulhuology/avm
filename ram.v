// ram.v
// 
// 16bit ram block with 4k of memory
//
// AVM ram block in Verilog 
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

module ram (
	input clock,
	input re,
	input we,
	input [`BITS-1:0] src_addr,
	input [`BITS-1:0] dst_addr,
	input [`BITS-1:0] data_in,
	output [`BITS-1:0] data_out);

	reg [10:0] _src;
	reg [10:0] _dst;

	always @* begin
		_src <= src_addr[10:0];
		_dst <= dst_addr[10:0];
	end

	SB_RAM40_4K #(
		.WRITE_MODE(3),
		.READ_MODE(3),
		.INIT_0(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_1(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_2(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_3(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_4(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_5(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_6(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_7(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_8(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_9(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_A(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_B(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_C(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_D(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_E(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_F(256'h0000000000000000000000000000000000000000000000000000000000000000)
	) _ram00 (
		.RDATA(data_out[1:0]),
		.RADDR(_src),
		.RCLK(clock),
		.RCLKE(1'b1),
		.RE(re),
		.WDATA(data_in[1:0]),
		.WADDR(_dst),
		.WCLK(clock),
		.WCLKE(1'b1),
		.WE(we),
		.MASK(16'h0000));

	SB_RAM40_4K #(
		.WRITE_MODE(3),
		.READ_MODE(3),
		.INIT_0(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_1(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_2(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_3(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_4(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_5(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_6(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_7(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_8(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_9(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_A(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_B(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_C(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_D(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_E(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_F(256'h0000000000000000000000000000000000000000000000000000000000000000)
	) _ram01 (
		.RDATA(data_out[3:2]),
		.RADDR(_src),
		.RCLK(clock),
		.RCLKE(1'b1),
		.RE(re),
		.WDATA(data_in[3:2]),
		.WADDR(_dst),
		.WCLK(clock),
		.WCLKE(1'b1),
		.WE(we),
		.MASK(16'h0000));

	SB_RAM40_4K #(
		.WRITE_MODE(3),
		.READ_MODE(3),
		.INIT_0(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_1(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_2(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_3(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_4(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_5(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_6(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_7(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_8(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_9(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_A(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_B(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_C(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_D(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_E(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_F(256'h0000000000000000000000000000000000000000000000000000000000000000)
	) _ram02 (
		.RDATA(data_out[5:4]),
		.RADDR(_src),
		.RCLK(clock),
		.RCLKE(1'b1),
		.RE(re),
		.WDATA(data_in[5:4]),
		.WADDR(_dst),
		.WCLK(clock),
		.WCLKE(1'b1),
		.WE(we),
		.MASK(16'h0000));

	SB_RAM40_4K #(
		.WRITE_MODE(3),
		.READ_MODE(3),
		.INIT_0(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_1(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_2(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_3(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_4(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_5(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_6(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_7(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_8(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_9(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_A(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_B(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_C(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_D(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_E(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_F(256'h0000000000000000000000000000000000000000000000000000000000000000)
	) _ram03 (
		.RDATA(data_out[7:6]),
		.RADDR(_src),
		.RCLK(clock),
		.RCLKE(1'b1),
		.RE(re),
		.WDATA(data_in[7:6]),
		.WADDR(_dst),
		.WCLK(clock),
		.WCLKE(1'b1),
		.WE(we),
		.MASK(16'h0000));

	SB_RAM40_4K #(
		.WRITE_MODE(3),
		.READ_MODE(3),
		.INIT_0(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_1(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_2(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_3(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_4(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_5(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_6(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_7(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_8(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_9(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_A(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_B(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_C(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_D(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_E(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_F(256'h0000000000000000000000000000000000000000000000000000000000000000)
	) _ram04 (
		.RDATA(data_out[9:8]),
		.RADDR(_src),
		.RCLK(clock),
		.RCLKE(1'b1),
		.RE(re),
		.WDATA(data_in[9:8]),
		.WADDR(_dst),
		.WCLK(clock),
		.WCLKE(1'b1),
		.WE(we),
		.MASK(16'h0000));

	SB_RAM40_4K #(
		.WRITE_MODE(3),
		.READ_MODE(3),
		.INIT_0(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_1(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_2(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_3(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_4(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_5(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_6(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_7(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_8(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_9(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_A(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_B(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_C(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_D(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_E(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_F(256'h0000000000000000000000000000000000000000000000000000000000000000)
	) _ram05 (
		.RDATA(data_out[11:10]),
		.RADDR(_src),
		.RCLK(clock),
		.RCLKE(1'b1),
		.RE(re),
		.WDATA(data_in[11:10]),
		.WADDR(_dst),
		.WCLK(clock),
		.WCLKE(1'b1),
		.WE(we),
		.MASK(16'h0000));

	SB_RAM40_4K #(
		.WRITE_MODE(3),
		.READ_MODE(3),
		.INIT_0(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_1(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_2(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_3(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_4(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_5(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_6(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_7(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_8(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_9(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_A(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_B(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_C(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_D(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_E(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_F(256'h0000000000000000000000000000000000000000000000000000000000000000)
	) _ram06 (
		.RDATA(data_out[13:12]),
		.RADDR(_src),
		.RCLK(clock),
		.RCLKE(1'b1),
		.RE(re),
		.WDATA(data_in[13:12]),
		.WADDR(_dst),
		.WCLK(clock),
		.WCLKE(1'b1),
		.WE(we),
		.MASK(16'h0000));

	SB_RAM40_4K #(
		.WRITE_MODE(3),
		.READ_MODE(3),
		.INIT_0(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_1(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_2(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_3(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_4(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_5(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_6(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_7(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_8(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_9(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_A(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_B(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_C(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_D(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_E(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_F(256'h0000000000000000000000000000000000000000000000000000000000000000)
	) _ram07 (
		.RDATA(data_out[15:14]),
		.RADDR(_src),
		.RCLK(clock),
		.RCLKE(1'b1),
		.RE(re),
		.WDATA(data_in[15:14]),
		.WADDR(_dst),
		.WCLK(clock),
		.WCLKE(1'b1),
		.WE(we),
		.MASK(16'h0000));

endmodule
//
