section .bss
char_input  resb    1

section .text
global _start
_start:

LerChar:


EscreverChar:
    ;imprime um caracter
    mov EAX,4
    mov EBX,1
    mov ECX,char_input
    mov EDX,1
    int 80h

Fim:
    ;return 0
    mov EAX,1
    mov EBX,0
    int 80h