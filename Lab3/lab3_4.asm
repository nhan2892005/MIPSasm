    .data
msg_invalid:  .asciiz "Invalid input\n"
msg_result:   .asciiz "The Fibonacci number is: "

    .text
    .globl main
main:
    # Nhập giá trị n từ người dùng
    li $v0, 5
    syscall
    move $t0, $v0      # Lưu n vào $t0

    # Kiểm tra nếu n < 0
    bltz $t0, invalid_input

    # Nếu n == 0, trả về 0
    beqz $t0, return_0

    # Nếu n == 1, trả về 1
    li $t1, 1
    beq $t0, $t1, return_1

    # Tính Fibonacci cho n > 1
    li $t2, 0          # f0 = 0
    li $t3, 1          # f1 = 1
    li $t4, 2          # i = 2

fibonacci_loop:
    bge $t4, $t0, print_result  # Nếu i > n, kết thúc vòng lặp
    add $t5, $t2, $t3           # fn = f(n-1) + f(n-2)
    move $t2, $t3               # f(n-2) = f(n-1)
    move $t3, $t5               # f(n-1) = fn
    addi $t4, $t4, 1            # i++

    j fibonacci_loop

return_0:
    li $t0, 0
    j print_result

return_1:
    li $t0, 1
    j print_result

invalid_input:
    li $v0, 4
    la $a0, msg_invalid
    syscall
    j exit

print_result:
    # In kết quả Fibonacci
    li $v0, 4
    la $a0, msg_result
    syscall

    li $v0, 1
    move $a0, $t0
    syscall

exit:
    li $v0, 10         # syscall để thoát chương trình
    syscall
