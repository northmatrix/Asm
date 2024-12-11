section .bss
    string resb 10
    
section .text
    global _start

_start:
  mov r10, 3141592653589 ;move number to be stringed to reg
  mov r11, 0 ; move 0 into r11
  mov rax, r10 ; move into acc
  mov rbx, 10
  
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
  jmp exit

exit:
   mov rax, 60
   xor rdi, rdi
   syscall 
  
  
  
  
  
  
  
  
