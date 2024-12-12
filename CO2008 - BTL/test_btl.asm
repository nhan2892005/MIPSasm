.data
filename:  .asciiz "number.txt"  # Tên tệp
buffer:    .space 256           # Bộ đệm để đọc dữ liệu
numbers:   .space 200           # Mảng lưu các số nguyên (giả định tối đa 50 số)
comma:     .byte ','            # Dấu phân cách
newline:   .byte 10, 0          # Ký tự xuống dòng (NL)

.text
main:
    # Mở tệp (syscall 13 - open file)
    li      $v0, 13              # syscall 13: open file
    la      $a0, filename        # Đường dẫn tệp
    li      $a1, 0               # Read-only mode
    li      $a2, 0               # Không có cờ
    syscall
    move    $s0, $v0             # Lưu file descriptor vào $s0
    bltz    $s0, exit            # Nếu lỗi, thoát chương trình

    # Đọc tệp (syscall 14 - read file)
    li      $v0, 14              # syscall 14: read file
    move    $a0, $s0             # File descriptor
    la      $a1, buffer          # Bộ đệm để đọc dữ liệu
    li      $a2, 256             # Đọc tối đa 256 byte
    syscall

    # Bỏ qua dòng đầu tiên
    la      $t0, buffer          # Địa chỉ đầu của buffer
skip_first_line:
    lb      $t1, 0($t0)          # Đọc ký tự từ buffer
    beq     $t1, 0, parse_done   # Hết dữ liệu
    beq     $t1, 10, start_parse # Ký tự xuống dòng -> chuyển đến dòng 2
    addi    $t0, $t0, 1          # Chuyển đến ký tự tiếp theo
    j       skip_first_line

start_parse:
    addi    $t0, $t0, 1          # Bỏ qua ký tự xuống dòng
    la      $t2, numbers         # Con trỏ tới mảng lưu số nguyên
    li      $t3, 0               # Biến lưu số tạm thời
    li      $t4, 1               # Để xử lý số âm, 1 = dương, -1 = âm

parse_numbers:
    lb      $t1, 0($t0)          # Lấy ký tự tiếp theo
    beq     $t1, 0, parse_done   # Hết buffer
    beq     $t1, 10, parse_done  # Kết thúc dòng
    beq     $t1, 44, save_number # Nếu là dấu phẩy `,`
    beq     $t1, 45, negative    # Nếu là dấu `-` (số âm)

    # Chuyển ký tự thành số
    sub     $t1, $t1, 48         # Chuyển '0'-'9' thành số
    mul     $t3, $t3, 10         # Dịch trái để cộng số mới
    add     $t3, $t3, $t1        # Thêm số vào t3
    addi    $t0, $t0, 1          # Ký tự tiếp theo
    j       parse_numbers

negative:
    li      $t4, -1              # Đánh dấu số âm
    addi    $t0, $t0, 1          # Ký tự tiếp theo
    j       parse_numbers

save_number:
    mul     $t3, $t3, $t4        # Áp dụng dấu âm nếu có
    sw      $t3, 0($t2)          # Lưu số vào mảng
    addi    $t2, $t2, 4          # Di chuyển con trỏ mảng
    li      $t3, 0               # Đặt lại t3
    li      $t4, 1               # Đặt lại t4
    addi    $t0, $t0, 1          # Ký tự tiếp theo
    j       parse_numbers

parse_done:
    # Lưu số cuối cùng (nếu có)
    mul     $t3, $t3, $t4
    sw      $t3, 0($t2)

    # Đóng tệp (syscall 16 - close file)
    li      $v0, 16              # syscall 16: close file
    move    $a0, $s0             # File descriptor
    syscall

    # Hiển thị các số đã lưu
    la      $t2, numbers
    li      $t5, 50              # Tối đa 50 số
print_loop:
    lw      $a0, 0($t2)          # Lấy số từ mảng
    li      $v0, 1               # syscall 1: print integer
    syscall
    addi    $t2, $t2, 4          # Tới số tiếp theo
    addi    $t5, $t5, -1         # Giảm bộ đếm
    bgtz    $t5, print_loop      # Tiếp tục nếu còn số
    j       exit

exit:
    li      $v0, 10              # syscall 10: exit
    syscall
