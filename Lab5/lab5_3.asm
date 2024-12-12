.data
    array: .float 3.5, 2.1, -7.8, 1.4, -9.0, 5.6, 8.3, 4.2, -6.9, 0.7  
    prompt_min: .asciiz "Min Value: "                           
    prompt_max: .asciiz "\nMax Value: "                         
.text
    .globl main

main:
    la $t0, array          # Load address of array into $t0
    l.s $f0, 0($t0)        # Load first value of array into $f0 (min)
    l.s $f2, 0($t0)        # Load first value of array into $f2 (max)

    li $t1, 1              # Start loop from the second element (index 1)

loop:
    li $t2, 10             # Check if we've iterated over 10 elements
    bge $t1, $t2, print_results  # Exit loop if all elements are processed

    l.s $f4, 0($t0)        # Load next value of array into $f4
    addi $t0, $t0, 4       # Increment array address (4 bytes per float)

    c.lt.s $f4, $f0        # Compare $f4 with current min in $f0
    bc1f skip_min          # If $f4 is not less than $f0, skip updating min
    mov.s $f0, $f4         # Update min with $f4

skip_min:
    c.lt.s $f2, $f4        # Compare $f2 with current max in $f2
    bc1f skip_max          # If $f2 is not less than $f4, skip updating max
    mov.s $f2, $f4         # Update max with $f4

skip_max:
    addi $t1, $t1, 1       # Move to the next element in the array
    j loop                 # Repeat the loop

print_results:
    li $v0, 4              # System call to print string
    la $a0, prompt_min     # Load address of min prompt
    syscall

    li $v0, 2              # System call to print float
    mov.s $f12, $f0        # Load min value into $f12 for printing
    syscall

    li $v0, 4              # System call to print string
    la $a0, prompt_max     # Load address of max prompt
    syscall

    li $v0, 2              # System call to print float
    mov.s $f12, $f2        # Load max value into $f12 for printing
    syscall

    li $v0, 10             # System call to exit program
    syscall
