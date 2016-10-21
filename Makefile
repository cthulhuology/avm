
all : avm

avm: avm.c
	/tools/bin/x86_64-linux-musl-gcc -o avm avm.c

test.img :
	dd if=/dev/zero of=test.img bs=4096 count=1024
	./avm test.avm test.img

test:
	iverilog -Wall -g2005 -o stack.test stack.v stack.vt
	./stack.test
	gtkwave dump.vcd
