    .data
msg:    .asciiz "Kien Truc May Tinh 2022\n"

    .text
    .globl main
main:
    li $v0, 4              # syscall for printing a string
    la $a0, msg            # load the address of the message
    syscall

    # Exit program
    li $v0, 10
    syscall
