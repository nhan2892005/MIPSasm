.data
prompt_a: .asciiz "Nhap a: "
prompt_b: .asciiz "Nhap b: "
prompt_c: .asciiz "Nhap c: "
result_msg: .asciiz "Ket qua f(a,b,c) = a - b + c la: "

.text
.globl main

main:
    # Enter a
    li $v0, 4          # Load syscall code for print string
    la $a0, prompt_a   # Load address of the prompt for a
    syscall             # Make the syscall

    li $v0, 5          # Load syscall code for read integer
    syscall             # Make the syscall
    move $t0, $v0      # Move value a into $t0

    # Enter b
    li $v0, 4          # Load syscall code for print string
    la $a0, prompt_b   # Load address of the prompt for b
    syscall             # Make the syscall

    li $v0, 5          # Load syscall code for read integer
    syscall             # Make the syscall
    move $t1, $v0      # Move value b into $t1

    # Enter c
    li $v0, 4          # Load syscall code for print string
    la $a0, prompt_c   # Load address of the prompt for c
    syscall             # Make the syscall

    li $v0, 5          # Load syscall code for read integer
    syscall             # Make the syscall
    move $t2, $v0      # Move value c into $t2

    # Calculate f(a,b,c) = a - b + c
    sub $t3, $t0, $t1  # $t3 = a - b
    add $t3, $t3, $t2  # $t3 = (a - b) + c

    # Print output
    li $v0, 4          # Load syscall code for print string
    la $a0, result_msg # Load address of the result message
    syscall             # Make the syscall

    li $v0, 1          # Load syscall code for print integer
    move $a0, $t3      # Move the result into $a0
    syscall             # Make the syscall

    # Exit program
    li $v0, 10         # Load syscall code for exit
    syscall             # Make the syscall
