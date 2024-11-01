    .data
msg_result: .asciiz "The result of a is: "
msg_invalid: .asciiz "Invalid input\n"

    .text
    .globl main
main:
    # Cho sẵn b = 100, c = 2
    li $t1, 100        # b = 100
    li $t2, 2          # c = 2

    # Nhập input từ người dùng
    li $v0, 5
    syscall
    move $t0, $v0      # Lưu input vào $t0

    # switch-case
    li $t3, 1          # case 1
    beq $t0, $t3, case1

    li $t3, 2          # case 2
    beq $t0, $t3, case2

    li $t3, 3          # case 3
    beq $t0, $t3, case3

    li $t3, 4          # case 4
    beq $t0, $t3, case4

    j default_case     # Nếu không khớp, chuyển đến default case

case1:
    add $t0, $t1, $t2  # a = b + c
    j print_result

case2:
    sub $t0, $t1, $t2  # a = b - c
    j print_result

case3:
    mul $t0, $t1, $t2  # a = b * c
    j print_result

case4:
    div $t1, $t2       # a = b / c
    mflo $t0           # Lấy kết quả từ thanh ghi LO
    j print_result

default_case:
    li $t0, 0          # Default: a = 0
    j print_result

print_result:
    # In kết quả của a
    li $v0, 4
    la $a0, msg_result
    syscall

    li $v0, 1
    move $a0, $t0
    syscall

    li $v0, 10         # syscall để thoát chương trình
    syscall
