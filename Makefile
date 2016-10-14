
all : avm

avm: avm.c
	/tools/bin/x86_64-linux-musl-gcc -o avm avm.c
