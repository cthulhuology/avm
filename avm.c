/ avm.c
//
// AVM in C
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

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

#define SIZE_OF_STACK 16
#define PTR_WIDTH 4
#define PTR_MASK 0x0f
#define RAM_SIZE 1024*4096
#define LITERAL_MASK 0x8000000000000000
#define MAX_FILES 2
#define MAX_WORDS 1024

struct {
	long value;
	char name[8];
} opcodes[32] = {
	{ 0, "nop" },
	{ 1, "call" },
	{ 2, "ret" },
	{ 3, "if" },
	{ 4, "-" },
	{ 5, "+" },
	{ 6, "*" },
	{ 7, "/" },
	{ 8, "~" },
	{ 9, "&" },
	{ 10, "|" },
	{ 11, "^" },
	{ 12, "push" },
	{ 13, "pop" },
	{ 14, "dup" },
	{ 15, "drop" },
	{ 16, "swap" },
	{ 17, "over" },
	{ 18, "!" },
	{ 19, "+!" },
	{ 20, "@" },
	{ 21, "+@" },
	{ 22, ">d" },
	{ 23, "d>" },
	{ 24, ">s" },
	{ 25, "s>" },
	{ 26, "=" },
	{ 27, ">" },
	{ 28, "<" },
	{ 29, "true" },
	{ 30, "false" },
	{ 31, "flag" }
};

struct {
	long is;
	long ip;
	long dsp;
	long rsp;
	long dst;
	long src;
	long flg;
	long ds[SIZE_OF_STACK];
	long rs[SIZE_OF_STACK];
} registers;

char* memory;

void dump_opcodes() {
	long i = 0;
	for (i = 0; i < 32; ++i) 
		printf("%s %d\n", opcodes[i].name, opcodes[i].value);
}

void boot() {
	long i = 0;
	registers.is = 0;
	registers.ip = 0;
	registers.dsp = 0;
	registers.rsp = 0;
	registers.dst = 0;
	registers.src = 0;
	registers.flg = 0;
	for (i = 0; i < SIZE_OF_STACK; ++i) 
		registers.rs[i] = registers.ds[i] = 0;
	memory = mmap(0,RAM_SIZE,PROT_READ|PROT_WRITE,MAP_ANONYMOUS|MAP_PRIVATE,-1,0);
	if (memory == MAP_FAILED) exit(3);
}

int filep = 0;
struct {
	char* filename;
	int fd;
	size_t size;
} files[MAX_FILES];

int file(char* filename) {
	int i = 0;
	for (i = 0; i < filep; ++i) 
		if (!strcmp(filename,files[i].filename)) return i;
	printf("File not found %s\n", filename);
	exit(6);
}

char* load(char* filename) {
	struct stat st;
	long fd = open(filename,O_RDWR);
	if (fd < 0) exit(1);
	fstat(fd,&st);
	char* program = mmap(0,st.st_size,PROT_READ|PROT_WRITE,MAP_SHARED,fd,0);
	if (program == MAP_FAILED) exit(2);
	files[filep].filename = filename;
	files[filep].fd = fd;
	files[filep].size = st.st_size;
	++filep;
	return program;		
}

void save(char* filename, char* data) {
	int i = file(filename);
	fstat(files[i].fd,&st);
	msync(data,files[i].size,MS_SYNC);
	munmap(data,files[i].size);
	close(files[i].fd);
}

int interpret(char* filename) {
	int op;
	long a, b;
	long* rom = (long*)load(filename);
	boot();
fetch:
	registers.is = rom[registers.ip];					// we have up to 8 instructions in the is register.
	++registers.ip;
literal:
	if (registers.is & LITERAL_MASK) {
		registers.dsp = (registers.dsp + 1) & PTR_MASK;			// increment stack pointer
		registers.ds[registers.dsp] = registers.is & ~LITERAL_MASK;	// literals are always positive numbers
		goto fetch;
	}
next:
	switch (registers.is & 0xff) {

	case 0:	// nop
		goto fetch;

	case 1:	// call
		registers.rsp = (registers.rsp + 1) & PTR_MASK;			// increment return stack pointer
		registers.rs[registers.rsp] = registers.ip;			// save next instruction pointer
		registers.ip -= registers.ds[registers.dsp];			// adjust instruction poitner by tos
		registers.dsp = (registers.dsp - 1) & PTR_MASK;			// decrement data stack pointer
		goto fetch;

	case 2:	// ret
		registers.ip = registers.rs[registers.rsp];			// restore instruction pointer
		registers.rsp = (registers.rsp - 1) & PTR_MASK;			// decrement return stack pointer
		goto fetch;

	case 3:	// if
		if (registers.ds[(registers.dsp - 1) & PTR_MASK]) {		// if nos is not false
			registers.ip -= registers.ds[registers.dsp];		// relative branch instruction pointer
			registers.dsp = (registers.dsp - 2) & PTR_MASK;		// drop both tos and nos
			goto fetch;
		}
		registers.dsp = (registers.dsp - 2) & PTR_MASK;			// otherwise drop both tos and nos
		break;

	case 4:	// neg
		registers.ds[registers.dsp] = -registers.ds[registers.dsp];
		break;

	case 5: // add
		registers.ds[(registers.dsp - 1) & PTR_MASK ] += registers.ds[registers.dsp];
		registers.dsp = (registers.dsp -1) & PTR_MASK;
		break;

	case 6: // mul
		registers.ds[(registers.dsp - 1) & PTR_MASK ] *= registers.ds[registers.dsp];
		registers.dsp = (registers.dsp -1) & PTR_MASK;
		break;

	case 7: // div
		a = registers.ds[(registers.dsp - 1) & PTR_MASK];
		b = registers.ds[registers.dsp];
		registers.ds[(registers.dsp-1)&PTR_MASK] = a / b;
		registers.ds[registers.dsp] = a % b;
		break;

	case 8: // not
		registers.ds[registers.dsp] = ~registers.ds[registers.dsp];
		break;

	case 9: // and
		registers.ds[(registers.dsp - 1) & PTR_MASK ] &= registers.ds[registers.dsp];
		registers.dsp = (registers.dsp -1) & PTR_MASK;
		break;

	case 10: // or
		registers.ds[(registers.dsp - 1) & PTR_MASK ] |= registers.ds[registers.dsp];
		registers.dsp = (registers.dsp -1) & PTR_MASK;
		break;

	case 11: // xor
		registers.ds[(registers.dsp - 1) & PTR_MASK ] ^= registers.ds[registers.dsp];
		registers.dsp = (registers.dsp -1) & PTR_MASK;
		break;

	case 12: // push
		registers.rsp = (registers.rsp + 1) & PTR_MASK;
		registers.rs[registers.rsp] = registers.ds[registers.dsp];
		registers.dsp = (registers.dsp - 1) & PTR_MASK;
		break;

	case 13: // pop
		registers.dsp = (registers.dsp + 1) & PTR_MASK;
		registers.ds[registers.dsp] = registers.rs[registers.rsp];
		registers.rsp = (registers.rsp - 1) & PTR_MASK;
		break;

	case 14: // dup
		registers.dsp = (registers.dsp + 1) & PTR_MASK;
		registers.ds[registers.dsp] = registers.ds[(registers.dsp-1)&PTR_MASK];
		break;

	case 15: // drop
		registers.dsp = (registers.dsp - 1) & PTR_MASK;
		break;

	case 16: // swap
		a = registers.ds[(registers.dsp -1) & PTR_MASK];
		b = registers.ds[registers.dsp];
		registers.ds[(registers.dsp -1) & PTR_MASK] = b;
		registers.ds[registers.dsp] = a;
		break;

	case 17: // over
		registers.dsp = (registers.dsp + 1) & PTR_MASK;
		registers.ds[registers.dsp] = registers.ds[(registers.dsp-2)&PTR_MASK];
		break;

	case 18: // store
		memory[registers.dst] = registers.ds[registers.dsp];
		++registers.dst;
		registers.dsp = (registers.dsp - 1) & PTR_MASK;
		break;

	case 19: // plus store
		memory[registers.dst] += registers.ds[registers.dsp];
		++registers.dst;
		registers.dsp = (registers.dsp - 1) & PTR_MASK;
	break;

	case 20: // fetch
		registers.dsp = (registers.dsp + 1) & PTR_MASK;
		registers.ds[registers.dsp] = memory[registers.src];
		++registers.src;
		break;

	case 21: // plus fetch
		registers.ds[registers.dsp] += memory[registers.src];
		++registers.src;
		break;

	case 22: // set dst
		registers.dst = registers.ds[registers.dsp];
		registers.dsp = (registers.dsp - 1) & PTR_MASK;
		break;

	case 23: // get dst
		registers.dsp = (registers.dsp + 1) & PTR_MASK;
		registers.ds[registers.dsp] = registers.dst;
		break;

	case 24: // set src
		registers.src = registers.ds[registers.dsp];
		registers.dsp = (registers.dsp - 1) & PTR_MASK;
		break;

	case 25: // get src
		registers.dsp = (registers.dsp + 1) & PTR_MASK;
		registers.ds[registers.dsp] = registers.src;
		break;

	case 26: // equals
		registers.ds[(registers.dsp - 1) & PTR_MASK] = 
			registers.ds[(registers.dsp - 1) & PTR_MASK] == 
			registers.ds[registers.dsp] ? -1 : 0;
		registers.dsp = (registers.dsp - 1) & PTR_MASK;
		break;

	case 27: // greater than
		registers.ds[(registers.dsp - 1) & PTR_MASK] = 
			registers.ds[(registers.dsp - 1) & PTR_MASK] > 
			registers.ds[registers.dsp] ? -1 : 0;
		registers.dsp = (registers.dsp - 1) & PTR_MASK;
		break;

	case 28: // less than
		registers.ds[(registers.dsp - 1) & PTR_MASK] = 
			registers.ds[(registers.dsp - 1) & PTR_MASK] < 
			registers.ds[registers.dsp] ? -1 : 0;
		registers.dsp = (registers.dsp - 1) & PTR_MASK;
		break;

	case 29: // true
		registers.dsp = (registers.dsp + 1) & PTR_MASK;
		registers.ds[registers.dsp] = -1;
		break;

	case 30: // false
		registers.dsp = (registers.dsp + 1) & PTR_MASK;
		registers.ds[registers.dsp] = 0;
		break;

	case 31: // flag
		registers.dsp = (registers.dsp + 1) & PTR_MASK;
		registers.ds[registers.dsp] = registers.flg;
		break;

	default:
		printf("Unknown instruction\n");
		return 0;
	}
	registers.is = registers.is >> 8;	// right shift 1 op
	goto next;
}

int last = -1; 
struct {
	char label[32];
	long offset;
	int line;
} dictionary[MAX_WORDS];

long lookup(char* word) {
	int i;
	for (i = last; i >= 0; --i) {
		
	}
}

void define(char* word, long offset) {
	++last;
	dictionary[last].label = word;
	dictionary[last].offset = offset;
}

int compile(char* filename, char* imagename) {
	char* program = load(filename);
	char* rom = load(imagename);
	int p = file(filename);
	int line = 0;
	int i = 0;
	size_t size = files[p].size;
	for (i = 0; i < size; ++i) {
		

	}
	save(imagename,rom);
	return 0;
}

int main(int argc, char** argv) {
	if (!argv[1] || ! *argv[1]) return 0;
	if (argc == 3) return compile(argv[1],argv[2]);
	return interpret(argv[1]);
}

