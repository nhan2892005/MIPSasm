.data
    filename: .asciiz "output.txt"  # Tên file
    buffer: .space 20              # Bộ đệm để lưu chuỗi số nguyên
    newline: .asciiz "\n"          # Ký tự xuống dòng

.text
main:
    # 1. Mở file để ghi
    li $v0, 13                  # Syscall: open file
    la $a0, filename            # Đường dẫn file
    li $a1, 1                   # Chế độ ghi (write only)
    li $a2, 0                   # Không cờ (mode)
    syscall
    move $s0, $v0               # Lưu file descriptor vào $s0

    # 2. Chuyển số nguyên thành chuỗi
    li $t0, 12345               # Số nguyên cần ghi
    la $a0, buffer              # Địa chỉ bộ đệm
    move $a1, $t0               # Đưa số nguyên vào $a1 để chuẩn bị chuyển
    la $a2, 5
    jal int_to_string           # Gọi hàm chuyển đổi số nguyên thành chuỗi

    # 3. Ghi chuỗi vào file
    li $v0, 15                  # Syscall: write to file
    move $a0, $s0               # File descriptor
    la $a1, buffer              # Chuỗi chứa số nguyên
    li $a2, 20                  # Độ dài dữ liệu
    syscall

    # 4. Thêm ký tự xuống dòng vào file
    li $v0, 15                  # Syscall: write to file
    move $a0, $s0               # File descriptor
    la $a1, newline             # Ký tự xuống dòng
    li $a2, 1                   # Ghi 1 byte
    syscall

    # 5. Đóng file
    li $v0, 16                  # Syscall: close file
    move $a0, $s0               # File descriptor
    syscall

    # 6. Kết thúc chương trình
    li $v0, 10                  # Syscall: exit
    syscall

# Hàm chuyển số nguyên thành chuỗi
# Input: $a1 = số nguyên, $a0 = địa chỉ buffer
# Output: Chuỗi kết quả lưu trong buffer
int_to_string:
    li $t1, 10                  # Hệ số cơ số 10
    move $t2, $a1               # Lưu số nguyên ban đầu vào $t2
    la $t3, buffer              # Con trỏ buffer

    add $t3, $t3, $a2            # Điền chuỗi từ cuối về đầu
    # sb $zero, 0($t3)            # Ký tự kết thúc chuỗi '\0'

to_string_loop:
    div $t2, $t1                # Chia số cho 10
    mfhi $t4                    # Lấy phần dư (chữ số cuối)
    addi $t4, $t4, 48           # Chuyển thành mã ASCII
    subi $t3, $t3, 1            # Lùi con trỏ
    sb $t4, 0($t3)              # Ghi ký tự vào buffer
    mflo $t2                    # Lấy thương
    bnez $t2, to_string_loop    # Lặp lại nếu thương > 0

    subi $t3, $t3, 1            # Lùi con trỏ
    sb $zero, 0($t3)            # Ký tự kết thúc chuỗi '\0'
    move $a0, $t3               # Trả về con trỏ đầu chuỗi
    jr $ra                      # Quay về hàm chính