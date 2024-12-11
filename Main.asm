section .data
    msg db "A DUNGEON GAME ABOUT CAVES",10,"MADE BY NORTH004 :)",10,10,0
    msg1 db "YOU ARE A KNIGHT WITH",10,10,"HEALTH: 10",10,"STAMMINA: 10",10,"MAGIC: 10",10,0
section .bss
    string resb 8
    
section .text
    global _start


; print_number
; parameter rdi: A decimal number less than length 8
; return junk

; print_string
; parameter rdi: A string of printable ascii bytes
; return junk

_start:
  mov rdi, msg
  call print_string
  mov rdi, msg1
  call print_string
  jmp exit

print_number:
   mov r10, rdi  ;move number to be stringed to reg
   mov r11, 0 ; move 0 into r11
   mov rax, r10 ; move into acc
   mov rbx, 10
   jmp start_loop
   
   
start_loop: ; start loop
  xor rdx, rdx ; set rdx top bits to 0
  div rbx ; divide rax by 10 so rax holds quoitent and rdx holds remainder
  add dl, '0'
  mov byte [string + r11], dl ; load remainder jnto string
  inc r11 ;increment r11
  cmp rax, 0 ; set zero flag if rax 0
  jnz start_loop
  mov byte [string + 11], 0
  ; at this point we have the number in reverse and null terminated
  
  mov rdi, 0
  mov rsi, r11
  dec rsi 
  jmp reverse_loop
  
reverse_loop:
  cmp rdi, rsi
  jge done_reverse
  mov al, [string + rsi]
  mov bl, [string + rdi]
  mov [string + rdi], al
  mov [string + rsi], bl
  inc rdi
  dec rsi
  jmp reverse_loop
  
  
  
done_reverse:
  mov rax, 1
  mov rdi, 1
  mov rsi, string
  mov rdx, r11
  syscall
  ret

   
strlen:
    xor rax, rax
    jmp loop

loop:
   mov dl, byte [rdi]
   test dl, dl
   jz found_null
   inc rdi
   inc rax
   jmp loop

found_null:
    ret
    
print_string:
    mov rsi, rdi
    call strlen
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    syscall
    ret

exit:
   mov rax, 60
   xor rdi, rdi
   syscall 
  
  
  
  
  
  
  
  
