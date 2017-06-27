section .data
menos           db      '-'
inteiro         dd      0
digito          dD      0x3332312D
section .bss
string          resb    11
flag_negativo   resb    1
;digito          resb    1
section .text
global _start
_start:
    ;Inteiros com sinal de 32 bits [−2147483648, 2147483647]
    ;LerInteiro
    push    flag_negativo
    push    digito    
    push    inteiro
    call    LerInteiro    
    ;EscreverInteiro
    push    string     
    push    digito       
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
    push    EBX
    push    ECX
    push    EDX
    ;Contador de -
    mov     ECX,0
    push    ECX       
    ;Contador de chars lidos
    mov     EAX,0
    push    EAX             
LI_leitura:
    ;le um DIGITO do teclado
    ;mov     EAX,3
    ;mov     EBX,0
    mov     ECX,[EBP+12]
    ;mov     EDX,1
    ;int     80h 
    ;chars lidos
    pop     EAX
    inc     EAX
    push    EAX          
    ;verifica se o primeiro DIGITO eh -
    mov     BL,[ECX]
    cmp     BL,0x2D
    je      LI_negativo
    ;verifica se o DIGITO eh enter
    cmp     BL,0x0A
    je      LI_final
    ;subtrai 30 do DIGITO
    sub     BL,0x30
    ;verifica se o DIGITO esta entre 0 e 9, senao termina
    cmp     BL,0
    jb      LI_erro
    cmp     BL,9
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
    mov     ECX,[EBP+12]      
    jmp     LI_leitura
LI_negativo:
    ;chars lidos
    pop     EAX
    ;tratando o sinal de -      
    pop     ECX
    inc     ECX
    push    ECX
    ;chars lidos    
    push    EAX
    mov     EAX,ECX
    and     EAX,1
    cmp     EAX,1
    jne     LI_negativo_par
LI_negativo_impar:
    ;numero impar de -, numero eh negativo
    mov     EAX,[EBP+16]
    mov     BYTE [EAX],0x2D  
    jmp     LI_negativo_fim
LI_negativo_par:
    ;numero par de -, numero eh positivo
    mov     EAX,[EBP+16]
    mov     BYTE [EAX],0
LI_negativo_fim:
    ;fim
    inc     BYTE [EBP+12] 
    mov     ECX,[EBP+12] 
    jmp     LI_leitura
LI_nega:  
    ;negando o numero se ele for negativo
    mov     EDX,[EBP+8]
    neg     DWORD [EDX]
    ;chars lidos 
    pop     EAX
    ;registradores utilizados
    pop     EDX
    pop     ECX
    pop     EBX
    ;limpa frame de pilha
    mov     ESP,EBP
    pop     EBP
    ret     
LI_erro:
LI_final: 
    ;ve se o numero eh negativo
    mov     EAX,[EBP+16]         
    mov     EAX,[EAX]     
    cmp     AL,0x2D  
    je      LI_nega
    ;chars lidos 
    pop     EAX    
    ;registradores utilizados
    pop     EDX
    pop     ECX
    pop     EBX
    ;limpa frame de pilha
    mov     ESP,EBP
    pop     EBP
    ret       
    
EscreverInteiro:
    ;cria frame de pilha
    push    EBP
    mov     EBP,ESP
    ;registradores utilizados
    push    EBX
    push    ECX
    push    EDX
    ;imprime o -, se existir    
    mov     EAX,[EBP+8]
    mov     EAX,[EAX]
    and     EAX,0x80000000
    cmp     EAX,0x80000000
    jne     EI_inicio
EI_menos:    
    mov     EDX,[EBP+8]
    neg     DWORD [EDX]
    mov     EAX,4
    mov     EBX,1
    mov     ECX,menos
    mov     EDX,1
    int     80h
EI_inicio:    
    ;ECX = i = 0
    xor     ECX,ECX
EI_string:
    ;Valor = (int) (Valor / 10);
    ;str[i] = (char)((Valor % 10) + 0x30);
    xor     EDX,EDX
    mov     EAX,[EBP+8]
    mov     EAX,[EAX]
    mov     EBX,10
    div     EBX
    ;EAX = Valor
    mov     EBX,[EBP+8]
    mov     [EBX],EAX
    ;EDX = str[i]
    mov     EBX,[EBP+12]
    mov     [EBX],EDX
    add     BYTE [EBX],0x30
    push    ECX
    ;str[i+1] = str[i]    
    jmp     EI_armazena
EI_laco:
    ;i++   
    pop     ECX
    inc     ECX
    ;} while (Valor != 0)
    mov     EAX,[EBP+8]
    mov     EAX,[EAX]
    cmp     EAX,0
    jne     EI_string
    ;chars impressos
    mov     EAX,ECX
    push    EAX    
    jmp     EI_imprime
EI_armazena:
    ;str[i+1] = str[i] 
    mov     EDX,[EBP+16]
    inc     ECX
    mov     EBX,[EBX]
    mov     [EDX+ECX],EBX
    jmp     EI_laco
EI_imprime:
    mov     EDX,[EBP+16]
    add     EDX,ECX
    push    ECX
    ;syscall impressao monitor  
    mov     EAX,4
    mov     EBX,1
    mov     ECX,EDX
    mov     EDX,1
    int     80h
    pop     ECX
    loop    EI_imprime
EI_final:    
    ;chars impressos
    pop     EAX
    inc     EAX
    ;registradores utilizados
    pop     EDX
    pop     ECX
    pop     EBX
    ;limpa frame de pilha
    mov     ESP,EBP
    pop     EBP
    ret