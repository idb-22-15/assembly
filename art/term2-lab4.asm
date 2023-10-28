segment .code
org 100h

; call proc33
; call proc34
; call proc35
; call proc36
; call proc37
; call proc38
; call proc39
; call proc40
; call proc41
; call proc42

mov ax, 4C00h
int 21h


;procedures

not_proc32:
    align 16, db 0
    db '=[MYDATA BEGIN]='

    db 'A = ['
    a1 db 244
    a2 db 2
    a3 db 3
    a4 db 77
    a5 db 250
    db ']'
    align 16, db 0

    db 'B = ['
    b1 db 254
    b2 db 2
    db ']'
    align 16, db 0

    db 'C = ['
    c1 db 4
    c2 db 5
    c3 db 6
    c4 db 7
    c5 db 8
    db ']'
    align 16, db 0

    times 16 db '='


proc33:
    mov ah, byte[a1]
    mov al, byte[a2]

    mov bl, byte[b1]
    mov bh, 0

    add ax, bx

    mov byte[c1], ah
    mov byte[c2], al
ret


proc34:
    mov ah, byte[a1]
    mov al, byte[a2]

    mov bl, byte[b1]
    mov bh, 0

    sub ax, bx

    mov byte[c1], ah
    mov byte[c2], al
ret


proc35:
    mov ah, byte[a1]
    mov al, byte[a2]

    shl ax, 1

    mov byte[c1], ah
    mov byte[c2], al
ret


proc36:
    mov dl, byte[a1]

    mov ah, byte[a2]
    mov al, byte[a3]

    mov bl, byte[b1]

    add al, bl
    jnc not_carry36
        add ah, 1
        jnc not_carry36
            add dl, 1

    not_carry36:

    mov byte[c1], dl
    mov byte[c2], ah
    mov byte[c3], al
ret


proc37:
    mov dl, byte[a1]

    mov ah, byte[a2]
    mov al, byte[a3]

    mov bl, byte[b1]

    sub al, bl
    jnc not_signed37
        sub ah, 1
        jnc not_signed37
            sub dl, 1

    not_signed37:

    mov byte[c1], dl
    mov byte[c2], ah
    mov byte[c3], al
ret


proc38:
    mov ah, byte[a1]
    mov al, byte[a2]

    mov bh, byte[b1]
    mov bl, byte[b2]

    add ax, bx

    mov byte[c1], ah
    mov byte[c2], al
ret


proc39:
    mov ah, byte[a1]
    mov al, byte[a2]

    mov bh, byte[b1]
    mov bl, byte[b2]

    sub ax, bx

    mov byte[c1], ah
    mov byte[c2], al
ret


proc40:
    mov bl, byte[b1]

    add byte[a5], bl
    jnc not_carry40
        add byte[a4], 1
        jnc not_carry40
            add byte[a3], 1
            jnc not_carry40
                add byte[a2], 1
                jnc not_carry40
                    add byte[a1], 1

    not_carry40:

    mov al, byte[a1]
    mov byte[c1], al
    mov al, byte[a2]
    mov byte[c2], al
    mov al, byte[a3]
    mov byte[c3], al
    mov al, byte[a4]
    mov byte[c4], al
    mov al, byte[a5]
    mov byte[c5], al
ret


proc41:
    mov bl, byte[b1]
    sub byte[a5], bl
    jnc not_carry41
        sub byte[a4], 1
        jnc not_carry41
            sub byte[a3], 1
            jnc not_carry41
                sub byte[a2], 1
                jnc not_carry41
                    sub byte[a1], 1

    not_carry41:

    mov al, byte[a1]
    mov byte[c1], al
    mov al, byte[a2]
    mov byte[c2], al
    mov al, byte[a3]
    mov byte[c3], al
    mov al, byte[a4]
    mov byte[c4], al
    mov al, byte[a5]
    mov byte[c5], al
ret


proc42:
    mov ah, byte[a1]
    mov al, byte[a2]

    mov bh, 0
    mov bl, byte[b1]

    mul bx

    mov byte[c1], dl
    mov byte[c2], ah
    mov byte[c3], al
ret
