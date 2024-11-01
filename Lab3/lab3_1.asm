    .data
msg_even:    .asciiz "Computer Science and Engineering, HCMUT\n"
msg_odd:     .asciiz "Computer Architecture 2022\n"

    .text
    .globl main
main:
    # Nhập giá trị a từ người dùng
    li $v0, 5          # syscall to read an integer
    syscall
    move $t0, $v0      # Lưu giá trị a vào $t0

    # Kiểm tra nếu a % 2 == 0
    li $t1, 2          # Load giá trị 2 vào $t1
    div $t0, $t1       # Chia a cho 2
    mfhi $t2           # Lấy phần dư (remainder) vào $t2

    beqz $t2, print_even  # Nếu phần dư là 0, in chuỗi "Computer Science and Engineering"
    j print_odd           # Ngược lại, in chuỗi "Computer Architecture"

print_even:
    li $v0, 4          # syscall để in chuỗi
    la $a0, msg_even   # Địa chỉ của chuỗi cần in
    syscall
    j exit

print_odd:
    li $v0, 4          # syscall để in chuỗi
    la $a0, msg_odd    # Địa chỉ của chuỗi cần in
    syscall

exit:
    li $v0, 10         # syscall để thoát chương trình
    syscall
