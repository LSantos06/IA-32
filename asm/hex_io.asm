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
    MOV     EDX,0x31   
LH_leitura:
    push    ECX
    ;TESTE
    MOV     ECX,[EBP+12]
    MOV     DWORD [ECX],EDX  
    ;le um DIGITO do teclado
    ;mov     EAX,3
    ;mov     EBX,0
    ;mov     ECX,[EBP+12]
    ;mov     EDX,1
    ;int     80h   
    ;verifica se o DIGITO eh enter
    MOV     EAX,[ECX]
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
    jne     LI_hexa_par     
LI_hexa_impar:     
    ;armazenamento se o contador for impar  
    mov     ECX,[EBP+8]
    shl     BL,4
    or      [ECX],BL
    inc     BYTE [EBP+8]     
    jmp     LH_laco      
LI_hexa_par:       
    ;armazenamento se o contador for par
    mov     ECX,[EBP+8]
    mov     [ECX],BL
    jmp     LH_laco               
LH_erro:;      
LH_laco:    
    ;armazenando DIGITO no ENDERECO
    ;le proximo DIGITO    
    inc     BYTE [EBP+12] 
    ADD     EDX,0x10    
    pop     ECX     
    loop    LH_leitura
;LH_erro:
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