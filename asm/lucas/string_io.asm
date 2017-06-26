section .data
endereco     dq      0
tam          dd      5
section .bss
letra        resb    1
section .text
global _start
_start:
    ;Endereco de memoria de onde esta a string, tamanho da string
    ;LerString
    push    tam    
    push    letra       
    push    endereco     
    call    LerString
    ;EscreverString
    push    tam    
    push    letra  
    push    endereco  
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
    mov     EAX,[EBP+8]   
    ;TAM
    mov     EDX,[EBP+16]
    mov     ECX,[EDX]   
LS_leitura:
    ;TAM atual
    push    ECX
    push    EAX
    ;le um CHAR do teclado
    mov     EAX,3
    mov     EBX,0
    mov     ECX,[EBP+12]
    mov     EDX,1
    int     80h
    ;armazenando CHAR no ENDERECO
    mov     EBX,[ECX]
    pop     EAX
    mov     [EAX],EBX
    ;verifica se o CHAR eh enter
    cmp     EBX,0x0A
    je      LS_final 
    ;escreve proximo CHAR, se ainda nao chegou ao TAM
    inc     EAX
    ;ve se ainda tem TAM
    pop     ECX
    loop    LS_leitura
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
    ;ENDERECO
    mov     EAX,[EBP+8]   
    ;TAM
    mov     EDX,[EBP+16]
    mov     ECX,[EDX]   
ES_leitura:
    ;TAM atual
    push    ECX
    push    EAX
    ;le um CHAR da memoria
    mov     EBX,1
    pop     EAX    
    mov     ECX,EAX
    push    EAX
    mov     EAX,4
    mov     EDX,1
    int     80h
    ;imprime proximo CHAR, se ainda nao chegou ao TAM
    pop     EAX
    inc     EAX    
    ;verifica se o CHAR eh enter
    cmp     EBX,0x0A
    je      ES_final 
    ;ve se ainda tem TAM
    pop     ECX
    loop    ES_leitura
ES_final:
    ;registradores utilizados
    pop     EDX
    pop     ECX
    pop     EBX
    pop     EAX
    ;limpa frame de pilha
    mov     ESP,EBP
    pop     EBP
    ret 