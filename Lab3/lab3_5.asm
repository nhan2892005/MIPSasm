    .data
str:         .asciiz "Computer Architecture CSE-HCMUT"
msg_result:  .asciiz "The index of 'r' is: "
msg_not_found: .asciiz "'r' not found\n"

    .text
    .globl main
main:
    la $t0, str        # Địa chỉ của chuỗi
    li $t1, 0          # i = 0

find_r:
    lb $t2, 0($t0)     # Đọc ký tự hiện tại từ chuỗi
    beqz $t2, not_found # Nếu gặp ký tự null '\0', thoát ra (không tìm thấy)
    beq $t2, 'r', print_result  # Nếu ký tự là 'r', thoát ra

    addi $t0, $t0, 1   # Chuyển sang ký tự tiếp theo
    addi $t1, $t1, 1   # Tăng i
    j find_r

not_found:
    li $v0, 4
    la $a0, msg_not_found
    syscall
    j exit

print_result:
    # In kết quả index của 'r'
    li $v0, 4
    la $a0, msg_result
    syscall

    li $v0, 1
    move $a0, $t1
    syscall

exit:
    li $v0, 10         # syscall để thoát chương trình
    syscall
