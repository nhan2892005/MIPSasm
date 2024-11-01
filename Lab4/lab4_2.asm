    .data
iArray:        .word 5, 10, 15, 20, 25, 30, 35, 40, 45, 50
iArray_size:   .word 10

    .text
    .globl main

main:
    la $a0, iArray        # Địa chỉ mảng iArray
    lw $a1, iArray_size   # Kích thước mảng
    jal range             # Gọi hàm range
    move $a0, $v0         # Lưu kết quả vào $a0
    li $v0, 1             # syscall để in số
    syscall
    jr $ra                # Kết thúc chương trình

range:
    addi $sp, $sp, -4     # Tạo không gian cho $ra
    sw $ra, 0($sp)        # Lưu $ra

    jal max               # Gọi hàm max
    move $t0, $v0         # Lưu kết quả max vào $t0

    jal min               # Gọi hàm min
    move $t1, $v0         # Lưu kết quả min vào $t1

    sub $v0, $t0, $t1     # range = temp1 - temp2

    lw $ra, 0($sp)        # Phục hồi $ra
    addi $sp, $sp, 4      # Giải phóng stack
    jr $ra                # Quay lại caller

max:
    # (Giả sử thực hiện hàm max tại đây)
    jr $ra

min:
    # (Giả sử thực hiện hàm min tại đây)
    jr $ra
