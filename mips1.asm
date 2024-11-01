.data
result: .word 0       # Biến để lưu kết quả
overflow_msg: .asciiz "Overflow\n"

.text
main:
    li $t0, 2147483647  # $t0 = 2147483647
    li $t1, 1            # $t1 = 1

    # Cộng $t0 và $t1
    addu $t2, $t0, $t1      # $t2 = $t0 + $t1 (không gây lỗi tràn)

    # Kiểm tra tràn số
    xor $t3, $t0, $t1      # $t3 = $t0 ^ $t1
    xor $t4, $t0, $t2      # $t4 = $t0 ^ $t2
    andi $t5, $t0, 0x80000000 # Kiểm tra bit dấu của $t0
    andi $t6, $t2, 0x80000000 # Kiểm tra bit dấu của $t2

    beq $t3, $t5, no_overflow # Nếu bit dấu giống nhau thì không tràn

    # Nếu tràn số, in thông báo
    li $v0, 4              # syscall để in chuỗi
    la $a0, overflow_msg    # địa chỉ của chuỗi
    syscall

no_overflow:
    # Lưu kết quả vào biến
    sw $t2, result          # Lưu $t2 vào biến result

    # Kết thúc chương trình
    li $v0, 10             # syscall để kết thúc
    syscall
