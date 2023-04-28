%macro print_str 1
    mov dx, %1

    mov ah, 09h
    int 21h
%endmacro

segment .code
org 100h

call clear_screen
; call proc44
; call proc45
; call proc46
; call proc47
; call proc48
; call proc49
; call proc50

mov ax, 4C00h
int 21h

;procedures

clear_screen:
	mov ah, 00h
	mov al, 3
	int 10h
ret


proc44:
	mov dl, 5

	add dl, 48
	mov byte[0], dl
	mov byte[1], "$"
	print_str 0
ret


proc45:
	mov dl, 11
    
	cmp dl, 10
	js not_gap45
		add dl, 7
        
	not_gap45:
	add dl, 48
	mov byte[0], dl
	mov byte[1], "$"
	print_str 0
ret

proc46:
	mov ah, 01h
	int 21h

	inc al
	cmp al, 58
	jnz m46
		mov al, 65

	m46:
	mov byte[0], al
	mov byte[1], "$"
	print_str 0
ret


proc47:
    mov ah, 01h
	int 21h

    mov ah, 0
    mov cx, ax
    sub cx, 48

    mov bx, 0
    mov al, 48

    loop47:
        cmp al, 58
        jnz not_gap47
            add al, 7
            sub cx, 7

        not_gap47:
        mov byte[bx], al
        inc al
        inc bx
        loop loop47
    mov byte[bx], '$'

    print_str 0
ret


proc48:
    mov si, 0
    do_while_string48:
        mov ah, 01h
        int 21h

        cmp al, '$'
        jz end_while48

        mov byte[si], ' '
        inc si

        jmp do_while_string48
        
    end_while48:
        mov byte[si], '$'
        print_str 0
ret


proc49:
    mov si, 0
    mov cx, 5
    input5char:
        mov ah, 01h
        int 21h

        mov byte[si], al
        inc si
        loop input5char
    mov byte[si], '$'

    mov si, 0
    mov cx, 2
    mov bx, 4
    reverse:
        mov al, byte[si]
        mov ah, byte[si + bx]
        
        mov byte[si], ah
        mov byte[si + bx], al
        inc si
        sub bx, 2
        loop reverse

    print_str 0
ret


proc50:
    mov ah, 01h
    int 21h

    cmp al, 97
    js not_lower

    cmp al, 123
    jns not_lower

    sub al, 32
    
    not_lower:
        mov byte[0], al
        mov byte[1], '$'
    print_str 0
ret