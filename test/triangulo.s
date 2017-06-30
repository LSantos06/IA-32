TRIANGULO: EQU 1

section .text
global _start
_start:
push B
call LerInteiro
push H
call LerInteiro
mov eax,[B]
imul dword [H]
%if TRIANGULO == 1
idiv dword [DOIS]
%endif
mov dword [R],eax
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
menos           db      '-'
 

section .text

; Funcoes de inteiro
    %define FLAG_NEGATIVO BYTE [EBP-1]
    %define DIGITO BYTE [EBP-2]    
LerInteiro:
    ;cria frame de pilha
    ;Cria 2 espacos pra variavel local
    enter 2,0
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
    mov     EAX,3
    mov     EBX,0
    ;[EBP-2]
    mov     ECX,EBP
    sub     ECX,2
    mov     EDX,1
    int     80h          
    ;verifica se o primeiro DIGITO eh -
    mov     BL,DIGITO
    cmp     BL,0x2D
    je      LI_negativo
    ;chars lidos
    pop     EAX
    inc     EAX
    push    EAX 
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
    mov     EAX, EBP
    sub     EAX,2
    inc     BYTE AL
    mov     ECX,EAX     
    pop     EAX
    push    EAX
    cmp     EAX,11 
    jne     LI_leitura
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
    ; EBP - 1
    mov     EAX,EBP
    dec     EAX
    mov     BYTE [EAX],0x2D  
    jmp     LI_negativo_fim
LI_negativo_par:
    ;numero par de -, numero eh positivo
    mov     EAX,EBP
    dec     EAX
    mov     BYTE [EAX],0
LI_negativo_fim:
    ;fim
    mov     EBX, EBP
    dec     EBX
    ;inc     BYTE [EBP+12] 
    mov     ECX,EBX
    pop     EAX
    push    EAX
    cmp     EAX,11 
    jne     LI_leitura
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
    ;mov     ESP,EBP
    ;pop     EBP
    
    leave
    ret     
LI_erro:
LI_final: 
    ;ve se o numero eh negativo
    mov     AL,FLAG_NEGATIVO     
    cmp     AL,0x2D  
    je      LI_nega
    ;chars lidos 
    pop     EAX    
    ;registradores utilizados
    pop     EDX
    pop     ECX
    pop     EBX
    ;limpa frame de pilha
    ;mov     ESP,EBP
    ;pop     EBP
    
    leave
    ret       
    
    %define VALOR  DWORD [EBP-16]
    %define DIGITO BYTE  [EBP-1]
    %define STRING BYTE  [EBP-12]
EscreverInteiro:
    ;cria frame de pilha
    ;push    EBP
    ;mov     EBP,ESP
    ;Cria 3 variaveis locai
    enter 16,0
    ;registradores utilizados
    push    EBX
    push    ECX
    push    EDX
    
    ; Valor = Inteiro
    mov EDX, [EBP+8]
    mov EDX, [EDX]
    mov DWORD VALOR,EDX
    ;imprime o -, se existir    
    mov     EAX,[EBP+8]
    mov     EAX,[EAX]
    and     EAX,0x80000000
    cmp     EAX,0x80000000
    jne     EI_inicio
EI_menos:    
    neg     DWORD VALOR
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
    mov     EAX,VALOR
    mov     EBX,10
    div     EBX
    ;EAX = Valor
    mov     VALOR,EAX
    ;EDX = str[i]
    ; Digito = EBP-1
    mov     EBX,EBP
    sub     EBX, 1
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
    mov     EAX,VALOR
    cmp     EAX,0
    jne     EI_string
    ;chars impressos
    mov     EAX,ECX
    push    EAX    
    jmp     EI_imprime
EI_armazena:
    ;str[i+1] = str[i] 
    ;string = EBP -12
    mov     EDX,EBP
    sub     EDX,12
    inc     ECX
    mov     EBX,[EBX]
    mov     [EDX+ECX],EBX
    jmp     EI_laco
EI_imprime:
    mov     EDX,EBP
    sub     EDX,12
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
    ;conta o -, se existir    
    mov     EAX,[EBP+8]
    mov     EAX,[EAX]
    and     EAX,0x80000000
    cmp     EAX,0x80000000    
    ;chars impressos
    pop     EAX
    jne     EI_nao_conta_menos  
EI_conta_menos:      
    inc     EAX
EI_nao_conta_menos:    
    ;registradores utilizados
    pop     EDX
    pop     ECX
    pop     EBX
    ;limpa frame de pilha
    ;mov     ESP,EBP
    ;pop     EBP
    
    leave
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
    %define DIGITO BYTE [EBP-1]
LerHexa:
    ;cria frame de pilha
    ;push    EBP
    ;mov     EBP,ESP
    ; 1 Variavel local de 1 byte
    enter 1,0
    ;registradores utilizados
    push    EBX
    push    ECX
    push    EDX
    ;Zera argumento de entrada
    mov ECX, [EBP+8]
    mov dword [ECX], 0
    ;32 bits
    mov     ECX,8
    ;TESTE
    MOV     EDX,0x41
    PUSH    EDX 
      
LH_leitura:
    push    ECX
    ;TESTE
    ;MOV     ECX,[EBP+12]
    ;MOV     DWORD [ECX],EDX  
    ;le um DIGITO do teclado
    mov     EAX,3
    mov     EBX,0
    mov     ECX,EBP
    sub     ECX,1
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
    ;multiplica o HEXA por 16
    mov     EDX,[EBP+8]
    mov     EAX,[EDX]
    mov     ECX,16
    mul     ECX    
    ;soma o digito com o HEXAx16 e armazena no HEXA
    add     EBX,EAX
    mov     EAX,[EBP+8]
    mov     [EAX],EBX     
    jmp     LH_laco                                   
LH_laco:    
    ;le proximo DIGITO  
    push EBX 
    mov     EBX,EBP 
    sub EBX,1
    inc     EBX  
    pop EBX 
    pop     ECX
    ;TESTE     
    ;POP     EDX
    ;ADD     EDX,1  
    ;PUSH    EDX      
    loop    LH_leitura
LH_erro:      
LH_enter:          
LH_final:
    pop     ECX
    ;contador de chars lidos
    mov     EAX,8
    sub     EAX,ECX 
    ;TESTE
    pop     EDX 
    ;registradores utilizados
    pop     EDX    
    pop     ECX    
    pop     EBX
    ;limpa frame de pilha
    ;mov     ESP,EBP
    ;pop     EBP
    
    leave
    ret       
    %define VALOR  DWORD [EBP-13]
    %define DIGITO BYTE  [EBP-1]
    %define STRING BYTE  [EBP-9]            
EscreverHexa:
    ;cria frame de pilha
    ;push    EBP
    ;mov     EBP,ESP
    ; Cria 3 variaveis locais
    enter 13,0
    ;registradores utilizados
    push    EBX
    push    ECX
    push    EDX
    
    ; Valor = Inteiro
    mov EDX, [EBP+8]
    mov EDX, [EDX]
    mov DWORD VALOR,EDX
    ;imprime 0x
    mov     EAX,4
    mov     EBX,1           
    mov     ECX,x  
    mov     EDX,X_SIZE
    int     80h    
    ;ler um byte 4x do hexa
    mov     ECX,4
EH_inicio:    
    ;ECX = i = 0
    xor     ECX,ECX
EH_string:
    ;Valor = (int) (Valor / 16);
    ;str[i] = (char)((Valor % 16) + );
    xor     EDX,EDX
    mov     EAX,VALOR
    mov     EBX,16
    div     EBX
    ;EAX = Valor
    mov     VALOR,EAX
    ;EDX = str[i]
    mov     DIGITO,DL
    ;ve aonde esta o char
EH_numero:
    cmp     BYTE DIGITO,0
    jb      EH_erro
    cmp     BYTE DIGITO,9
    ja      EH_letra  
    ;eh um numero  
    add     BYTE DIGITO,0x30
    push    ECX
    ;str[i+1] = str[i]    
    jmp     EH_armazena
EH_letra:
    cmp     BYTE DIGITO,15
    ja      EH_erro 
    ;eh uma letra
    add     BYTE DIGITO,0x37
    push    ECX
    ;str[i+1] = str[i]    
    jmp     EH_armazena
EH_laco:
    ;i++   
    pop     ECX
    inc     ECX
    ;} while (Valor != 0)
    mov     EAX,VALOR
    cmp     EAX,0
    jne     EH_string
    ;chars impressos
    mov     EAX,ECX
    push    EAX    
    jmp     EH_imprime
EH_armazena:
    ;str[i+1] = str[i] 
    mov     EDX,EBP
    sub     EDX,9
    inc     ECX
    mov     BL,DIGITO
    mov     [EDX+ECX],EBX
    jmp     EH_laco
EH_imprime:
    mov     EDX,EBP
    sub     EDX,9
    add     EDX,ECX
    push    ECX
    ;syscall impressao monitor  
    mov     EAX,4
    mov     EBX,1
    mov     ECX,EDX
    mov     EDX,1
    int     80h
    pop     ECX
    loop    EH_imprime    
EH_erro:
EH_final:  
    ;chars impressos
    pop     EAX
    add     EAX,2
    ;registradores utilizados
    pop     EDX
    pop     ECX
    pop     EBX
    ;limpa frame de pilha
    ;mov     ESP,EBP
    ;pop     EBP
    leave
    ret

; String
LerString:
    ;cria frame de pilha, 1 byte para char lido
    enter   1,0
    ;registradores utilizados
    push    EBX
    push    ECX
    push    EDX
    ;ENDERECO
    mov     EAX,[EBP+8]   
    ;TAM
    mov     EDX,[EBP+12]
    mov     ECX,[EDX]   
LS_leitura:
    ;TAM atual
    push    ECX
    ;ENDERECO
    push    EAX
    ;le um CHAR do teclado
    mov     EAX,3
    mov     EBX,0
    ;EBP-1, variavel local
    mov     ECX,EBP
    dec     ECX
    mov     EDX,1
    int     80h
    ;armazenando CHAR no ENDERECO
    mov     EBX,[ECX]
    pop     EAX
    mov     [EAX],EBX   
    ;verifica se o CHAR eh enter
    cmp     EBX,0x0A
    je      LS_enter
    ;escreve proximo CHAR, se ainda nao chegou ao TAM
    inc     EAX
    ;ve se ainda tem TAM
    pop     ECX
    loop    LS_leitura
    jmp     LS_final
LS_enter:
    ;registradores utilizados
    pop     ECX
    pop     EDX
    pop     EBX
    ;retorno em EAX
    dec     ECX
    mov     EAX,[EBP+12]
    mov     EAX,[EAX]
    sub     EAX,ECX  
    ;limpa frame de pilha
    mov     ESP,EBP
    pop     EBP
    ret             
LS_final:
    ;registradores utilizados
    pop     EDX
    pop     ECX
    pop     EBX
    ;retorno em EAX
    mov     EAX,[EBP+12]
    mov     EAX,[EAX]
    add     EAX,1  
    ;limpa frame de pilha
    leave
    ret       
    
EscreverString:
    ;cria frame de pilha
    enter   0,0
    ;registradores utilizados
    push    EBX
    push    ECX
    push    EDX
    ;ENDERECO
    mov     EAX,[EBP+8]   
    ;TAM
    mov     EDX,[EBP+12]
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
    cmp     DWORD [ECX],0x0A
    je      ES_enter      
    ;ve se ainda tem TAM
    pop     ECX
    loop    ES_leitura
    jmp     ES_final    
ES_enter:
    ;registradores utilizados
    pop     ECX
    pop     EDX
    pop     EBX
    ;retorno em EAX
    dec     ECX
    mov     EAX,[EBP+12]
    mov     EAX,[EAX]
    sub     EAX,ECX  
    ;limpa frame de pilha
    mov     ESP,EBP
    pop     EBP
    ret     
ES_final:
    ;registradores utilizados
    pop     EDX
    pop     ECX
    pop     EBX
    ;retorno em EAX
    mov     EAX,[EBP+12]
    mov     EAX,[EAX] 
    add     EAX,1     
    ;limpa frame de pilha
    leave
    ret 
