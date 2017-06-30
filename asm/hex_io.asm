section .data
valor       dd      0
hexa        dd      0
x           dw      "0x"
X_SIZE      equ     $-x
section .bss
string      resb    8
digito      resb    1
section .text
global _start
_start:
    ;Hexadecimais positivos de 32 bits [0x12345678]
    ;LerHexa
    push    digito ;passar para local    
    push    hexa
    call    LerHexa
    ;EscreverHexa
    mov     ECX,[hexa]
    mov     DWORD [valor],ECX     
    push    string ;passar para local    
    push    digito ;passar para local   
    push    valor ;passar para local       
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
    push    EBX
    push    ECX
    push    EDX
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
    inc     BYTE [EBP+12]    
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
    mov     ESP,EBP
    pop     EBP
    ret       
                
EscreverHexa:
    ;cria frame de pilha
    push    EBP
    mov     EBP,ESP
    ;registradores utilizados
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
EH_inicio:    
    ;ECX = i = 0
    xor     ECX,ECX
EH_string:
    ;Valor = (int) (Valor / 16);
    ;str[i] = (char)((Valor % 16) + );
    xor     EDX,EDX
    mov     EAX,[EBP+12]
    mov     EAX,[EAX]
    mov     EBX,16
    div     EBX
    ;EAX = Valor
    mov     EBX,[EBP+12]
    mov     [EBX],EAX
    ;EDX = str[i]
    mov     EBX,[EBP+16]
    mov     [EBX],EDX
    ;ve aonde esta o char
EH_numero:
    cmp     BYTE [EBX],0
    jb      EH_erro
    cmp     BYTE [EBX],9
    ja      EH_letra  
    ;eh um numero  
    add     BYTE [EBX],0x30
    push    ECX
    ;str[i+1] = str[i]    
    jmp     EH_armazena
EH_letra:
    cmp     BYTE [EBX],15
    ja      EH_erro 
    ;eh uma letra
    add     BYTE [EBX],0x37
    push    ECX
    ;str[i+1] = str[i]    
    jmp     EH_armazena
EH_laco:
    ;i++   
    pop     ECX
    inc     ECX
    ;} while (Valor != 0)
    mov     EAX,[EBP+12]
    mov     EAX,[EAX]
    cmp     EAX,0
    jne     EH_string
    ;chars impressos
    mov     EAX,ECX
    push    EAX    
    jmp     EH_imprime
EH_armazena:
    ;str[i+1] = str[i] 
    mov     EDX,[EBP+20]
    inc     ECX
    mov     EBX,[EBX]
    mov     [EDX+ECX],EBX
    jmp     EH_laco
EH_imprime:
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
    mov     ESP,EBP
    pop     EBP
    ret
