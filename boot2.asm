org 0x0500
jmp 0x0000:start
 
string1: db "4Foda-se", 10, 10, 10, 13
strlen1: equ $-string1
 

start:
    XOR ax, ax
    MOV ds, ax  ; reset 

    MOV ah, 00h ; set video mode
    MOV al, 03h ; text mode. 80x25. 16 colors. 8 pages
    INT 10h     ; int video mode

    MOV ah, 0xb ; set video color background
    MOV bh, 0x0 ; ID da paleta de cores
    MOV bl, 4   ; red
    INT 10h
      
    MOV si, string1 ; moves string to SI
    MOV ah, 0x0e    ; print char 
    INT 0x10        ; video int
      
    .loop lodsb
          OR al,al  ; check if end of string
          JZ halt   
          INT 0x10  ; print char
          JMP .loop ; go to next char
    
    halt:           HLT
            
Kernel:

    ;carrega o kernel no endereço 0x7e00
    mov ax, 0x07e0  ;segmento do kernel
    mov es, ax  
    xor bx, bx      ;offset do kernel
    

    ;Ler setor do disco
    MOV ah, 0x02    ; já explicado no boot1
    MOV al, 50  ; ler 50 setores
    MOV ch, 0x00    ; trilha 0
    MOV cl, 0x04    ; setor 4
    MOV dh, 0x00    ; cabeça 0
    MOV dl, 0x00    ; drive 
    int 13h 

    jmp 0x07e0 : 0x0