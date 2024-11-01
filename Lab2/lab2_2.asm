    .data
result_msg: .asciiz "The result of 200000 + 4000 - 700 is: "

    .text
    .globl main
main:
    # Load 200000 into a register
    lui $t0, 3              # Load upper 16 bits (200000 = 0x30D40, upper 16 bits = 3)
    ori $t0, $t0, 34464     # Combine lower 16 bits (0x30D40 in decimal = 200000)

    # Load 4000 into a register using immediate
    li $t1, 4000            # $t1 = 4000

    # Load 700 into a register using immediate
    li $t2, 700             # $t2 = 700

    # Perform addition: 200000 + 4000
    add $t3, $t0, $t1       # $t3 = 200000 + 4000

    # Perform subtraction: (200000 + 4000) - 700
    sub $s0, $t3, $t2       # $s0 = (200000 + 4000) - 700

    # Print the result
    li $v0, 4               # syscall for printing a string
    la $a0, result_msg      # load result message
    syscall

    li $v0, 1               # syscall for printing an integer
    move $a0, $s0           # move the result from $s0 to $a0
    syscall

    # Exit program
    li $v0, 10
    syscall
