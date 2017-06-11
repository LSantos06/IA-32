section .bss
int_input   resb    4

section .text
global _start
_start:

LerInteiro:

EscreverInteiro:

Fim:
    ;return 0
    mov EAX,1
    mov EBX,0
    int 80h