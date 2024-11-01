    .data
array:  .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10  # Array of 10 elements
msg:    .asciiz "The difference between element 4 and 6 is: "

    .text
    .globl main
main:
    # Load the 4th element (index 3, since the array is 0-based)
    la $t0, array          # Load the base address of the array
    lw $t1, 12($t0)        # Load the value of the 4th element (4 bytes per element, index 3 = 3 * 4 = 12 bytes)

    # Load the 6th element (index 5)
    lw $t2, 20($t0)        # Load the value of the 6th element (index 5 = 5 * 4 = 20 bytes)

    # Calculate the difference: element 4 - element 6
    sub $t3, $t1, $t2      # $t3 = element 4 - element 6

    # Print the message
    li $v0, 4              # syscall to print string
    la $a0, msg            # Load the message address
    syscall

    # Print the result
    li $v0, 1              # syscall to print an integer
    move $a0, $t3          # Move the result (difference) to $a0
    syscall

    # Exit the program
    li $v0, 10             # syscall to exit
    syscall
