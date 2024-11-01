.data
shared_counter: .word 0       # Biến đếm chia sẻ ban đầu là 0
lock: .word 0                 # Biến khóa ban đầu là 0 (tự do)

msg: .asciiz "The value of shared_counter is: "

.text
main:
    # Lưu giá trị của $ra trước khi gọi hàm
    addi $sp, $sp, -4         # Tạo không gian trên ngăn xếp
    sw   $ra, 0($sp)          # Lưu giá trị của $ra

    # Giả sử tiến trình sẽ gọi hàm tăng giá trị đếm
    la   $s1, shared_counter  # Địa chỉ của biến đếm chia sẻ
    la   $s2, lock            # Địa chỉ của biến khóa
    jal  incrementCounter     # Gọi hàm tăng giá trị đếm

    # Phục hồi giá trị của $ra sau khi gọi hàm
    lw   $ra, 0($sp)          # Phục hồi giá trị của $ra
    addi $sp, $sp, 4          # Giải phóng không gian trên ngăn xếp

    # In giá trị của shared_counter
    li   $v0, 4               # Mã syscall cho print_string
    la   $a0, msg             # Địa chỉ của thông điệp
    syscall                   # Thực hiện syscall để in thông điệp

    lw   $a0, shared_counter  # Tải giá trị của shared_counter vào $a0
    li   $v0, 1               # Mã syscall cho print_int
    syscall                   # Thực hiện syscall để in giá trị của shared_counter

    # Thoát chương trình
    li   $v0, 10              # Mã syscall cho exit
    syscall                   # Thực hiện syscall để thoát chương trình

# Hàm tăng giá trị đếm chia sẻ
incrementCounter:
    addi $sp, $sp, -4         # Tạo không gian trên ngăn xếp
    sw   $ra, 0($sp)          # Lưu giá trị của $ra

    jal  acquireLock          # Lấy khóa
    lw   $t0, 0($s1)          # Tải giá trị hiện tại của biến đếm
    addi $t0, $t0, 1          # Tăng giá trị đếm
    sw   $t0, 0($s1)          # Lưu giá trị mới vào biến đếm
    jal  releaseLock          # Giải phóng khóa

    lw   $ra, 0($sp)          # Phục hồi giá trị của $ra
    addi $sp, $sp, 4          # Giải phóng không gian trên ngăn xếp
    jr   $ra                  # Trở về caller

# Hàm lấy khóa
acquireLock:
    addi $t0, $zero, 1        # Đặt giá trị khóa (1)
try_acquire:
    ll   $t1, 0($s2)          # Tải giá trị liên kết từ bộ nhớ (biến khóa)
    bne  $t1, $zero, try_acquire # Nếu khóa không tự do (không phải zero), thử lại
    sc   $t0, 0($s2)          # Lưu điều kiện (cố gắng đặt khóa)
    beq  $t0, $zero, try_acquire # Nếu lưu điều kiện thất bại, thử lại
    jr   $ra                  # Trở về caller khi khóa đã được lấy

# Hàm giải phóng khóa
releaseLock:
    addi $t0, $zero, 0        # Đặt khóa thành tự do (0)
    sw   $t0, 0($s2)          # Lưu giá trị vào bộ nhớ để giải phóng khóa
    jr   $ra                  # Trở về caller
