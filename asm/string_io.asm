section .data
tam          dd      0
endereco     dd      0xFFFFFFFF
section .bss
letra        resb    1
section .text
global _start
_start:
    ;Endereco de memoria de onde esta a string, tamanho da string
    ;LerString
    push    letra    
    push    endereco    
    push    tam
    call    LerString
    ;EscreverString
    push    letra
    push    endereco    
    push    tam
    call    EscreverString
Fim:
    ;return 0
    mov     EAX,1
    mov     EBX,0
    int     80h
    
LerString:
    ;cria frame de pilha
    push    EBP
    mov     EBP,ESP
    ;registradores utilizados
    push    EAX
    push    EBX
    push    ECX
    push    EDX
    ;ENDERECO
    mov     EAX,[EBP+12]    
LS_leitura:
    mov     EBX,[EAX]  
    ;verifica se chegou no TAM
    ;verifica se eh enter 
    ;le proximo CHAR
    inc     EAX
    jmp     LS_leitura
LS_final:
    ;registradores utilizados
    pop     EDX
    pop     ECX
    pop     EBX
    pop     EAX
    ;limpa frame de pilha
    mov     ESP,EBP
    pop     EBP
    ret       
    
EscreverString:
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
    mov     EDX,4
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