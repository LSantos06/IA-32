section .data
hexa        dd      0
section .bss
digito      resb    1
section .text
global _start
_start:
    ;Hexadecimais positivos de 32 bits [0x12345678]
    ;LerHexa
    push    digito    
    push    hexa
    call    LerHexa
    ;EscreverHexa
    push    hexa
    call    EscreverHexa
Fim:
    ;return 0
    mov     EAX,1
    mov     EBX,0
    int     80h
    
LerHexa:
    ;cria frame de pilha
    push    EBP
    mov     EBP,ESP
    ;registradores utilizados
    push    EAX
    push    EBX
    push    ECX
    push    EDX
LH_leitura:
    ;le um DIGITO do teclado
    mov     EAX,3
    mov     EBX,0
    mov     ECX,[EBP+12]
    mov     EDX,1
    int     80h
    ;verifica se o DIGITO eh enter
    cmp     BYTE [ECX],0x0A
    je      LH_final
    ;verifica se o DIGITO esta entre 0 e F, senao termina
    mov     ECX,EBX
    cmp     ECX,0x30
    jb      LH_final
    cmp     ECX,0x46
    ja      LH_final
        
    cmp     ECX,0x39
    ja      LH_final
    cmp     ECX,0x41
    jb      LH_final    

    ;le proximo DIGITO
    inc     BYTE [EBP+12]
    jmp     LH_leitura
LH_final:
    ;registradores utilizados
    pop     EDX
    pop     ECX
    pop     EBX
    pop     EAX
    ;limpa frame de pilha
    mov     ESP,EBP
    pop     EBP
    ret       
                
EscreverHexa:
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