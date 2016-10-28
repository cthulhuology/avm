// stack.v
//
// AVM stack in Verilog 
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

module stack( reset, clock, nip, dup, we, data_in, tos_out, nos_out);
	input reset;
	input clock;
	input nip;
	input dup;
	input we;
	input [`BITS-1:0] data_in;
	output [`BITS-1:0] tos_out;
	output [`BITS-1:0] nos_out;
	
	reg [`BITS-1:0] nos;
	reg [`BITS-1:0] tos;
	reg [`PTR-1:0] sp;
	reg [`PTR-1:0] nsp;
	reg [`BITS-1:0] cells[`DEPTH-1:0];

	always @* begin
		nsp = sp - 1;
	end

	assign tos_out = cells[sp];
	assign nos_out = cells[nsp];

	always @(posedge clock) begin
		if (reset) begin
			sp = `PTR 'b0000;
			cells[sp] =  `BITS 'b0;
			tos = `BITS 'b0;
			nos = `BITS 'b0;
		end

		tos = cells[sp];
		nos = cells[nsp];

		if (nip & !dup) begin	// nip
			sp = sp - 1;
		end

		if (dup & !nip) begin	// dup
			sp = sp + 1;
		end

		if (dup & nip) begin	// swap
			cells[nsp] = tos;
			tos = nos;	
		end

		if (we) begin
			tos = data_in;
		end
	
		cells[sp] = tos;
	
	end

endmodule
