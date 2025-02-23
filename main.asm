.section .data
banner:  .asciz "A text adventure game made by nm\n" 
p1: .asciz "Your finally awake... \n"
h1: .asciz "Your health is: "

newline: .asciz "\n"

.section .bss 
name: .skip 128
buffer: .skip 128 

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

# 1 Arg %RDI stores the pointer to string
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



# 1 Arg %RDI: 64 bit int
numbertostr:
    mov %rdi, %rax # rdx:rax is the divide
    xor %rdx, %rdx
    mov $10, %rcx
    mov $0, %rdi
    lea buffer(%rip), %rsi  # %rsi is now buffer[0]
.start_loop:
    div %rcx  # this divides rax by rcx ( 10 ) and stores the remainder:quotient in rdx:rax
    add $48, %dl  # dl is lower 8 bits of rdx so we add 48 to make ascii
    movb %dl, (%rsi,%rdi)   # so now rsi  and rdx is a sum into rax wich should be 0 so buffer[0 + rdi] = dl 
    test %rax, %rax
    jz .finished 
    inc %rdi
    xor %rdx, %rdx
    jmp .start_loop
.finished:
    ## it works up to this  point we just need to swap the chars around so 321 becomes 123 and 1234 becomes 4321
    lea buffer(%rip), %rdi
    call strlen
    dec %rax
    mov $0, %rsi
    lea buffer(%rip), %rdx
.start_swap_loop:
    cmp  %rax, %rsi
    jge .done_swap
    movb (%rdx,%rsi), %cl
    movb (%rdx,%rax), %bl
    movb %bl, (%rdx,%rsi)
    movb %cl, (%rdx,%rax)
    inc %rsi
    dec %rax
    jmp .start_swap_loop

.done_swap:
    ret


end:
    mov $60, %rax
    xor %rdi, %rdi
    syscall

_start:
    mov $100, %r8

    lea banner(%rip), %rsi
    call printstr

    lea p1(%rip), %rsi
    call printstr

    lea h1(%rip), %rsi
    call printstr

    mov %r8, %rdi
    call numbertostr 
    lea buffer(%rip), %rsi 
    call printstr

    lea newline(%rip), %rsi
    call printstr

    call end
    



