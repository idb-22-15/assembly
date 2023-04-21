%macro init 5
	mov ax, %1
	mov bx, %2
	mov cx, %3
	mov dx, %4
	call %5
%endmacro

segment .code
org 100h

;init 15, 0, 0, 0, proc1
;init 1, 0, 0, 0, proc2
;init 72A8h, 0, 0, 0, proc3
;init 72A8h, 0, 0, 0, proc4
;init 1, 2, 3, 4, proc5
;init 0, 1234h, 0, 0, proc6
;init 0, 0, 0, 0, proc7
;init 7, 3, 0, 0, proc8
;init 2, 5, 3, 0, proc9
init 0FFFFh, 0, 0, 0, proc10

mov ax, 4C00h
int 21h

proc1:
	;bx = 4 * ax
	mov bx, ax
	shl bx, 2
ret


proc2:
	;bx = 5 * ax
	mov bx, ax
	shl bx, 2
	add bx, ax
ret

proc3:
	and ax, 0F000h
ret

proc4:
	and ax, 0F000h
	shr ax, 8
ret

proc5:
	;ax = 4*ax – 3*bx – cx + 11*dx
	shl ax, 2
	
	sub ax, cx
	
	sub ax, bx
	shl bx, 1
	sub ax, bx
	
	sub ax, dx
	shl dx, 3
	add ax, dx
	shr dx, 1
	add ax, dx
ret

proc6:
	;bx = 1234h -> bx = 2341h
	mov ax, bx
	and ax, 0F000h
	shr ax, 12

	shl bx, 4

	OR bx, ax
ret

proc7:
	;dx -> 1100 1100 1100 1100b = CCCCh
	mov cx, 4
	loop_start:
		shl dx, 1
		inc dx
		shl dx, 1
		inc dx
		shl dx, 2
	loop loop_start
ret

proc8:
	;Заданы ax и bx, если  (bx + 4) = ax, 	то cx = 1111h, иначе cx = FFFFh.
	add bx, 4
	cmp bx, ax

	jnz no8
	
	mov cx, 1111h
	jmp end_if8

	no8:
		mov cx, 0FFFFh
		jmp end_if8

	end_if8:
ret

proc9:
	;Заданы ax, bx и cx, если (bx >= 5) and (ax <= cx) , то dx = 1111h, иначе dx = FFFFh

	cmp bx, 5
	js no9
	
	cmp ax, cx
	js yes9
	jns if9

	if9:
		cmp ax, cx
		jz yes9
		jnz no9
	
	yes9:
		mov dx, 1111h
		jmp end_if9
	no9:
		mov dx, 0FFFFh
		jmp end_if9
	end_if9:
ret

proc10:
	mov cx, 16 ;16 итераций
	mov bx, 0 ;кол-во единиц
	loop10:
		mov dx, ax ;копируем
		and dx, 0000000000000001b ;берём крайнее число
		add bx, dx ;прибавляем
		shr ax, 1 ;сдвигаем
		loop loop10
ret
