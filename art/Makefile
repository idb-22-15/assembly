ASMC=nasm

all: linux

%.com: %.asm
	${ASMC} -fbin $< -o $@


lab:
	${ASMC} -f bin -g term3-lab1.asm -o lab.com && dosbox ./ -fullscreen

lablinux:
	${ASMC} -f elf64 -g term3-lab1.asm -o lab.com

linux:
	${ASMC} -f elf64 -g hello.asm -o hello.o && ld hello.o -o hello
