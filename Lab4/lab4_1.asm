    .data
cArray:        .asciiz "Computer Architecture 2022"
cArray_size:   .word 26

    .text
    .globl main

main:
    la $a0, cArray       # Địa chỉ của chuỗi cArray vào $a0
    lw $a1, cArray_size  # Kích thước của chuỗi vào $a1
    jal reverse          # Gọi hàm reverse
    li $v0, 4            # syscall để in chuỗi
    la $a0, cArray       # Chuỗi sau khi đảo ngược
    syscall
    jr $ra               # Quay về từ main

reverse:
    addi $sp, $sp, -8    # Tạo không gian cho biến tạm và chỉ số i
    sw $t0, 0($sp)       # Lưu $t0 (i)
    sw $t1, 4($sp)       # Lưu $t1 (temp)

    li $t0, 0            # i = 0
reverse_loop:
    div $t2, $a1, 2      # cArray_size / 2
    mflo $t3             # Lưu kết quả phép chia vào $t3
    bge $t0, $t3, reverse_end # Nếu i >= cArray_size/2 thì thoát vòng lặp

    lb $t1, 0($a0)       # temp = cArray[i]
    sub $t4, $a1, $t0    # t4 = cArray_size - 1 - i
    addi $t4, $t4, -1
    lb $t5, 0($t4)       # cArray[cArray_size - 1 - i]
    sb $t5, 0($a0)       # cArray[i] = cArray[cArray_size - 1 - i]
    sb $t1, 0($t4)       # cArray[cArray_size - 1 - i] = temp

    addi $a0, $a0, 1     # i++
    addi $t0, $t0, 1
    j reverse_loop       # Quay lại vòng lặp

reverse_end:
    lw $t0, 0($sp)       # Phục hồi $t0
    lw $t1, 4($sp)       # Phục hồi $t1
    addi $sp, $sp, 8     # Giải phóng không gian stack
    jr $ra               # Quay l
