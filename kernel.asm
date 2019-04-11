org 0x7e00
     
jmp start

blue_screen_of_death: db 10,10,10,10,10,10,10,"                                    Windows",10,10,13,"    A fatal exception 0E has occurred at 0028:C562F1B7 in VXD ctpci9x(05)",10,13,"    + 00001853. The current application will be terminated.",10,10,13,"    *   Press any key to terminate the current application.",10,13,"    *   Press CNTRL+ALT+DEL again to restart your computer. You will",10,13,"        lose any unsaved information in all applications.",10,10,13,"                         Press any key to continue ",0

sleep:
	pusha
	mov ax, 0	; get tick count function
	mov bx, dx	; save ms
	int 1Ah	; call BIOS interrupt
	add bx, dx	; ms + ticks
	.wait:
	int 1Ah	; call BIOS interrupt
	cmp dx, bx
	jne .wait	; loop until we waited for ms amount
	popa
	ret

beep:
	push bx
	mov bx, ax
	mov al, 182
	out 43h, al
	mov ax, bx
	out 42h, al
	mov al, ah
	out 42h, al
	in al, 61h
	or al, 03h
	out 61h, al
	call sleep
	in al, 61h
	and al, 0FCh
	out 61h, al
	pop bx
	ret

wait_input :
    mov AH, 0x0
    int 16h     ; waits for user input
    ret

sddsprintf :
    lodsb
    or  AL,AL ; check if end of string
    jz  end

    mov AH, 0x0e    ; sets to print
    int 0x10 ; interrupt to print
    jmp sddsprintf

    end : ret

start: 

	mov AH, 00h
    mov AL, 03h
    int 10h     ; clear screen

    mov AH, 0xb ; set video color background
    mov BH, 0x0 ; ID da paleta de cores
    mov BL, 0x1 ; blue of death
    int 10h  

    mov BL, 0xf ; white font

    mov SI, blue_screen_of_death
    call sddsprintf

    call wait_input


	mov AL, 13h   ; text mode. 80x25. 16 colors. 8 pages
	mov AH, 0
	int 10h       ; set graphic mode

    mov AL, 0xA ; pixel color
    mov CX, 0    ; column
    mov DX, 0    ; row
    
    mov BX, 0    ; counter

    .loop 

		mov AH, 0Ch    
		mov BH, 0
		int 10h       ; set pixel
	
		inc BX	 
		inc CX
		cmp CX, 320
		je .zero_column

		add AL,0x1  ; add 1 to color
		cmp BX, 0xff
		jne .loop 	

	mov AH, 0xb ; set video color background
    mov BH, 0x0 ; ID da paleta de cores
    mov BL, 0x1 ; blue of death
    int 10h 

    call wait_input
 	
	.zero_column :
		mov CX, 0
		inc DX
		cmp DX, 200
		je .zero_row
		jmp .loop

	.zero_row :
		mov DX, 0
		jmp .loop