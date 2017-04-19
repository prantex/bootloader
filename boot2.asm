org 0x0500
jmp 0x0000:start
 
string1: db "4Foda-se", 10, 10, 10, 13
strlen1: equ $-string1
 

start:
    xor AX, AX
    mov DS, AX  ; reset 

    mov AH, 00h ; set video mode
    mov AL, 03h ; text mode. 80x25. 16 colors. 8 pages
    int 10h     ; int video mode

    mov AH, 0xb ; set video color background
    mov BH, 0x0 ; ID da paleta de cores
    mov BL, 4   ; red
    int 10h
      
    mov SI, string1 ; moves string to SI
    mov AH, 0x0e    ; print char 
    int 0x10        ; video int
      
    .loop lodsb
          or AL,AL  ; check if end of string
          jz halt   
          int 0x10  ; print char
          jmp .loop ; go to next char
    
    halt:           HLT
            
Kernel:

    ;carrega o kernel no endereço 0x7e00
    mov AX, 0x07e0  ;segmento do kernel
    mov ES, AX  
    xor BX, BX      ;offset do kernel
    

    ;ler setor do disco
    mov AH, 0x02    ; já explicado no boot1
    mov AL, 50      ; ler 50 setores
    mov CH, 0x00    ; trilha 0
    mov CL, 0x04    ; setor 4
    mov DH, 0x00    ; cabeça 0
    mov DL, 0x00    ; drive 
    int 13h 

    jmp 0x07e0 : 0x0
