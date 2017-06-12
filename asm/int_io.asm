section .data
anterior    dd      0
section .bss
inteiro     resb    1
section .text
global _start
_start:
    ;Inteiros com sinal de 32 bits [−2147483648, 2147483647]
    ;LerInteiro
    push    inteiro    
    push    anterior
    call    LerInteiro
    ;EscreverInteiro
    push    anterior
    call    EscreverInteiro
Fim:
    ;return 0
    mov     EAX,1
    mov     EBX,0
    int     80h
    
LerInteiro:
    ;cria frame de pilha
    push    EBP
    mov     EBP,ESP
    ;registradores utilizados
    push    EAX
    push    EBX
    push    ECX
    push    EDX
LI_leitura:
    ;le um digito do teclado
    mov     EAX,3
    mov     EBX,0
    mov     ECX,[EBP+12]
    mov     EDX,1
    int     80h
    ;verifica se eh - ou 0a9
    cmp     BYTE [ECX],0x0A
    je      LI_final
    ;subtrai 30 do digito lido
    mov     EBX,[ECX]
    sub     EBX,0x30
    ;multiplica o numero armazenado por 10
    mov     EDX,[EBP+8]
    mov     EAX,[EDX]
    mov     ECX,10
    mul     ECX     
    ;soma o digito com o numero e armazena na memoria
    add     EBX,EAX
    mov     EAX,[EBP+8]
    mov     [EAX],EBX
    ;repete
    inc     BYTE [EBP+12]
    jmp     LI_leitura
LI_final:
    ;registradores utilizados
    pop     EDX
    pop     ECX
    pop     EBX
    pop     EAX
    ;limpa frame de pilha
    mov     ESP,EBP
    pop     EBP
    ret       
    
EscreverInteiro:
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