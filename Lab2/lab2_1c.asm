    .data
prompt: .asciiz "Enter a 10-character string: "
buffer: .space 11            # buffer to store the string (10 chars + null terminator)

    .text
    .globl main
main:
    # Prompt for input
    li $v0, 4               # syscall for printing a string
    la $a0, prompt          # load the prompt message
    syscall

    # Read the string (limit input to 10 characters)
    li $v0, 8               # syscall for reading a string
    la $a0, buffer          # load the buffer address
    li $a1, 11              # max length to read (10 chars + null terminator)
    syscall

    # Print the string back
    li $v0, 4               # syscall for printing a string
    la $a0, buffer          # load the buffer address
    syscall

    # Exit program
    li $v0, 10
    syscall
