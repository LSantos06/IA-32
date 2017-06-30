section .data
inteiro1         dd      0
inteiro2         dd      0
valor1           dd      0
valor2           dd      0
newLine		 db 	0xA
newLineSZ	EQU	$-newLine
section .bss
string          resb    11
flag_negativo   resb    1
digito1          resb    1
digito2          resb    1
digito          resb    1
section .text
global _start
_start:
    ;Inteiros com sinal de 32 bits [−2147483648, 2147483647]
    ;LerInteiro
    push    flag_negativo
    push    digito1    
    push    inteiro1
    call    LerInteiro
    
   ; mov byte [digito], 0
    push    flag_negativo
    push    digito1 
    push    inteiro2
    call    LerInteiro

    ;EscreverInteiro
    mov     ECX,[inteiro2]
    mov     DWORD [valor2],ECX
    push    string
    push    flag_negativo    
    push    digito  
    push    valor2
    call    EscreverInteiro
	
    mov EAX, 4
    mov EBX, 1 
    mov ECX, newLine
    mov EDX, newLineSZ
    int 80h

    mov     ECX,[inteiro1]
    mov     DWORD [valor1],ECX
    push    string
    push    flag_negativo    
    push    digito    
    push    valor1
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
    push    ECX
    je      LI_negativo
    pop     ECX
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
    ;tratando o sinal de -
    inc     ECX
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
    jmp     LI_leitura
LI_erro:
LI_final:
    ;registradores utilizados
    mov ECX, [EBP+12]
    mov dword [ECX], 0
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
    ;imprime o -, se existir
    mov     EAX,4
    mov     EBX,1
    mov     ECX,[EBP+16]
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
    jmp     EI_imprime
EI_armazena:
    ;str[i+1] = str[i] 
    mov     EDX,[EBP+20]
    inc     ECX
    mov     EBX,[EBX]
    mov     [EDX+ECX],EBX
    jmp     EI_laco
EI_imprime:
    mov     EDX,[EBP+20]
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
    ;registradores utilizados
    pop     EDX
    pop     ECX
    pop     EBX
    pop     EAX
    ;limpa frame de pilha
    mov     ESP,EBP
    pop     EBP
    ret
