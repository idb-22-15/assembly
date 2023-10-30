org 100h

STR_EMPTY equ 0
STR_ADDR equ 0
STR_MAX_LEN equ 32


%macro init_registers 4
  mov si, 0
  mov ax, %1
  mov bx, %2
  mov cx, %3
  mov dx, %4
%endmacro


%macro exit 0
  mov ah, 4Ch
  mov al, 00h
  int 21h
%endmacro


; @param 1 - string address
%macro init_string 1
  mov byte[%1], STR_EMPTY
%endmacro


; @param 1 - string address
%macro init_string_helloworld 1
  mov dword[%1], "hell"
  mov dword[%1 + 4], "o wo"
  mov dword[%1 + 8], "rld"
%endmacro


; @param  1  - string address
; @return dx - length
%macro get_len 1
  push si
  push ax
  mov si, %1
  call get_len_by_si
  pop ax
  pop si
%endmacro


; @param  1 - string address
;         2 - char
%macro insert_back 2
  pusha
  mov si, %1
  mov bl, %2
  call insert_back_call
  popa
%endmacro


; @param  1 - string address
;         2 - char
;         3 - char position
%macro insert_into 3
  pusha
  mov si, %1
  mov ah, %2
  mov al, %3
  call insert_into_call
  popa
%endmacro


; @param  1 - string address
;         2 - char
%macro insert_forward 2
  insert_into %1, %2, 1
%endmacro


; @param  1  - string address
;         2  - position
; @return cx - bool
%macro is_valid_position 2
  push ax
  push dx

  get_len %1
  mov ax, %2

  mov cx, 0

  ; len >= max len
  cmp dx, STR_MAX_LEN
  jz %%is_valid_position_end

  ; ax <= 0
  cmp ax, 0
  js %%is_valid_position_end
  jz %%is_valid_position_end

  ; ax >= len + 1
  inc dx
  cmp ax, dx
  jns %%is_valid_position_end

  cmp dx, ax
  js %%is_valid_position_end

  mov cx, 1

  %%is_valid_position_end:
  pop dx
  pop ax
%endmacro


; @param  1  - char address
;         2  - char
;         3  - char number
; @return dh - char position (0 if not found, last if char number == 0)
;         dl - char counter
%macro find_char_pos 3
  push si
  push ax
  mov si, %1
  mov ah, %2
  mov al, %3
  call find_char_pos_call
  pop ax
  pop si
%endmacro


; @param  1  - address
;         2  - char
; @return dl - char count
%macro get_char_count 2
  find_char_pos %1, %2, 0
  mov dh, 0
%endmacro


; @param  1  - address
;         2  - char
; @return dh - char last position
%macro find_char_last_pos 2
  find_char_pos %1, %2, 0
  mov dl, 0
%endmacro


section .code
global _start
_start:
  init_registers 0, 0, 0, 0

  ; call task1
  ; call task2
  ; call task3
  ; call task4
  ; call task5
  ; call task6
  ; call task7
  ; call task8
  ; call task9
  ; call task10
  ; call task11
  ; call task12
  exit


init_string_by_si:
  mov byte[si], STR_EMPTY
  ret

task1:
  mov si, 00h
  call init_string_by_si
  mov si, 20h
  call init_string_by_si
  mov si, 40h
  call init_string_by_si
  ret

task2:
  init_string 0
  init_string 20h
  init_string 40h
  ret

task3:
  mov si, STR_ADDR
  mov cx, 14
  call fill_string_by_len
  ret

task4:
  init_string_helloworld STR_ADDR
  get_len STR_ADDR
  ret

task5:
  init_string_helloworld STR_ADDR
  insert_back STR_ADDR, "!"
  ret

task6:
  init_string_helloworld STR_ADDR
  mov cx, 50
  task6_loop:
    insert_back STR_ADDR, "!"
    loop task6_loop
  ret

task7:
  init_string_helloworld STR_ADDR
  mov cx, 50
  task7_loop:
    insert_forward STR_ADDR, "!"
    loop task7_loop
  ret

task8:
  init_string_helloworld STR_ADDR
  insert_into STR_ADDR, "!", 3
  ret

task9:
  init_string_helloworld STR_ADDR
  find_char_pos STR_ADDR, 'l', 1
  ret

task10:
  init_string_helloworld STR_ADDR
  find_char_last_pos STR_ADDR, 'l'
  ret

task11:
  init_string_helloworld STR_ADDR
  find_char_pos STR_ADDR, 'l', 3
  ret

task12:
  init_string_helloworld STR_ADDR
  get_char_count STR_ADDR, "l"
  ret


;@param  si - address
;        cx - length
fill_string_by_len:
  push si
  push cx

  fill_string_by_len_loop:
  mov byte[si], "#"
  inc si
  loop fill_string_by_len_loop

  pop si
  pop cx
  ret


;@param  si - string address
;@return dx - length
get_len_by_si:
  push si
  push ax

  mov dx, 1

  get_len_by_si_loop:
    mov al, [si]
    cmp al, STR_EMPTY
    jz get_len_by_si_end

    inc si
    inc dx
    jmp get_len_by_si_loop

  get_len_by_si_end:
  pop ax
  pop si
  ret


; @param  si - string address
;         bl - char
insert_back_call:
  pusha

  get_len si
  is_valid_position si, dx
  cmp cx, 0
  jz insert_back_call_end

  add si, dx
  dec si
  mov byte[si], bl
  mov byte[si + 1], STR_EMPTY

  insert_back_call_end:
  popa
  ret


; @param  si - address
;         ah - char
;         al - char position
insert_into_call:
  pusha

  push ax
  mov ah, 0
  is_valid_position si, ax
  pop ax
  cmp cx, 0
  jz insert_into_call_end

  dec al
  get_len si
  mov cx, dx
  sub cl, al
  inc cx
  add si, dx

  insert_into_call_loop:
    mov bh, [si]
    mov byte[si + 1], bh
    dec si
    loop insert_into_call_loop

  mov byte[si + 1], ah
  popa
  ret

  insert_into_call_end:
  popa
  ret


; @param  si - address
;         ah - char
;         al - char number
; @return dh - char position (0 if not found, last if al == 0)
;         dl - char counter
find_char_pos_call:
  push si
  push ax
  push cx

  get_len si
  mov cx, dx

  mov dh, 0
  mov dl, 0

  mov bh, 0 ; current position

  find_char_pos_call_loop:
    inc bh
    cmp [si], ah
    jz find_char_pos_call_inc_couter
    jnz find_char_pos_call_else

    find_char_pos_call_inc_couter:
      inc dl
      mov dh, bh
      cmp dl, al
      jz find_char_pos_call_end

    find_char_pos_call_else:


    inc si
    loop find_char_pos_call_loop

  cmp al, 0
  jz find_char_pos_call_end
  cmp al, dl
  jz find_char_pos_call_end

  mov dx, 0

  find_char_pos_call_end:
  pop cx
  pop ax
  pop si
  ret
