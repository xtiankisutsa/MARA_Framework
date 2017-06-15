CC=gcc
all:
ifeq ($(shell uname),Linux)
	make linux
else
	make darwin
endif

darwin:
	
	$(CC) dextra.c adler32.c DexOpcodes.c -Wall -o dextra -g2

linux:
	$(CC) dextra.c adler32.c DexOpcodes.c -Wall -o dextra.ELF64 -g2

backup:
	tar cvf ~/Android.book.src.tar *.c *.h Makefile androidcc


android:
	./androidcc dextra.c adler32.c DexOpcodes.c -Wall -o dextra.armv7 -fpermissive
android64:
	./androidcc64 dextra.c adler32.c DexOpcodes.c -Wall -o dextra.arm64 -fpermissive

dist:
	tar cvf dextra.tar Makefile dextra.ELF64 TODO.txt	dextra dextra.arm64 dextra.armv7 doc/
