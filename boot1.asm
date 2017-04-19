org 0x7c00 ; seta offset para 0x7c00
jmp 0x0000: start

start:

	xor ax, ax ; zera ax
	mov ds, ax ; zera ds


reset:
	
	mov ah, 0
	mov dl, 0
	int 13h
	jc reset


boot2:
	; Escolhe o espaço de memoria que será utilizado 

	mov ax, 0x0050 ; memoria onde o boot2 sera carregado
	mov es, ax
	xor bx, bx ; zera bx


	; Ler o disco

	mov ah, 02h  ; seta para ler
	mov al, 0x02 ; 2 setores
	mov ch, 0x00 ; trilha 0
	mov cl, 0x02 ; setor 2
	mov dh, 0x00 ; cabeça 0
	mov dl, 0x00 ; drive
	int 13h      ; int de disco

	jc boot2 ; se der algum erro ele volta a operação

	jmp 0x0050 : 0x0 ; caso não vai direto para o boot2


times 510-($-$$) db 0
dw 0xAA55