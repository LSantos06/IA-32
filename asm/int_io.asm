section .data
inteiro     dd      0
section .bss
digito      resb    1
section .text
global _start
_start:
    ;Inteiros com sinal de 32 bits [−2147483648, 2147483647]
    ;LerInteiro
    push    digito    
    push    inteiro
    call    LerInteiro
    ;EscreverInteiro
    push    inteiro
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
    ;le um DIGITO do teclado
    mov     EAX,3
    mov     EBX,0
    mov     ECX,[EBP+12]
    mov     EDX,1
    int     80h
    ;verifica se o primeiro DIGITO eh -
    cmp     BYTE [ECX],0x2D
    je      LI_negativo
    ;verifica se o DIGITO eh enter
    cmp     BYTE [ECX],0x0A
    je      LI_final
    ;subtrai 30 do DIGITO
    mov     EBX,[ECX]
    sub     EBX,0x30
    ;verifica se o DIGITO esta entre 0 e 9, senao termina
    mov     ECX,EBX
    cmp     ECX,0
    jb      LI_erro
    cmp     ECX,9
    ja      LI_erro
    ;multiplica o INTEIRO por 10
    mov     EDX,[EBP+8]
    mov     EAX,[EDX]
    mov     ECX,10
    mul     ECX     
    ;soma o digito com o INTEIROx10 e armazena no INTEIRO
    add     EBX,EAX
    mov     EAX,[EBP+8]
    mov     [EAX],EBX
    ;le proximo DIGITO
    inc     BYTE [EBP+12]
    jmp     LI_leitura
LI_negativo:
    mov     EAX,[EBP+8]
    mov     [EAX],ECX
    jmp     LI_leitura
LI_erro:
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
    ;i=0
    ;do{
    ;   str[i] = (char)((Valor % 10) + 0x30);
    ;   Valor = (int) (Valor / 10);
    ;   if (Valor != 0) str[i+1]= str[i]
    ;   i = i+1
    ;} while (Valor != 0)
    ;str[i] = '/0'
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