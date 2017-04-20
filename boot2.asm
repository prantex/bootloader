org 0x0500
jmp 0x0000:start
 
banner: db "______                 _        ",10,13,"| ___ \               | |       ",10,13,"| |_/ / __ _ _ __ __ _| |_ __ _ ",10,13,"| ___ \/ _` | '__/ _` | __/ _` |",10,13,"| |_/ / (_| | | | (_| | || (_| |",10,13,"\____/ \__,_|_|  \__,_|\__\__,_|",10,13
split: db "==================================", 10 ,13
version: db "0.0.1v # Feio mas funcional", 10,13
end_str: db 10,10,10,10,10,10,10,10,10,10,10,10,13
carregando: db "Loading", 10, 13, 0
ponto: db "." , 0


sddsprintf:
    mov SI, BX      ; moves string to SI
    mov AH, 0xe     ; print char 
      
    .loop lodsb
          or AL,AL  ; check if end of string
          jz .end   
          int 0x10  ; print char
          jmp .loop ; go to next char

    .end ret 

start:
    xor AX, AX
    mov DS, AX  ; reset 

    mov AH, 00h ; set video mode
    mov AL, 03h ; text mode. 80x25. 16 colors. 8 pages
    int 10h     ; int video mode

    mov AH, 0xb ; set video color background
    mov BH, 0x0 ; ID da paleta de cores
    mov BL, 0x0 ; black
    int 10h
      
    mov BX, banner ; moves string to BL
    jmp sddsprintf  ; prints whatever is in BX

    mov BX, version
    jmp sddsprintf

    mov BX, split
    jmp sddsprintf

    mov BX, end_str
    jmp sddsprintf
    
    mov BX, carregando
    jmp sddsprintf
    
    mov DI, 3
    
repete:
    ; 2 second delay (2,000,000 microseconds)
    mov AX, 10000 ; place a 10000 decimal in ax
    mov DX, 200 ; place 200 decimal in dx
    mul DX ; multiply ax times dx and place
    mov CX,DX ; the 32 bit product in dx:ax (lower 16 bits in ax)
    mov DX,AX
    xor AX,AX
    mov AH, 86h 
    int 15h
    
    mov BX, ponto
    jmp sddsprintf
    
    dec DI
    cmp DI, 0
    jne repete

    jmp Kernel
            
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
