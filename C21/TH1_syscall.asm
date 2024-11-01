.data
message: .asciiz "Kien Truc May Tinh 2024.\n"

.text
.globl main

main:
    # Syscall to print string
    li $v0, 4          # Load syscall code for print string
    la $a0, message    # Load address of the string
    syscall             # Make the syscall

    # Exit program
    li $v0, 10         # Load syscall code for exit
    syscall             # Make the syscall
