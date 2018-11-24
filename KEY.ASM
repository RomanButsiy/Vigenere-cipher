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
TextPath db "text.txt", 0 ; файл з кодом для шифрування
InKeyPath db "inkey.txt", 0 ; файл з ключем
OutKeyPath db "outkey.txt", 0 ; файл із зашифрованим кодом
DescriptorText  dw 1	;********************************
DescriptorInKey  dw 1	;* тут зберігаються дескриптори *
DescriptorOutKey  dw 1	;********************************
temp dw ?		; ключ inkey
tmp  dw ?		; текст text
SsS dw 0031h
masuv dw 00E0h, 00E1h, 00E2h, 00E3h, 00B4h, 00E4h, 00E5h, 00BAh, 00E6h, 00E7h, 00E8h, 00B3h, 00BFh, 00E9h, 00EAh, 00EBh, 00ECh, 00EDh, 00EEh, 00EFh, 00F0h, 00F1h, 00F2h, 00F3h, 00F4h, 00F5h, 00F6h, 00F7h, 00F8h, 00F9h, 00FCh, 00FEh, 00FFh, 0030h, 0031h, 0032h, 0033h, 0034h, 0035h, 0036h, 0037h, 0038h, 0039h, 0020h, 0021h, 00B9h, 003Bh, 0025h, 003Ah, 003Fh, 002Ah, 0028h, 0029h, 002Dh, 002Bh, 003Dh, 002Eh, 002Ch, 0024h
len = ($ - masuv) ;кількість елементів у масиві
SSEG SEGMENT STACK
      db 200 dup(?)
SSEG ENDS
CODESEG
main:
mov ax,@Data
mov ds,ax             

mov SsS, 0031h
; відкритя файлу text.txt для читання
    mov ah, 3Dh        ; відкриваєм файл для читання
	xor al, al         ; тільки для читання
    lea dx, TextPath   ; DS:dx вказівник на ім'я файла
	xor cx, cx 		   ; Немає атрибутів - звичайний файл
    int 21h            ; відкриваємо файл
    jc FileNotFound0_t    ; якщо файл не вдалося відкрити то виводим повідомлення про помилку
	mov [DescriptorText], ax ; зберігаємо дескриптор файлу
	call Pointer		; переміщаємо вказівник на початок файлу
; відкритя файлу inkey.txt для читання
    mov ah, 3Dh        ; відкриваєм файл для читання
	xor al, al         ; тільки для читання
    lea dx, InKeyPath  ; DS:dx вказівник на ім'я файла
	xor cx, cx 		   ; Немає атрибутів - звичайний файл
    int 21h            ; відкриваємо файл
    jc FileNotFound1    ; якщо файл не вдалося відкрити то виводим повідомлення про помилку
	mov [DescriptorInKey], ax ; зберігаємо дескриптор файлу
	call Pointer		; переміщаємо вказівник на початок файлу
; створення файлу outkey.txt для запису 
	mov ah, 3Ch        ; створюємо файл для запису
	xor al, al
	lea dx, OutKeyPath ; DS:dx вказівник на ім'я файла
	xor cx, cx 		   ; Немає атрибутів - звичайний файл
    int 21h            ; створюємо файл
    jc FileNotFound2    ; якщо файл не вдалося створити то виводим повідомлення про помилку
	mov [DescriptorOutKey], ax ; зберігаємо дескриптор файлу
	call Pointer		; переміщаємо вказівник на початок файлу
	lea dx, EncryptDecrypt				; виводимо повідомлення 
    call strWrite
	mov ah,01h
    int 21h
	cmp al,'D'
	je DText
	cmp al,'d'
	je DText
	lea dx, Encrypt				; виводимо повідомлення 
    call strWrite
	jmp FeofText
	FileNotFound0_t:
	jmp FileNotFound0
	Dtext:
	lea dx, Decrypt				; виводимо повідомлення 
    call strWrite
	mov SsS, 0030h
	xor si, si
	FeofText:
	inc si
	cmp si, 000Ah
	je ExitSIn
	mov bx,[DescriptorInKey] ; переміщаємо дескриптор в bx
	mov ah,3fh      ; будем читать з файлу
    mov cx,1        ; 1 байт
    lea dx, temp      ; в память temp
	xor al, al
    int 21h         ; читаємо
    cmp ax,cx       ; якщо кінець файлу то:
    jz Break    
    call Pointer		; переміщаємо вказівник на початок файлу
	jmp FeofText
	FileNotFound2:
	mov bx,[DescriptorInKey] ; переміщаємо дескриптор в bx
    call closeF				; закриваємо файл inkey.txt
	FileNotFound1:
	mov bx,[DescriptorText]	; переміщаємо дескриптор в bx
    call closeF					; закриваємо файл inkey.txt
	FileNotFound0:
    lea dx, error				; виводимо повідомлення про помилку
    call strWrite 
    Exit:
    mov ah, 04ch				; закриваємо програму
    int 21h
	close:
	mov bx,[DescriptorInKey] ; переміщаємо дескриптор в bx
    call closeF				; закриваємо файл inkey.txt
	mov bx,[DescriptorText]	; переміщаємо дескриптор в bx
    call closeF					; закриваємо файл inkey.txt
	mov bx,[DescriptorOutKey]	; переміщаємо дескриптор в bx
    call closeF					; закриваємо файл outkey.txt
	jmp Exit
	closeS:
	lea dx, success      		; виводимо повідомлення 
	call strWrite
	jmp close
	ExitSIn:
	lea dx, IncorrectSymbol		; виводимо повідомлення 
	call strWrite
	mov dx, temp
    mov ah,02h
    int 21h
	lea dx, FileI				; виводимо повідомлення 
    call strWrite
	jmp close
	ExitDTx:
	lea dx, FileT		; виводимо повідомлення 
	call strWrite
	jmp close
	Break:
	mov bx,[DescriptorText]
	mov ah,3fh      ; будем читать з файлу
    mov cx,1        ; 1 байт
    lea dx, tmp      ; в память tmp
	xor al, al
    int 21h         ; читаємо
    cmp ax,cx       ; якщо кінець файлу то:
    jnz closeS 
	xor si, si
	NextSi:
	cmp si, len		; порівнюємо si з довжиною масива
	je ExitSIn			; якщо вони рівні то виводимо повідомлення про помилку і виходимо
	mov ax, masuv[si]	; беремо si елемент масива і переміщаємо в ax
	mov bx, temp		; прочитаний символ з inkey.txt переміщаємо в bx
	add si, 2			; збільшуємо si на 2
	cmp ax, bx			; порівнюємо
	jne NextSi			; якщо не рівні то берем наступний елемент масива
	sub si, 2			; зменшуємо si на 2
	xor di, di
	NextDi:
	cmp si, len			; порівнюємо si з довжиною масива
	jne Next0			; якщо вони рівні то
	xor si, si			; обнуляємо si
	; якщо SsS рівний 0031h то програма буде шиврувати вміст файлу text.txt 
	; і результата буде записано у файл outkey.txt в іншому випадку програма 
	; буде дешифрувати вміст файлу
	Next0:
	mov ax, SsS			; порівнюємо
	cmp ax, 0031h
	je Ss1
	;**************************************
	;* тут відбувається дешифрування файлу*
	;**************************************
	mov ax, masuv[si]	; беремо si елемент масива і переміщаємо в ax
	mov bx, tmp			; прочитаний символ з text.txt переміщаємо в bx
	cmp ax, bx			; порівнюємо
	jne IncDi
	mov bx,[DescriptorOutKey]
	mov ah,40h      ; будем писати у файл
    mov cx,1        ; 1 байт
	;add si, 2
    lea dx, masuv[di]    ; беремо di елемент масива і переміщаємо в dx
	xor al, al
    int 21h 		; пишемо
	xor si, si
	jmp FeofText
	;************************************
	;* тут відбувається шифрування файлу*
	;************************************
	Ss1:
	mov ax, masuv[di]	; беремо si елемент масива і переміщаємо в dx
	mov bx, tmp			; прочитаний символ з text.txt переміщаємо в bx
	cmp ax, bx			; порівнюємо
	jne IncDi
	mov bx,[DescriptorOutKey]
	mov ah,40h      ; будем писати у файл
    mov cx,1        ; 1 байт
	lea dx, masuv[si]    ; беремо si елемент масива і переміщаємо в dx
	xor al, al
    int 21h 			; пишемо
	;add si, 2
	xor si, si
	jmp FeofText		; переходимо на початок щоб прочитати наступні символи із файлів
	IncDi:
	cmp di, len			; порівнюємо di з довжиною масива
	je FeofText_t
	add di, 2			; збільшуємо di на 2
	add si, 2			; збільшуємо si на 2
	jmp NextDi
	FeofText_t:
	lea dx, IncorrectSymbol		; виводимо повідомлення 
	call strWrite
	mov dx, tmp
    mov ah,02h
    int 21h
	jmp ExitDTx

	closeF:
	mov ah,3eh				; закриваємо файл 
    int 21h
	ret
	
    strWrite:
	mov ah,09h
	int 21h
	ret

	Pointer:
    ; переміщаємо вказівник на початок файлу
	xor cx,cx
	xor dx,dx
    mov ah,42h
	xor al,al
    int 21h
	ret

end
