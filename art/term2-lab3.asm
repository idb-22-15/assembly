%macro init 5
	mov ax, %1
	mov bx, %2
	mov cx, %3
	mov dx, %4
	call %5
%endmacro

;start
mycode: segment .code
org 100h
start:

;;proc 24
; mov si, 0
; call proc24

;;proc 25
; mov si, 0
; mov bl, 7
; call proc25

;;proc 26
; mov bl, 3
; mov bh, 9
; call proc26

;;proc 27
; mov si, 0
; call proc24
; mov si, 0
; call proc27

;;proc 28
; mov si, 5
; call proc24
; call proc28

; ;proc 29
; mov si, 5
; call proc24
; call proc29

; ;proc 30
; mov si, 5
; call proc24
; call proc29
; mov si, 5
; call proc30

; ;proc 31
; mov si, 5
; call proc24
; mov si, 5
; mov dl, 0; кол-во вхождений символа
; mov dh, "i"; найти этот символ
; call proc31


;	end
mov ax, 4C00h
int 21h

proc24:
	mov word[si], "[ "
	mov dword[si + 2], "Nabo"
	mov dword[si + 6], "ishi"
	mov dword[si + 10], "kov "
	mov dword[si + 14], "Arte"
	mov dword[si + 18], "miy "
	mov word[si + 22], "]"
ret

proc25:
	mov bh, 0
	mov cx, bx

	loop25:
		mov byte[si], "#"
		inc si
		loop loop25
ret

proc26:
	mov ah, bh
	mov bh, 0
	mov si, bx
	sub ah, bl
	mov bl, ah
	mov cx, bx

	loop26:
		mov byte[si], "#"
		inc si
		loop loop26
ret

proc27:
	mov cx, 0 ;кол-во символов до ]

	m27:
		mov ah, byte[si]
		inc si
		inc cx
		cmp ah, "]"
		jnz m27
	dec cx
	mov ax, cx
ret

proc28:
	mov si, 0

	before28:
		mov ah, byte[si]
		inc si
		cmp ah, "["
		jnz before28
	dec si
	
	in28:
		mov ah, byte[si]
		cmp ah, "]"
		jz endIn28

		mov byte[si], "#"
		inc si
		jmp in28

		endIn28:
			mov byte[si], "#"
ret

proc29:
	mov si, 0

	before29:
		mov ah, byte[si]
		cmp ah, "["
		jz endBefore29

		mov byte[si], "#"
		inc si
		jmp before29
	endBefore29:

	in29:
		mov ah, byte[si]
		cmp ah, "]"
		jz endIn29

		inc si
		jmp in29
		
	endIn29:
		inc si

	after29:
		cmp si, 50h
		jz endAfter29

		mov byte[si], "#"
		inc si
		jmp after29

		endAfter29:

ret

proc30:
	mov bx, si; начало строки
	mov cx, 0; длина строки со скобками

	findLength:
		mov ah, byte[si]
		cmp ah, "]"
		jz endFindLength

		inc cx
		inc si
		jmp findLength

	endFindLength:
		inc cx ;доходим до ]
		inc si ;доходим до ]

	add si, 10

	loopCopy30:
		mov ah, byte[bx]
		mov byte[si], ah
		inc si
		inc bx
		loop loopCopy30
ret

proc31:
	findChar:
		mov ah, byte[si]
		cmp ah, "]"
		jz endFindChar

		cmp ah, dh

		jz addToCount
		jnz notAddToCount

		addToCount:
			inc dl

		notAddToCount:
			inc si
			jmp findChar

	endFindChar:
	
ret