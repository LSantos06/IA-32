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
    push    digito     
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
    je      LH_final
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
    CMP     BL,0
    JE      EH_contador
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