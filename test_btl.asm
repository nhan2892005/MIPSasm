.data
    array: .word 3, 5, 7, 10 , 12, 14, 15, 13, 1, 2, 9, 6, 4, 8, 11, 16, 17, 18, 45, 19, 23, 25, 30, 21, 34, 20, 22, 26, 24, 36, 37, 27, 31, 28, 44, 29, 40, 32, 42, 33, 35, 41, 38, 39, 50, 47, 49, 46, 48, 43 
    size: .word 50               # Size of the array
    step_msg: .asciiz "\nStep "   # Step message for each sorting step
    colon: .asciiz ": "           # Colon for display
    space: .asciiz " "            # Space between numbers in display
    newline: .asciiz "\n"         # Newline for formatting
    initial_msg: .asciiz "Initial array: " # Message before displaying initial array
    final_msg: .asciiz "\nFinal sorted array: " # Message before displaying sorted array
    step_counter: .word 1         # Counter for tracking sort steps

.text
.globl main

main:
    # Print initial array message
    li $v0, 4
    la $a0, initial_msg
    syscall
    
    # Print initial array elements
    la $a0, array
    jal print_array
    
    # Initialize quicksort with left and right bounds
    la $a0, array        # Array base address
    li $a1, 0            # Left boundary
    lw $a2, size         # Array size as right boundary
    addi $a2, $a2, -1    # Adjust right boundary to size - 1
    jal quicksort
    
    # Print final array message
    li $v0, 4
    la $a0, final_msg
    syscall
    
    # Print final sorted array
    la $a0, array
    jal print_array
    
    # Exit program
    li $v0, 10
    syscall

print_step:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Print "Step " message
    li $v0, 4
    la $a0, step_msg
    syscall
    
    # Print step counter
    li $v0, 1
    lw $a0, step_counter
    syscall
    
    # Print colon ": "
    li $v0, 4
    la $a0, colon
    syscall
    
    # Print array state after each partition step
    la $a0, array
    jal print_array
    
    # Increment step counter
    lw $t0, step_counter
    addi $t0, $t0, 1
    sw $t0, step_counter
    
    # Restore return address
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Quick Sort Function
# Params: $a0 = base address of array
#         $a1 = left boundary (low)
#         $a2 = right boundary (high)
quicksort:
    bge $a1, $a2, return           # If left >= right, return
    
    # Save parameters and return address on stack
    addi $sp, $sp, -16		     
    sw $ra, 12($sp)		# Return address
    sw $a1, 8($sp)         # Left boundary
    sw $a2, 4($sp)         # Right boundary
    sw $a0, 0($sp)         # Array base address
    
    # Partition the array and get pivot index in $v0
    jal partition
    move $s0, $v0              # Store pivot index in $s0
    
    # Recursive quicksort on left side of pivot
    lw $a0, 0($sp)		# Load array base address
    lw $a1, 8($sp)		# Load left boundary
    move $a2, $s0		# Set high to pivot - 1
    addi $a2, $a2, -1      
    jal quicksort
    
    # Recursive quicksort on right side of pivot
    lw $a0, 0($sp)	        # Load array base address
    move $a1, $s0		# Set left to pivot + 1
    addi $a1, $a1, 1		
    lw $a2, 4($sp)		# Load right boundary
    jal quicksort
    
    # Restore stack and return address
    lw $ra, 12($sp)
    addi $sp, $sp, 16
return:
    jr $ra
    
# Partition Function
# Params: $a0 = base address of array
#         $a1 = left boundary (low)
#         $a2 = right boundary (high)
partition:
    # Set pivot as array[high]
    sll $t0, $a2, 2	        # Calculate high index offset
    add $t0, $a0, $t0          # Get address of array[high]
    lw $t1, ($t0)              # Store pivot value in $t1
    
    # Initialize i = low - 1
    addi $t2, $a1, -1
    
    # Loop through array from low to high - 1
    move $t3, $a1              # Initialize j = low
partition_loop:
        bge $t3, $a2, partition_end     # If j >= high, exit loop
        
        # Calculate address of array[j]
        sll $t4, $t3, 2                 # Offset for j
        add $t4, $a0, $t4               # Get address at index j
        lw $t5, ($t4)                   # Load value at array[j]
        
        # If array[j] < pivot, increment i and swap array[i] and array[j]
        bgt $t5, $t1, skip_swap 
        addi $t2, $t2, 1                 # Increment i
        sll $t6, $t2, 2                  # Offset for i
        add $t6, $a0, $t6                # Get address at index i
        lw $t7, ($t6)                    # Load value at array[i]
        
        # Swap array[i] and array[j]
        sw $t5, ($t6)                    # Store value of array[j] in array[i]
        sw $t7, ($t4)                    # Store value of array[i] in array[j]
    
skip_swap:
	# Increment j and continue loop
    addi $t3, $t3, 1
    j partition_loop
    
partition_end:
    # Place pivot in its sorted location
    addi $t2, $t2, 1             # Increment i
    sll $t6, $t2, 2              # Offset for i + 1
    add $t6, $a0, $t6            # Address for array[i + 1]
    lw $t7, ($t6)                # Store value at array[i + 1]
    sw $t1, ($t6)                # Place pivot in array[i + 1]
    sw $t7, ($t0)                # Replace array[high] with array[i + 1]
    
    # Print the array's current state for each step
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal print_step
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    
    # Return pivot index (i + 1)
    move $v0, $t2
    jr $ra

# Function to print the array
print_array:
    move $t8, $a0               # Base address of the array
    li $t9, 0                   # Counter for printing elements
    
print_loop:
    lw $t7, size                # Load array size
    beq $t9, $t7, print_end     # Stop if all elements printed
    
    sll $t7, $t9, 2             # Calculate address offset for array[t9]
    add $t7, $t8, $t7           # Address of current element
    lw $a0, ($t7)               # Load current element
    li $v0, 1                   # Print integer syscall
    syscall
    
    # Print space between numbers
    li $v0, 4
    la $a0, space
    syscall
    
    # Increment element counter
    addi $t9, $t9, 1
    j print_loop

print_end:
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall
    jr $ra
