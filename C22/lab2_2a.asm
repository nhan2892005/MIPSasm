.data
.text
.globl main

main:
    # Load 200000
    lui $t0, 3               # Load 3 into 16-high-bits $t0 (200000 = 3 * 65536 + 34464)
    ori $t0, $t0, 3392     # Load remain into $t0

    # Load 4000, 700
    li $t1, 4000            
    li $t2, 700            

    # Calculate 200000 + 4000 - 700
    add $t3, $t0, $t1        # $t3 = 200000 + 4000
    sub $s0, $t3, $t2        # $s0 = 204000 - 700

    # Print result
    li $v0, 1                # Select syscall to print int
    move $a0, $s0            # Load value from $s0 to $a0
    syscall                  # Syscall to print result 200000 + 4000 - 700

    # Exit program
    li $v0, 10               # Syscall to exit
    syscall
