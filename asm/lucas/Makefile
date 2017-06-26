default: monta

monta:
	nasm -f elf -o $(a).o $(a).asm

liga:
	ld -m elf_i386 -o $(a) $(a).o
