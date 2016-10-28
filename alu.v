// alu.v
//
// AVM alu in Verilog 
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

module alu (
	input clock,
	input [7:0] opcode,
	input [`BITS-1:0] tos,
	input [`BITS-1:0] nos,
	output [`BITS-1:0] alu_out);

	reg [`BITS-1:0] _tos;

	assign alu_out = _tos;
	
	always @(posedge clock) begin
	case(opcode)
	// math
	8'b0000_0100:
		_tos <= - tos;
	8'b0000_0101:
		_tos <= nos + tos;
	8'b0000_0110:
		_tos <= nos * tos;
	8'b0000_0111:
		_tos <= nos / tos;

	// logic
	8'b0000_1000:
		_tos <= ~ tos;
	8'b0000_1001:
		_tos <= nos & tos;
	8'b0000_1010:
		_tos <= nos | tos;
	8'b0000_1011:
		_tos <= nos ^ tos;

	default:
		_tos <= tos;		

	endcase	
	end

endmodule
