.data
a: .word 5            # Giá trị ban đầu của a
b: .word 10           # Giá trị ban đầu của b
str_a: .asciiz "Gia tri cua a: "   # Chuỗi thông báo cho a
str_b: .asciiz "Gia tri cua b: "   # Chuỗi thông báo cho b

.text
.globl main
# Hàm main
main:
    # Tải địa chỉ của a và b vào các thanh ghi
    la $a0, a           # $a0 trỏ tới a
    la $a1, b           # $a1 trỏ tới b

    # Gọi hàm swap
    jal swap

    # In giá trị sau khi hoán đổi
    li $v0, 4           # Lệnh in chuỗi
    la $a0, str_a       # Địa chỉ của chuỗi thông báo cho a
    syscall

    li $v0, 1           # Lệnh in số nguyên
    lw $a0, a           # Lấy giá trị của a
    syscall

    li $v0, 4           # Lệnh in chuỗi
    la $a0, str_b       # Địa chỉ của chuỗi thông báo cho b
    syscall

    li $v0, 1           # Lệnh in số nguyên
    lw $a0, b           # Lấy giá trị của b
    syscall

    # Kết thúc chương trình
    li $v0, 10          # Lệnh thoát chương trình
    syscall

# Hàm swap
swap:
    # Lưu các thanh ghi cần sử dụng vào stack
    addi $sp, $sp, -12  # Dịch con trỏ stack xuống để dành chỗ lưu
    sw $ra, 8($sp)      # Lưu địa chỉ trả về
    sw $a0, 4($sp)      # Lưu tham số a
    sw $a1, 0($sp)      # Lưu tham số b

    # Lấy giá trị của a và b
    lw $t0, 0($a0)      # $t0 = a
    lw $t1, 0($a1)      # $t1 = b

    # Hoán đổi giá trị
    sw $t1, 0($a0)      # a = b
    sw $t0, 0($a1)      # b = a

    # Khôi phục các thanh ghi từ stack
    lw $a0, 4($sp)      # Khôi phục tham số a
    lw $a1, 0($sp)      # Khôi phục tham số b
    lw $ra, 8($sp)      # Khôi phục địa chỉ trả về
    addi $sp, $sp, 12   # Khôi phục con trỏ stack

    jr $ra              # Trở về hàm gọi
