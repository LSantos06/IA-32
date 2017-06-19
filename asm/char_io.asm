section .bss
char        resb    1
section .text
global _start
_start:
    ;LerChar
    push    char
    call    LerChar
    ;EscreverChar
    push    char
    call    EscreverChar
    ;return 0
    mov     EAX,1
    mov     EBX,0
    int     80h
    
LerChar:
    ;cria frame de pilha
    push    EBP
    mov     EBP,ESP
    ;registradores utilizados
    push    EAX
    push    EBX
    push    ECX
    push    EDX
    ;syscall leitura do teclado
    mov     EAX,3
    mov     EBX,0
    mov     ECX,[EBP+8]
    mov     EDX,1
    int     80h
    ;registradores utilizados
    pop     EDX
    pop     ECX
    pop     EBX
    pop     EAX
    ;limpa frame de pilha
    mov     ESP,EBP
    pop     EBP
    ret
    
EscreverChar:
    ;cria frame de pilha
    push    EBP
    mov     EBP,ESP
    ;registradores utilizados
    push    EAX
    push    EBX
    push    ECX
    push    EDX
    ;syscall impressao monitor
    mov     EAX,4
    mov     EBX,1
    mov     ECX,[EBP+8]
    mov     EDX,1
    int     80h
    ;registradores utilizados
    pop     EDX
    pop     ECX
    pop     EBX
    pop     EAX
    ;limpa frame de pilha
    mov     ESP,EBP
    pop     EBP
    ret