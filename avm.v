// avm.v
//
// AVM in Verilog 
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

module avm (
	// io
	input clock_in,				// clock
	input reset_in,				// reset
	input [`PINS-1:0] io_in,		// hardware input
	input [`BITS-1:0] data_in,		// ram data out
	input [`BITS-1:0] ip_in,		// rom data in
	output read_out,			// read active
	output write_out,			// write active
	output [BITS-1:0] src_addr_out,		// source ram addr
	output [BITS-1:0] dst_addr_out,		// dest ram addr 
	output [`BITS-1:0] ip_addr_out,		// rom address
	output [`BITS-1:0] data_out,		// dst data out
	output [`PINS-1:0] io_out;		// hardware output
	
	// instruction
	wire instre;				// instr read enable
	wire [`BITS-1:0] instr;			// instruction	
	wire [`BITS-1:0] imm = { 1'b0, instr[`BITS-2:0] }; // immediate value
	reg [`BITS-1:0] ip;			// instruction pointer
	reg [`BITS-1:0] flags;			// flags register
	
	// stacks
	reg [`STACK_PTR_WIDTH-1,0] dsp;		// data stack pointer
	reg [`STACK_PTR_WIDTH-1,0] rsp;		// return stack pointer
	reg [`BITS-1,0] ds[`STACK_DEPTH-1:0];	// data stack
	reg [`BITS-1,0] rs[`STACK_DEPTH-1:0];	// return stack
	wire [`BITS-1,0] tos = ds[dsp];		// top of stack
	wire [`BITS-1,0] nos = ds[dsp-1];	// next on stsack
	wire [`BITS-1,0] trs = rs[rsp];		// top of return stack
	wire dse;				// data stack write enable
	wire rse;				// return stack write enable
	
	// memory access
	reg [`BITS-1:0] dst;			// destination address
	reg [`BITS-1:0] src;			// source address
	wire dste;				// write enable
	wire srce;				// read enable

	// TODO generate ROM
	// TODO generate RAM
	
	// clock events
	
	// TODO fetch instruction from ROM
	// TODO update data stack
	// TODO update return stack
	// TODO RAM reads
	// TODO IO reads
	// TODO ALU instructions
	// TODO RAM writes
	// TODO IO  writes
	// TODO update data stack pointers
	// TODO update return stack pointers
	// TODO update instruction pointer

endmodule
