    .data
msg_result: .asciiz "The result of a is: "

    .text
    .globl main
main:
    # Nhập giá trị a, b, c
    li $v0, 5          # syscall để nhập số nguyên
    syscall
    move $t0, $v0      # Lưu giá trị a

    li $v0, 5
    syscall
    move $t1, $v0      # Lưu giá trị b

    li $v0, 5
    syscall
    move $t2, $v0      # Lưu giá trị c

    # Kiểm tra if (a <= -3) || (a >= 7)
    li $t3, -3
    ble $t0, $t3, multiply   # Nếu a <= -3 thì nhảy đến multiply

    li $t4, 7
    bge $t0, $t4, multiply   # Nếu a >= 7 thì nhảy đến multiply

    # Else: a = b + c
    add $t0, $t1, $t2        # a = b + c
    j print_result

multiply:
    # a = b * c
    mul $t0, $t1, $t2        # a = b * c

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
