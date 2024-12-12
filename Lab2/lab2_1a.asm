.data
prompt1:    .asciiz "Enter the first integer: "
prompt2:    .asciiz "\nEnter the second integer: "
prompt3:    .asciiz "\nEnter the third integer: "
result_msg: .asciiz "\nThe result of (a - b) - c is: "

    .text
    .globl main
main:
    # Prompt for first integer a
    li $v0, 4              # syscall for printing a string
    la $a0, prompt1         # load the first prompt
    syscall

    li $v0, 5              # syscall for reading an integer
    syscall
    move $t0, $v0          # store the value of a in $t0

    # Prompt for second integer b
    li $v0, 4
    la $a0, prompt2
    syscall

    li $v0, 5
    syscall
    move $t1, $v0          # store the value of b in $t1

    # Prompt for third integer c
    li $v0, 4
    la $a0, prompt3
    syscall

    li $v0, 5
    syscall
    move $t2, $v0          # store the value of c in $t2

    # Calculate f(a,b,c) = (a - b) - c
    sub $t3, $t0, $t1      # t3 = a - b
    sub $t3, $t3, $t2      # t3 = (a - b) - c

    # Print the result
    li $v0, 4
    la $a0, result_msg
    syscall

    li $v0, 1              # syscall to print an integer
    move $a0, $t3          # move the result to $a0
    syscall

    # Exit program
    li $v0, 10
    syscall
