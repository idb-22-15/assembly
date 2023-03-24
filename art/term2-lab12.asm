%macro init 5
	MOV AX, %1
	MOV BX, %2
	MOV CX, %3
	MOV DX, %4
	CALL %5
%endmacro


MYCODE: segment .code
org 100h
START:

;init 15, 0, 0, 0, PROC1
;init 1, 0, 0, 0, PROC2
;init 72A8h, 0, 0, 0, PROC3
;init 72A8h, 0, 0, 0, PROC4
;init 1, 2, 3, 4, PROC5
;init 0, 1234h, 0, 0, PROC6
;init 0, 0, 0, 0, PROC7
;init 7, 3, 0, 0, PROC8
;init 2, 5, 3, 0, PROC9

mov AX, 4C00h
int 21h

PROC1:
	;BX = 4 * AX
	MOV BX, AX
	SHL BX, 2
RET


PROC2:
	;BX = 5 * AX
	MOV BX, AX
	SHL BX, 2
	ADD BX, AX
RET

PROC3:
	AND AX, 0F000h
RET

PROC4:
	AND AX, 0F000h
	SHR AX, 8
RET

PROC5:
	;AX = 4*AX – 3*BX – CX + 11*DX
	SHL AX, 2
	
	SUB AX, CX
	
	SUB AX, BX
	SHL BX, 1
	SUB AX, BX
	
	SUB AX, DX
	SHL DX, 3
	ADD AX, DX
	SHR DX, 1
	ADD AX, DX
RET

PROC6:
	;BX = 1234h -> BX = 2341h
	MOV AX, BX
	AND AX, 0F000h
	SHR AX, 12

	SHL BX, 4

	OR BX, AX
RET

PROC7:
	;DX -> 1100 1100 1100 1100b = CCCCh
	MOV CX, 4
	LOOP_START:
		SHL DX, 1
		INC DX
		SHL DX, 1
		INC DX
		SHL DX, 2
	LOOP LOOP_START
RET

PROC8:
	;Заданы AX и BX, если  (BX + 4) = AX, 	то CX = 1111h, иначе CX = FFFFh.
	ADD BX, 4
	CMP BX, AX

	JNZ NO
	
	MOV CX, 1111h
	JMP END_IF

	NO:
		MOV CX, 0FFFFh
		JMP END_IF

	END_IF:
RET

PROC9:
	;Заданы AX, BX и CX, если (BX >= 5) and (AX <= CX) , то DX = 1111h, иначе DX = FFFFh

	CMP BX, 5
	JS NO2
	
	CMP AX, CX
	JS YES2
	JNS IF2

	IF2:
		CMP AX, CX
		JZ YES2
		JNZ NO2
	
	YES2:
		MOV DX, 1111h
		JMP END_IF2
	NO2:
		MOV DX, 0FFFFh
		JMP END_IF2
	END_IF2:
RET

PROC10:
	