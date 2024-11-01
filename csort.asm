.data
array: .word 5, 2, 1, 4, 3
array_len: .word 5
newline:    .asciiz "\n"

.text
.globl main

main:
    
    la   $a0, array
    lw   $a1, array_len		
    jal  sort
    jal  print_array 

    li   $v0, 10
    syscall
    
sort:   # Move paramaters
	add 	$sp, $sp, -20
	sw 	$ra, 16($sp)
	sw 	$s3, 12($sp)
	sw 	$s2, 8($sp)
	sw 	$s1, 4($sp)
	sw 	$s0, 0($sp)
	move 	$s2, $a0
	move 	$s3, $a1
	
	# Outer Loop
	move $s0, $zero
	for1:   # Check valid index in range
		slt $t0, $s0, $s3			# i < n
		beq $t0, $zero, ExitLoop1		# False -> out
		# Second Loop
		addi $s1, $s0, -1
		for2:   # Check valid in range
			slti 	$t0, $s1, 0		# j < 0?
			bne 	$t0, $zero, ExitLoop2	# True -> out
			
			sll 	$t1, $s1, 2
			add 	$t2, $s2, $t1		# Get adress A[j]
			lw 	$t3, 0($t2)		# Get value A[j]
			lw 	$t4, 4($t2)		# Get value A[j + 1]
			slt 	$t0, $t4, $t3		# Check A[j + 1] < A[j]
			
			beq 	$t0, $zero, ExitLoop2
			
			# call swap
			move $a0, $s2
			move $a1, $s1
			jal swap
			
			addi $s1, $s1, -1 		# Decreasing j index
			j for2
		ExitLoop2: addi $s0, $s0, 1		# Increasing i index
			   j for1
	ExitLoop1: move $a1, $s3
		   lw $s0, 0($sp)
		   lw $s1, 4($sp)
		   lw $s2, 8($sp)
		   lw $s3, 12($sp)
		   lw $ra, 16($sp)
		   addi $sp, $sp, 20
		   jr $ra

swap:   sll $t1, $a1, 2
	add $t1, $a0, $t1

	lw $t0, 0($t1)
	lw $t2, 4($t1)

	sw $t0, 4($t1)
	sw $t2, 0($t1)
	
	jr $ra
	
print_array:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)
    move $s0, $a0
    li   $t0, 0                      
print_loop:
    slt  $t4, $t0, $a1
    beq  $t4, $zero, print_done        
    sll  $t1, $t0, 2                 
    add  $t2, $s0, $t1               
    lw   $t3, 0($t2)                 

    li   $v0, 1                      
    move $a0, $t3                    
    syscall

    li   $v0, 4                      
    la   $a0, newline                
    syscall

    addi $t0, $t0, 1                 
    j    print_loop                  

print_done:
    move $a0, $s0
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr   $ra                         

