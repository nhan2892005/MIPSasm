    .data
prompt_a:    .asciiz "Enter the coefficient a: "
prompt_b:    .asciiz "\nEnter the coefficient b: "
prompt_c:    .asciiz "\nEnter the coefficient c: "
prompt_d:    .asciiz "\nEnter the coefficient d: "
prompt_x:    .asciiz "\nEnter the value of x: "
result_msg:  .asciiz "\nThe result of the expression is: "

    .text
    .globl main
main:
    # Read inputs for a, b, c, d, and x

    # Prompt for a
    li $v0, 4               # syscall to print string
    la $a0, prompt_a         # load the prompt for 'a'
    syscall

    li $v0, 5               # syscall to read an integer
    syscall
    move $t0, $v0           # store the value of a in $t0

    # Prompt for b
    li $v0, 4
    la $a0, prompt_b
    syscall

    li $v0, 5
    syscall
    move $t1, $v0           # store the value of b in $t1

    # Prompt for c
    li $v0, 4
    la $a0, prompt_c
    syscall

    li $v0, 5
    syscall
    move $t2, $v0           # store the value of c in $t2

    # Prompt for d
    li $v0, 4
    la $a0, prompt_d
    syscall

    li $v0, 5
    syscall
    move $t3, $v0           # store the value of d in $t3

    # Prompt for x
    li $v0, 4
    la $a0, prompt_x
    syscall

    li $v0, 5
    syscall
    move $t4, $v0           # store the value of x in $t4

    # Horner's method:
    # f(x) = ((a * x + b) * x - c) * x - d

    # t = a * x
    mul $t5, $t0, $t4       # t5 = a * x

    # t = t + b -> t = a * x + b
    add $t5, $t5, $t1       # t5 = a * x + b

    # t = t * x -> t = (a * x + b) * x
    mul $t5, $t5, $t4       # t5 = (a * x + b) * x

    # t = t - c -> t = (a * x^2 + b * x) - c
    sub $t5, $t5, $t2       # t5 = (a * x^2 + b * x) - c

    # t = t * x -> t = ((a * x^2 + b * x - c) * x)
    mul $t5, $t5, $t4       # t5 = ((a * x^2 + b * x - c) * x)

    # t = t - d -> t = (a * x^3 + b * x^2 - c * x) - d
    sub $s0, $t5, $t3       # $s0 = (a * x^3 + b * x^2 - c * x) - d

    # Print the result
    li $v0, 4               # syscall to print string
    la $a0, result_msg      # load the result message
    syscall

    li $v0, 1               # syscall to print an integer
    move $a0, $s0           # move the result from $s0 to $a0
    syscall

    # Exit program
    li $v0, 10
    syscall
