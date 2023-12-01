
org     100h

section .data
  video_mode equ 3

  border_horisontal         equ 196 ; ─
  border_vertical           equ 179 ; │
  border_top_left_angle     equ 218 ; ┌
  border_top_right_angle    equ 191 ; ┐
  border_bottom_left_angle  equ 192 ; └
  border_bottom_right_angle equ 217 ; ┘

  color_black   equ 0
  color_blue    equ 1
  color_green   equ 2
  color_cyan    equ 3
  color_red     equ 4
  color_magenta equ 5
  color_brown   equ 6
  color_white   equ 7

  str_hello     db  "hello world", 0
  str_hello_len equ $ - str_hello - 1

  myname     db  "Naboishchikov A. A.", 0
  myname_len equ $ - myname - 1

  poet           db  "Nekrasov N. A.", 0
  poet_verse_1   db  "O muza! nasha pesnya speta.", 0
  poet_verse_len equ $ - poet_verse_1 - 1
  poet_verse_2   db  "Pridi, zakroj glaza poeta", 0
  poet_verse_3   db  "Na vechnyj son nebytiya,", 0
  poet_verse_4   db  "Sestra naroda - i moya!", 0

  center_x equ 80 / 2
  center_y equ 24 / 2

%macro exit 0
  mov ah, 4ch
  mov al, 00h
  int 21h
%endmacro

; @param  1 - x
;         2 - y
%macro move_cursor 2
  pusha
  mov  dl, %1
  mov  dh, %2
  call mut_move_cursor_call
  popa
%endmacro

; @param  1 - x
;         2 - y
;         3 - width
;         4 - height
;         5 - bg color: 000b - 111b
;         6 - text color: 000b - 111b
%macro print_rect 6
  pusha
  mov  ah, %1
  mov  al, %2
  mov  cx, %3
  mov  dh, %4
  mov  bh, %5
  mov  bl, %6
  call print_rect_call
  popa
%endmacro

; @param  1 - string address
;         2 - x
;         3 - y
%macro print_string 3
  pusha
  mov  si, %1
  mov  ah, %2
  mov  al, %3
  call print_string_call
  popa
%endmacro

; @param  1 - bg color: 000b - 111b
;         2 - text color: 000b - 111b
; @return bl - full color
%macro mut_bl_set_color 2
  push ax
  mov  ah, bh
  mov  bh, %1
  mov  bl, %2
  call mut_bl_set_color_call
  mov  bh, ah
  pop  ax
%endmacro

; @param  1 - x
;         2 - y
;         3 - width
;         4 - height
;         5 - bg color 000b - 111b
;         6 - text color 000b - 111b
%macro print_border 6
  pusha
  mov  ah, %1
  mov  al, %2
  mov  cx, %3
  mov  dh, %4
  mov  bh, %5
  mov  bl, %6
  call print_border_call
  popa
%endmacro

; @param  1 - string address
;         2 - string length
;         3 - x
;         4 - y
;         5 - bg color
;         6 - text color
%macro print_string_with_border 6
  pusha
  mov  si, %1
  mov  cx, %2
  mov  ah, %3
  mov  al, %4
  mov  bh, %5
  mov  bl, %6
  call print_string_with_border_call
  popa
%endmacro

; @param  1 - x
;         2 - y
;         3 - bg color: 000b - 111b
;         4 - text color: 000b - 111b
%macro print_hello_with_border 4
  print_string_with_border str_hello, str_hello_len, %1, %2, %3, %4
%endmacro

%macro print_myname_with_border 4
  print_string_with_border myname, myname_len, %1, %2, %3, %4
%endmacro


; @param  1 - x
;         2 - y
;         3 - bg color: 000b - 111b
;         4 - text color: 000b - 111b
%macro print_poet_verse 4
  pusha
  mov  ah, %1
  mov  al, %2
  mov  bh, %3
  mov  bl, %4
  call print_poet_verse_call
  popa
%endmacro

section .text
global  _start
_start:
  call init_registers
  call init_video
  rdtsc

  task0:
    move_cursor 1, 1

  task1:
    print_rect 20, 15, 3, 4, color_white, color_black

  task2:
    print_hello_with_border 0, 11, color_white, color_black

  task3:
    print_border 20, 11, 10, 3, color_white, color_blue

  task4:
    print_myname_with_border 0, 20, color_brown, color_black

  task5:
    print_poet_verse 1, 1, color_white, color_cyan

  ; print_maze:
  ;   pusha
  ;   mov ah, center_x - 20 / 2
  ;   mov al, center_y - 20 / 2
  ;   print_rect ah, al, 20, 20, 010b, 111b

  ;   print_maze_x_loop:
  ;     push ax

  ;     print_maze_y_loop:
  ;       push ax

  ;       mov ah, 00h
  ;       int 1ah
  ;       pop ax


  ;       and dl, 1
  ;       ; mov dl, 1
  ;       cmp dl, 0
  ;       jz print_maze_not_print_grid
  ;         print_rect ah, al, 1, 1, 110b, 001b
  ;       print_maze_not_print_grid:

  ;       inc al
  ;       cmp al, center_y + 20 / 2
  ;       jnz print_maze_y_loop

  ;     pop ax

  ;     inc ah
  ;     cmp ah, center_x + 20 / 2
  ;     jnz print_maze_x_loop

  ;   popa
  exit


init_registers:
  mov ax, 0
  mov bx, 0
  mov cx, 0
  mov dx, 0
  ret

init_video:
  pusha
  mov ah, 00h
  mov al, video_mode
  int 10h
  popa
  ret

; @param  dl - x
;         dh - y
mut_move_cursor_call:
  mov ah, 02h
  mov bh, 0
  int 10h
  ret

print_char:
  pusha
  mov ah, 0
  mov bh, 0
  ; mov al, [char]
  int 10h
  popa
  ret

; @param  si - string address
;         ah - x
;         al - y
print_string_call:
  pusha
  mov         cx, ax
  move_cursor ch, cl
  mov         ah, 0eh
  mov         bh, 0
  mov         al, [si]
  print_string_call_char:
    int 10h
    inc si
    mov al, [si]

    cmp         al, 10                   ; is \n
    jnz         print_string_call_is_end
    inc         cl
    move_cursor ch, cl

    print_string_call_is_end:
    cmp al, 0                  ; is end
    jnz print_string_call_char
  popa
  ret

; @param  ah - x
;         al - y
;         cx - width
;         dh - height
;         bh - bg color 000b - 111b
;         bl - text color 000b - 111b
print_rect_call:
  pusha
  move_cursor ah, al

  push ax
  print_rect_call_row:
    mov              ah, 09h
    mov              al, ' '
    mut_bl_set_color bh, bl
    mov              bh, 0
    int              10h

    dec         dh
    pop         ax
    inc         al
    move_cursor ah, al
    push        ax
    cmp         dh, 0
  jnz print_rect_call_row
  pop ax

  popa
  ret


; @param  bh - bg color 000b - 111b
;         bl - text color 000b - 111b
; @return bl - full color
mut_bl_set_color_call:
  push dx
  mov  dx, 0
  mov  dl, bh
  shl  dl, 4
  add  dl, bl
  ; mov bh, 0
  mov  bl, dl
  pop  dx
  ret


; @param  ah - x
;         al - y
;         cx - width
;         dh - height
;         bh - bg color 000b - 111b
;         bl - text color 000b - 111b
print_border_call:
  pusha

  move_cursor      ah, al
  pusha
  mov              ah, 09h
  mov              al, border_horisontal
  mut_bl_set_color bh, bl
  mov              bh, 0
  int              10h
  popa

  pusha
  mov              ah, 09h
  mov              al, border_top_left_angle
  mut_bl_set_color bh, bl
  mov              bh, 0
  mov              cx, 1
  int              10h
  popa

  pusha
  add         ah, cl
  dec         ah
  move_cursor ah, al
  popa

  pusha
  mov              ah, 09h
  mov              al, border_top_right_angle
  mut_bl_set_color bh, bl
  mov              bh, 0
  mov              cx, 1
  int              10h
  popa


  pusha
  add         al, dh
  dec         al
  move_cursor ah, al
  popa

  pusha
  mov              ah, 09h
  mov              al, border_horisontal
  mut_bl_set_color bh, bl
  mov              bh, 0
  int              10h
  popa

  pusha
  mov              ah, 09h
  mov              al, border_bottom_left_angle
  mut_bl_set_color bh, bl
  mov              bh, 0
  mov              cx, 1
  int              10h
  popa

  pusha
  add         al, dh
  dec         al
  add         ah, cl
  dec         ah
  move_cursor ah, al
  popa

  pusha
  mov              ah, 09h
  mov              al, border_bottom_right_angle
  mut_bl_set_color bh, bl
  mov              bh, 0
  mov              cx, 1
  int              10h
  popa

  pusha
  inc         al
  sub         dh, 2
  move_cursor ah, al
  print_border_call_vert_loop:
    pusha
    mov              ah, 09h
    mov              al, border_vertical
    mut_bl_set_color bh, bl
    mov              bh, 0
    mov              cx, 1
    int              10h
    popa

    pusha
    add         ah, cl
    dec         ah
    move_cursor ah, al
    popa

    pusha
    mov              ah, 09h
    mov              al, border_vertical
    mut_bl_set_color bh, bl
    mov              bh, 0
    mov              cx, 1
    int              10h
    popa

    inc         al
    move_cursor ah, al
    dec         dh
    cmp         dh, 0
    jnz         print_border_call_vert_loop
  popa

  popa
  ret


; @param  si - string address
;         cx - string length
;         ah - x
;         al - y
;         bh - bg color
;         bl - text color
print_string_with_border_call:
  pusha
  add cl, 4
  print_rect ah, al, cx, 5, bh, bl
  print_border ah, al, cx, 5, bh, bl
  add ah, 2
  add al, 2
  print_string si, ah, al
  popa
  ret

; @param  ah - x
;         al - y
;         bh - bg color: 000b - 111b
;         bl - text color: 000b - 111b
print_poet_verse_call:
  pusha
  print_rect ah, al, poet_verse_len + 4, 8, bh, bl
  print_border ah, al, poet_verse_len + 4, 8, bh, bl

  add ah, 9
  print_string poet, ah, al
  sub ah, 9

  add ah, 2
  add al, 2
  print_string poet_verse_1, ah, al
  inc al
  print_string poet_verse_2, ah, al
  inc al
  print_string poet_verse_3, ah, al
  inc al
  print_string poet_verse_4, ah, al
  popa
  ret
