.PHONY: clean stack alu

all : avm

avm: avm.c
	/tools/bin/x86_64-linux-musl-gcc -o avm avm.c

avm16: avm16.c
	/tools/bin/x86_64-linux-musl-gcc -o avm16 avm16.c

test.img : test.avm avm
	dd if=/dev/zero of=test.img bs=4096 count=1024
	./avm test.avm test.img

test16.img: test.avm avm16
	dd if=/dev/zero of=test16.img bs=4096 count=1
	./avm16 test.avm test16.img

stack:
	iverilog -Wall -g2005 -o stack.test stack.v stack.vt
	./stack.test
	gtkwave dump.vcd

alu:
	iverilog -Wall -g2005 -o alu.test alu.v alu.vt
	./alu.test
	gtkwave dump.vcd

rom:
	iverilog -Wall -g2005 -o rom.test rom.v rom.vt
	./rom.test
	gtkwave dump.vcd

ram:
	iverilog -Wall -g2005 -o ram.test ram.v ram.vt
	./ram.test
	gtkwave dump.vcd

clean:
	rm -f *.test *.vcd *.out avm

