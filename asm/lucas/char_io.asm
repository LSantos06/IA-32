section .bss
character        resb    1
section .text
global _start
_start:
    ;LerChar
    push    character
    call    LerChar
    ;EscreverChar
    push    character
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
    ;retorno em EAX
    mov     EAX,1
    ;limpa frame de pilha
    mov     ESP,EBP
    pop     EBP
    ret
    
EscreverChar:
    ;cria frame de pilha
    push    EBP
    mov     EBP,ESP
    ;registradores utilizados
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
    ;retorno em EAX
    mov     EAX,1
    ;limpa frame de pilha
    mov     ESP,EBP
    pop     EBP
    ret
