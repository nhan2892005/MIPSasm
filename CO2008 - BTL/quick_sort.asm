.data
    txt1:   .asciiz "Initial array: "
    txt2:   .asciiz "After patition: "
    step_msg: .asciiz "Step " 
    colon: .asciiz ":         "   
    space: .asciiz " "           
    newline: .asciiz "\n"     
    step_counter: .word 1  
    size: .word 50
    array:  .word -9, 38, -40, -73, 92, 5, 26, 34, 81, 15
.word -14, 82, -38, 3, -79, -72, -20, -57, -5, 88
.word 49, -83, -56, 60, 6, -76, 21, -17, 50, 46
.word -19, 6, 2, -5, -68, 31, 38, 63, 1, -18
.word 40, 85, 37, 58, 15, 3, 89, -87, -38, 87

.text
.globl main

main:
    li $v0, 4
    la $a0, txt1
    syscall

    la $a0, array
    li $a1, 0
    lw $a2, size

    jal print_array

    li $v0, 4
    la $a0, newline
    syscall

    la $a0, array # array
    addi $a2, $a2, -1 # high = size - 1
    jal quicksort # quickSort(array, 0, size - 1);

    li $v0, 10
    syscall

quicksort:
    bge $a1, $a2, return # if (low >= high) kết thúc
	
    addi $sp, $sp, -16
    sw $ra, 12($sp)
    sw $a1, 8($sp) # low
    sw $a2, 4($sp) # high
    sw $a0, 0($sp) # array

    jal partition # partition(array, low, high);
    move $t0, $v0 # int pivot = partition(array, low, high);

    lw $a0, 0($sp) 
    lw $a1, 8($sp)
    
    move $a2, $t0 # $a2 = pivot
    addi $a2, $a2, -1 # $a2 = pivot - 1
    jal quicksort # quickSort(array, low, pi - 1);
    
    lw $a0, 0($sp)

    move $a1, $t0 # $a1 = pivot
    addi $a1, $a1, 1 # $a1 = pivot + 1
    lw $a2, 4($sp) # $a2 = high
    jal quicksort # quickSort(array, pi + 1, high);
    lw $ra, 12($sp)
    addi $sp, $sp, 16

    return:
        jr $ra

partition:
    sll  $t0, $a2, 2 # Tính toán offset của high
    add  $t0, $a0, $t0  # Địa chỉ của array[high]
    lw $t1, 0($t0) # int pivot = array[high];

    addi $t2, $a1, -1 # int i = (low - 1);
    
    # for (int k = low; k < high; k++)
    move $t3, $a1 # int k = low
    partition_loop:
        bge $t3, $a2, partition_end

        sll $t4, $t3, 2 # Tính toán offset của k
        add $t4, $a0, $t4 # Địa chỉ của array[k]
        lw $t5, 0($t4)

        bgt $t5, $t1, skip_swap 
        addi $t2, $t2, 1 # i++;
        sll $t6, $t2, 2
        add $t6, $a0, $t6
        lw $t7, 0($t6)
        sw $t5, 0($t6)
        sw $t7, 0($t4)
    skip_swap:
        addi $t3, $t3, 1
        j partition_loop
    partition_end:
        addi $t2, $t2, 1
        sll $t6, $t2, 2
        add $t6, $a0, $t6
        lw $t7, ($t6)
        sw $t1, ($t6)
        sw $t7, ($t0)
        
        addi $sp, $sp, -4
        sw $ra, 0($sp)
        jal print_step
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        
        move $v0, $t2
        jr $ra

print_array:
    move $t8, $a0
    move $t9, $a1
print_loop:
    move $t7, $a2
    beq $t9, $t7, print_end
    sll $t7, $t9, 2
    add $t7, $t8, $t7
    lw $a0, ($t7)
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, space
    syscall
    addi $t9, $t9, 1
    j print_loop
print_end:
    li $v0, 4
    la $a0, newline
    syscall
    jr $ra

print_step:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    li $v0, 4
    la $a0, txt2
    syscall
    la $a0, array
    addi $a2, $a2, 1
    jal print_array
    li $v0, 4
    la $a0, step_msg
    syscall
    li $v0, 1
    lw $a0, step_counter
    syscall
    li $v0, 4
    la $a0, colon
    syscall
    la $a0, array
    li $a1, 0
    lw $a2, size
    jal print_array
    lw $t0, step_counter
    addi $t0, $t0, 1
    sw $t0, step_counter
    li $v0, 4
    la $a0, newline
    syscall
    la $a0, array
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
