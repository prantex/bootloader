org 0x7e00
     
jmp start

zero_row :
	mov DX, 0
	ret

zero_column :
	mov CX,0
	ret

start: 
	mov AL, 03h   ; text mode. 80x25. 16 colors. 8 pages
	mov AH, 0
	int 10h       ; set graphic mode

	mov AH, 0xb   ; set video color background
    mov BH, 0x0   ; ID da paleta de cores
    mov BL, 0x0   ; black
    int 10h

    mov AL, 1100b ; pixel color

    .loop mov CX, 0    ; column
		  mov DX, 0    ; row
		  mov AH, 0ch   
		  mov BH, 0
		  int 10h       ; set pixel
		  
		  add CX, 1    
		  add DX, 1
		  
		  cmp CX, 80    ; compare CX to max
		  jg zero_column


		  cmp DX, 25    ; compare DX to max
		  jg zero_row

		  add AL, 0x1   ; add 1 to color
		  jmp .loop

