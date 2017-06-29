TRIANGULO: EQU 1

section .text
global _start
_start:
push flag_negativo
push digito
push B
call LerInteiro
push flag_negativo
push digito
push H
call LerInteiro
mov eax,[B]
imul dword [H]
%if TRIANGULO == 1
idiv dword [DOIS]
%endif
mov dword [R],eax
push string
push flag_negativo
push digitoE
push R
call EscreverInteiro

mov eax,1
mov ebx,0
int 80h

section .data
DOIS: dd 2

section .bss
R: resd 1
H: resd 1
B: resd 1


section .data
x           dw      "0x"
X_SIZE      equ     $-x
 
section .bss
letra        resb    1
string          resb    11
flag_negativo   resb    1
digito          resb    1
digitoE         resb    1

section .text

; Funcoes de inteiro
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
    mov dword [ECX], 0
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


; Funcoes de Char
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

; Hexadecimal
LerHexa:
    ;cria frame de pilha
    push    EBP
    mov     EBP,ESP
    ;registradores utilizados
    push    EAX
    push    EBX
    push    ECX
    push    EDX
    ;32 bits
    mov     ECX,8
    ;TESTE
    ;MOV     EDX,0x30   
LH_leitura:
    push    ECX
    ;TESTE
    ;MOV     ECX,[EBP+12]
    ;MOV     DWORD [ECX],EDX  
    ;le um DIGITO do teclado
    mov     EAX,3
    mov     EBX,0
    mov     ECX,[EBP+12]
    mov     EDX,1
    int     80h   
    ;verifica se o DIGITO eh enter
    ;TESTE    
    ;MOV     EAX,[ECX]
    cmp     BYTE [ECX],0x0A
    je      LH_enter
LH_numero:    
    ;verifica se o DIGITO esta entre 0 e 9 
    cmp     BYTE [ECX],0x30
    jb      LH_erro
    cmp     BYTE [ECX],0x39
    ja      LH_maisculo
    ;trata
    mov     EBX,[ECX]
    sub     EBX,0x30
    ;armazena
    jmp     LH_hexa
LH_maisculo:    
    ;verifica se o DIGITO esta entre A e F
    cmp     BYTE [ECX],0x41
    jb      LH_erro
    cmp     BYTE [ECX],0x46
    ja      LH_minusculo
    ;trata
    mov     EBX,[ECX]
    sub     EBX,0x37
    ;armazena
    jmp     LH_hexa
LH_minusculo:    
    ;verifica se o DIGITO esta entre a e f
    cmp     BYTE [ECX],0x60
    jb      LH_erro
    cmp     BYTE [ECX],0x66
    ja      LH_erro
    ;trata
    mov     EBX,[ECX]
    sub     EBX,0x57  
    ;armazena    
    jmp     LH_hexa  
LH_hexa:
    ;checa contador
    pop     ECX
    mov     EAX,ECX
    push    ECX
    and     EAX,1
    cmp     EAX,1
    jne     LH_hexa_par     
LH_hexa_impar:   
    ;armazenamento se o contador for impar  
    mov     ECX,[EBP+8]
    or      [ECX],BL  
    ;checa o contador
    pop     ECX    
    push    ECX
    cmp     ECX,1 
    je      LH_laco 
    ;se contador for diferente de 1 desloca 
    mov     ECX,[EBP+8]    
    shl     DWORD [ECX],8  
    jmp     LH_laco      
LH_hexa_par:       
    ;armazenamento se o contador for par
    mov     ECX,[EBP+8]
    shl     BL,4    
    mov     [ECX],BL
    jmp     LH_laco                                   
LH_laco:    
    ;le proximo DIGITO    
    inc     BYTE [EBP+12] 
    ;TESTE    
    ;ADD     EDX,1    
    pop     ECX 
    loop    LH_leitura 
LH_enter:  
    ;checa o contador
    pop     ECX    
    push    ECX
    and     ECX,1
    cmp     ECX,1 
    jne     LH_enter_par
LH_enter_impar:
    ;se o enter for digitado com um numero impar de infos
    mov     ECX,[EBP+8]    
    shr     DWORD [ECX],4
    jmp     LH_final 
LH_enter_par:
    ;se o enter for digitado com todas as infos ocupadas acaba
    pop     ECX    
    push    ECX
    cmp     ECX,0
    je      LH_final  
    ;se o enter for digitado com um numero par de infos
    mov     ECX,[EBP+8]    
    shr     DWORD [ECX],8  
    jmp     LH_final          
LH_erro:    
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
    ;imprime 0x
    mov     EAX,4
    mov     EBX,1           
    mov     ECX,x  
    mov     EDX,X_SIZE
    int     80h    
    ;ler um byte 4x do hexa
    mov     ECX,4
EH_laco:    
    ;contador
    push    ECX  
    ;lendo o byte atual
    dec     ECX
    mov     EAX,[EBP+8]    
    add     EAX,ECX    
    mov     BYTE BL,[EAX] 
    ;TESTE
    ;CMP     BL,0
    ;JE      EH_contador
    ;dividindo o byte em nibbles: DL primeiro nibble, CL segundo nibble
    mov     CL,BL
    mov     DL,BL
    and     CL,0x0F
    and     DL,0xF0
    shr     DL,4   
    jmp     EH_high_numero
EH_contador:
    ;lendo o proximo byte       
    pop     ECX
    loop    EH_laco
    ;final
    jmp     EH_final
EH_high_numero:
    ;ve se o DL eh digito ou char
    cmp     DL,0x0
    jb      EH_erro
    cmp     DL,0x9
    ja      EH_high_char
    ;trata o numero
    add     DL,0x30
    mov     EAX,[EBP+12]
    mov     [EAX],EDX
    ;imprime
    push    EDX         ;salva o high 
    push    ECX         ;salva o low        
    mov     EAX,4
    mov     EBX,1           
    mov     ECX,[EBP+12]  
    mov     EDX,1
    int     80h
    pop     ECX         ;volta o low
    pop     EDX         ;volta o high
    ;analisa o low
    jmp     EH_low_numero
EH_high_char:
    ;ve se o DL eh digito ou char
    cmp     DL,0xF
    ja      EH_erro
    ;trata o char
    add     DL,0x37
    mov     EAX,[EBP+12]
    mov     [EAX],EDX    
    ;imprime
    push    EDX         ;salva o high 
    push    ECX         ;salva o low 
    mov     EAX,4
    mov     EBX,1
    mov     ECX,[EBP+12]  
    mov     EDX,1
    int     80h
    pop     ECX         ;volta o low
    pop     EDX         ;volta o high
    ;analisa o low    
    jmp     EH_low_numero   
EH_low_numero:
    ;ve se o CL eh digito ou char  
    cmp     CL,0x0
    jb      EH_erro
    cmp     CL,0x9
    ja      EH_low_char
    ;trata o numero
    add     CL,0x30
    mov     EAX,[EBP+12]
    mov     [EAX],ECX    
    ;imprime
    push    ECX         ;salva o low     
    push    EDX         ;salva o high 
    mov     EAX,4
    mov     EBX,1  
    mov     ECX,[EBP+12]
    mov     EDX,1
    int     80h
    pop     EDX         ;volta o high    
    pop     ECX         ;volta o low
    ;volta para o laco    
    jmp     EH_contador    
EH_low_char:
    ;ve se o CL eh digito ou char
    cmp     CL,0xF
    ja      EH_erro
    ;trata o char
    add     CL,0x37
    mov     EAX,[EBP+12]
    mov     [EAX],ECX    
    ;imprime
    push    ECX         ;salva o low     
    push    EDX         ;salva o high     
    mov     EAX,4
    mov     EBX,1
    mov     ECX,[EBP+12]  
    mov     EDX,1
    int     80h
    pop     EDX         ;volta o high     
    pop     ECX         ;volta o low 
    ;volta para o laco     
    jmp     EH_contador 
EH_erro:
EH_final:  
    ;registradores utilizados
    pop     EDX
    pop     ECX
    pop     EBX
    pop     EAX
    ;limpa frame de pilha
    mov     ESP,EBP
    pop     EBP
    ret

; String
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
