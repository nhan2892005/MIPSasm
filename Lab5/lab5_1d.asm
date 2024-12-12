.data
    memory: .word 0x00800000, 0x00800001, 0x00800002  # Input values in IEEE 754
    num_elements: .word 3                             # Number of elements in the array
    newline: .asciiz "\n"                             # Newline character for formatting

.text
.globl main

main:
    la $t0, memory           # Load the starting address of the array
    lw $t1, num_elements     # Load the number of elements

loop:
    li $v0, 2                # Set syscall for printing float
    lw $t2, 0($t0)           # Load the current element
    mtc1 $t2, $f12           # Move it to floating-point register
    syscall                  # Print the floating-point value
    
    li $v0, 4                # Set syscall for printing string
    la $a0, newline          # Load newline address
    syscall                  # Print newline

    addi $t0, $t0, 4         # Move to the next element
    subi $t1, $t1, 1         # Decrease element count
    bgtz $t1, loop           # Repeat if more elements remain

    li $v0, 10               # Exit program
    syscall
