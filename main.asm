.section .data
banner:  .asciz "A text adventure game made by nm\n" 
p1: .asciz "Your finally awake... \n"
.section .bss 
name: .skip 128

.section .text
    .globl _start
    .globl write
    .global printstr
    .globl getstr
    .globl strlen

write: 
    mov $1, %rax
    mov $1, %rdi
    syscall
    ret

getstr: 
     mov $0, %rax
     mov $0, %rdi
     syscall 
     ret

strlen:
    xor %rax, %rax        # Clear %rax to store the length
.loop:
    movb (%rdi), %cl      # Load byte from the string into %al
    test %cl, %cl         # Test if it's the null terminator (0)
    jz .done              # If null terminator, we are done
    inc %rdi              # Move to the next byte in the string
    inc %rax              # Increment the length counter
    jmp .loop             # Repeat the loop
.done:
    ret                   # Return the length in %rax

printstr:
    mov %rsi,  %rdi 
    call strlen 
    mov %rax, %rdx 
    call write
    ret

end:
    mov $60, %rax
    xor %rdi, %rdi
    syscall

_start:
    lea banner(%rip), %rsi
    call printstr

    lea p1(%rip), %rsi
    call printstr

    call end
    



