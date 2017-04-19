org 0x7c00 ; seta offset para 0x7c00
jmp 0x0000: start

start:

	xor AX, AX ; zera ax xor é mais rapido que mov
	mov DS, AX ; zera ds


reset:
	
	mov AH, 0
	mov DL, 0
	int 13h
	jc reset


boot2:
	; escolhe o espaço de memoria que será utilizado 

	mov AX, 0x0050 ; memoria onde o boot2 sera carregado
	mov ES, AX
	xor BX, BX ; zera bx

	mov AH, 02h  ; seta para ler disco
	mov AL, 0x02 ; 2 setores
	mov CH, 0x00 ; trilha 0
	mov CL, 0x02 ; setor 2
	mov DH, 0x00 ; cabeça 0
	mov DL, 0x00 ; drive
	int 13h      ; int de disco

	jc boot2 ; se der algum erro ele volta a operação

	jmp 0x0050 : 0x0 ; caso não vai direto para o boot2


times 510-($-$$) db 0
dw 0xAA55
