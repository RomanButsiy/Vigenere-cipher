MODEL small
STACK 100h
DATASEG
success db 10, 13, "Success!!!", 10, 13, "$"
IncorrectSymbol db 10, 13, "Incorrect symbol!", 10, 13, "--> $"
FileI db 10, 13, "File: inkey.txt", 10, 13, "$"
FileT db 10, 13, "File: text.txt", 10, 13, "$"
error db 10, 13, "File Not Found", 10, 13, "$"
EncryptDecrypt db 10, 13, "Encrypt, Decrypt? [E/d]", 10, 13, "$"
Decrypt db 10, 13, "Decrypt!!!", 10, 13, "$"
Encrypt db 10, 13, "Encrypt!!!", 10, 13, "$"
TextPath db "text.txt", 0 ; ���� � ����� ��� ����������
InKeyPath db "inkey.txt", 0 ; ���� � ������
OutKeyPath db "outkey.txt", 0 ; ���� �� ������������ �����
DescriptorText  dw 1	;********************************
DescriptorInKey  dw 1	;* ��� ����������� ����������� *
DescriptorOutKey  dw 1	;********************************
temp dw ?		; ���� inkey
tmp  dw ?		; ����� text
SsS dw 0031h
masuv dw 00E0h, 00E1h, 00E2h, 00E3h, 00B4h, 00E4h, 00E5h, 00BAh, 00E6h, 00E7h, 00E8h, 00B3h, 00BFh, 00E9h, 00EAh, 00EBh, 00ECh, 00EDh, 00EEh, 00EFh, 00F0h, 00F1h, 00F2h, 00F3h, 00F4h, 00F5h, 00F6h, 00F7h, 00F8h, 00F9h, 00FCh, 00FEh, 00FFh, 0030h, 0031h, 0032h, 0033h, 0034h, 0035h, 0036h, 0037h, 0038h, 0039h, 0020h, 0021h, 00B9h, 003Bh, 0025h, 003Ah, 003Fh, 002Ah, 0028h, 0029h, 002Dh, 002Bh, 003Dh, 002Eh, 002Ch, 0024h
len = ($ - masuv) ;������� �������� � �����
SSEG SEGMENT STACK
      db 200 dup(?)
SSEG ENDS
CODESEG
main:
mov ax,@Data
mov ds,ax             

mov SsS, 0031h
; ������� ����� text.txt ��� �������
    mov ah, 3Dh        ; �������� ���� ��� �������
	xor al, al         ; ����� ��� �������
    lea dx, TextPath   ; DS:dx �������� �� ��'� �����
	xor cx, cx 		   ; ���� �������� - ��������� ����
    int 21h            ; ��������� ����
    jc FileNotFound0_t    ; ���� ���� �� ������� ������� �� ������� ����������� ��� �������
	mov [DescriptorText], ax ; �������� ���������� �����
	call Pointer		; ��������� �������� �� ������� �����
; ������� ����� inkey.txt ��� �������
    mov ah, 3Dh        ; �������� ���� ��� �������
	xor al, al         ; ����� ��� �������
    lea dx, InKeyPath  ; DS:dx �������� �� ��'� �����
	xor cx, cx 		   ; ���� �������� - ��������� ����
    int 21h            ; ��������� ����
    jc FileNotFound1    ; ���� ���� �� ������� ������� �� ������� ����������� ��� �������
	mov [DescriptorInKey], ax ; �������� ���������� �����
	call Pointer		; ��������� �������� �� ������� �����
; ��������� ����� outkey.txt ��� ������ 
	mov ah, 3Ch        ; ��������� ���� ��� ������
	xor al, al
	lea dx, OutKeyPath ; DS:dx �������� �� ��'� �����
	xor cx, cx 		   ; ���� �������� - ��������� ����
    int 21h            ; ��������� ����
    jc FileNotFound2    ; ���� ���� �� ������� �������� �� ������� ����������� ��� �������
	mov [DescriptorOutKey], ax ; �������� ���������� �����
	call Pointer		; ��������� �������� �� ������� �����
	lea dx, EncryptDecrypt				; �������� ����������� 
    call strWrite
	mov ah,01h
    int 21h
	cmp al,'D'
	je DText
	cmp al,'d'
	je DText
	lea dx, Encrypt				; �������� ����������� 
    call strWrite
	jmp FeofText
	FileNotFound0_t:
	jmp FileNotFound0
	Dtext:
	lea dx, Decrypt				; �������� ����������� 
    call strWrite
	mov SsS, 0030h
	xor si, si
	FeofText:
	inc si
	cmp si, 000Ah
	je ExitSIn
	mov bx,[DescriptorInKey] ; ��������� ���������� � bx
	mov ah,3fh      ; ����� ������ � �����
    mov cx,1        ; 1 ����
    lea dx, temp      ; � ������ temp
	xor al, al
    int 21h         ; ������
    cmp ax,cx       ; ���� ����� ����� ��:
    jz Break    
    call Pointer		; ��������� �������� �� ������� �����
	jmp FeofText
	FileNotFound2:
	mov bx,[DescriptorInKey] ; ��������� ���������� � bx
    call closeF				; ��������� ���� inkey.txt
	FileNotFound1:
	mov bx,[DescriptorText]	; ��������� ���������� � bx
    call closeF					; ��������� ���� inkey.txt
	FileNotFound0:
    lea dx, error				; �������� ����������� ��� �������
    call strWrite 
    Exit:
    mov ah, 04ch				; ��������� ��������
    int 21h
	close:
	mov bx,[DescriptorInKey] ; ��������� ���������� � bx
    call closeF				; ��������� ���� inkey.txt
	mov bx,[DescriptorText]	; ��������� ���������� � bx
    call closeF					; ��������� ���� inkey.txt
	mov bx,[DescriptorOutKey]	; ��������� ���������� � bx
    call closeF					; ��������� ���� outkey.txt
	jmp Exit
	closeS:
	lea dx, success      		; �������� ����������� 
	call strWrite
	jmp close
	ExitSIn:
	lea dx, IncorrectSymbol		; �������� ����������� 
	call strWrite
	mov dx, temp
    mov ah,02h
    int 21h
	lea dx, FileI				; �������� ����������� 
    call strWrite
	jmp close
	ExitDTx:
	lea dx, FileT		; �������� ����������� 
	call strWrite
	jmp close
	Break:
	mov bx,[DescriptorText]
	mov ah,3fh      ; ����� ������ � �����
    mov cx,1        ; 1 ����
    lea dx, tmp      ; � ������ tmp
	xor al, al
    int 21h         ; ������
    cmp ax,cx       ; ���� ����� ����� ��:
    jnz closeS 
	xor si, si
	NextSi:
	cmp si, len		; ��������� si � �������� ������
	je ExitSIn			; ���� ���� ���� �� �������� ����������� ��� ������� � ��������
	mov ax, masuv[si]	; ������ si ������� ������ � ��������� � ax
	mov bx, temp		; ���������� ������ � inkey.txt ��������� � bx
	add si, 2			; �������� si �� 2
	cmp ax, bx			; ���������
	jne NextSi			; ���� �� ���� �� ����� ��������� ������� ������
	sub si, 2			; �������� si �� 2
	xor di, di
	NextDi:
	cmp si, len			; ��������� si � �������� ������
	jne Next0			; ���� ���� ���� ��
	xor si, si			; ��������� si
	; ���� SsS ����� 0031h �� �������� ���� ��������� ���� ����� text.txt 
	; � ���������� ���� �������� � ���� outkey.txt � ������ ������� �������� 
	; ���� ����������� ���� �����
	Next0:
	mov ax, SsS			; ���������
	cmp ax, 0031h
	je Ss1
	;**************************************
	;* ��� ���������� ������������ �����*
	;**************************************
	mov ax, masuv[si]	; ������ si ������� ������ � ��������� � ax
	mov bx, tmp			; ���������� ������ � text.txt ��������� � bx
	cmp ax, bx			; ���������
	jne IncDi
	mov bx,[DescriptorOutKey]
	mov ah,40h      ; ����� ������ � ����
    mov cx,1        ; 1 ����
	;add si, 2
    lea dx, masuv[di]    ; ������ di ������� ������ � ��������� � dx
	xor al, al
    int 21h 		; ������
	xor si, si
	jmp FeofText
	;************************************
	;* ��� ���������� ���������� �����*
	;************************************
	Ss1:
	mov ax, masuv[di]	; ������ si ������� ������ � ��������� � dx
	mov bx, tmp			; ���������� ������ � text.txt ��������� � bx
	cmp ax, bx			; ���������
	jne IncDi
	mov bx,[DescriptorOutKey]
	mov ah,40h      ; ����� ������ � ����
    mov cx,1        ; 1 ����
	lea dx, masuv[si]    ; ������ si ������� ������ � ��������� � dx
	xor al, al
    int 21h 			; ������
	;add si, 2
	xor si, si
	jmp FeofText		; ���������� �� ������� ��� ��������� �������� ������� �� �����
	IncDi:
	cmp di, len			; ��������� di � �������� ������
	je FeofText_t
	add di, 2			; �������� di �� 2
	add si, 2			; �������� si �� 2
	jmp NextDi
	FeofText_t:
	lea dx, IncorrectSymbol		; �������� ����������� 
	call strWrite
	mov dx, tmp
    mov ah,02h
    int 21h
	jmp ExitDTx

	closeF:
	mov ah,3eh				; ��������� ���� 
    int 21h
	ret
	
    strWrite:
	mov ah,09h
	int 21h
	ret

	Pointer:
    ; ��������� �������� �� ������� �����
	xor cx,cx
	xor dx,dx
    mov ah,42h
	xor al,al
    int 21h
	ret

end
