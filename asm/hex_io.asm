section .data
hexa        dd      0
x           dw      "0x"
X_SIZE      equ     $-x
section .bss
section .text
global _start
_start:
    ;Hexadecimais positivos de 32 bits [0x12345678]
    ;LerHexa
    ;push    digito ;passar para local    
    push    hexa
    call    LerHexa
    ;EscreverHexa
    ;mov     ECX,[hexa]
    ;mov     DWORD [valor],ECX     
    ;push    string ;passar para local    
    ;push    digito ;passar para local   
    ;push    valor ;passar para local       
    push    hexa
    call    EscreverHexa
Fim:
    ;return 0
    mov     EAX,1
    mov     EBX,0
    int     80h
    
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