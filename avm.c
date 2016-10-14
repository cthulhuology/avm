// avm.c
//
// (C) 2016 David J. Goehrig
//
//

// AVM in C
//
// This is an implementation in C for experimenation purposes.
//

#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

#define SIZE_OF_STACK 16
#define PTR_WIDTH 4
#define PTR_MASK 0x0f
#define RAM_SIZE 1024*4096

struct {
	int value;
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
	{ 31, "lit" }
};

struct {
	int is;
	int ip;
	int dsp;
	int rsp;
	int dst;
	int src;
	int flg;
	int ds[SIZE_OF_STACK];
	int rs[SIZE_OF_STACK];
} registers;

char* memory;

void dump_opcodes() {
	int i = 0;
	for (i = 0; i < 32; ++i) 
		printf("%s %d\n", opcodes[i].name, opcodes[i].value);
}

void  boot() {
	int i = 0;
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

char* load(char* filename) {
	struct stat st;
	int fd = open(filename,O_RDWR);
	if (fd < 0) exit(1);
	fstat(fd,&st);
	size_t size = st.st_size;
	char* program = mmap(0,size,PROT_READ|PROT_WRITE,MAP_PRIVATE,fd,0);
	if (program == MAP_FAILED) exit(2);
	printf("Loaded %s\n", filename);	
	return program;		
}

void interpret(char* program) {
	printf("Interpreting program\n");	
}


int main(int argc, char** argv) {
	if (!argv[1] || ! *argv[1]) return 0;
	char* program = load(argv[1]);
	boot();
	interpret(program);
	return 0;
}

