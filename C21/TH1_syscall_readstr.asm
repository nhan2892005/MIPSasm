.data
prompt: .asciiz "Nhap chuoi (toi da 10 ky tu): "
output_msg: .asciiz "Chuoi da nhap: "
buffer: .space 11    # Cung cấp không gian cho 10 ký tự + 1 ký tự kết thúc chuỗi

.text
.globl main

main:
    # Enter sring
    li $v0, 4          # Load syscall code for print string
    la $a0, prompt     # Load address of the prompt
    syscall             # Make the syscall

    li $v0, 8          # Load syscall code for read string
    la $a0, buffer     # Load address of the buffer
    li $a1, 11         # Maximum number of characters to read (10 + 1 for null terminator)
    syscall             # Make the syscall

    # Print string
    li $v0, 4          # Load syscall code for print string
    la $a0, output_msg # Load address of the output message
    syscall             # Make the syscall

    li $v0, 4          # Load syscall code for print string
    la $a0, buffer     # Load address of the buffer
    syscall             # Make the syscall

    # Exit program
    li $v0, 10         # Load syscall code for exit
    syscall             # Make the syscall
