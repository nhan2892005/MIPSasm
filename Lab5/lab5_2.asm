.data
    pi: .float 3.1415926            # Pi value stored in data segment
    prompt: .asciiz "Enter radius of the circle: "  # Prompt for user input
    errorMsg: .asciiz "Invalid radius!\n"  # Error message for invalid radius
    newline: .asciiz "\n"           # Newline character
    zero: .float 0.0                # Floating point value for 0.0
    circumferenceMsg: .asciiz "Circumference: "  # Label for circumference output
    areaMsg: .asciiz "Area: "              # Label for area output

.text
    .globl main

main:
    # Print the prompt to input radius
    li $v0, 4                       # Syscall for printing string
    la $a0, prompt                  # Load address of the prompt string
    syscall

    # Read the radius (float)
    li $v0, 6                       # Syscall for reading float
    syscall
    mov.s $f12, $f0                 # Move input value to $f12 (radius)

    # Load 0.0 into floating-point register for comparison
    la $a0, zero                    # Load the address of zero (0.0)
    l.s $f0, 0($a0)                 # Load floating point value 0.0 into $f0

    # Check if radius is less than or equal to 0
    c.le.s $f12, $f0                # Compare radius ($f12) with 0.0 ($f0)
    bc1t invalid                    # If radius <= 0, jump to 'invalid' label

    # Load pi into a floating-point register
    la $a0, pi                      # Load the address of pi
    l.s $f1, 0($a0)                 # Load pi value into $f1

    # Calculate circumference = 2 * pi * r
    mul.s $f2, $f12, $f1            # f2 = r * pi
    add.s $f2, $f2, $f2             # f2 = 2 * (r * pi) -> Circumference

    # Calculate area = pi * r^2
    mul.s $f3, $f12, $f12           # f3 = r^2
    mul.s $f4, $f3, $f1             # f4 = pi * r^2 -> Area

    # Print circumference label
    li $v0, 4                       # Syscall for printing string
    la $a0, circumferenceMsg        # Load address of circumference label
    syscall

    # Print the circumference value
    li $v0, 2                       # Syscall for printing float
    mov.s $f12, $f2                 # Move circumference to $f12 for printing
    syscall

    # Print newline after circumference
    li $v0, 4                       # Syscall for printing string
    la $a0, newline                 # Load address of newline string
    syscall

    # Print area label
    li $v0, 4                       # Syscall for printing string
    la $a0, areaMsg                 # Load address of area label
    syscall

    # Print the area value
    li $v0, 2                       # Syscall for printing float
    mov.s $f12, $f4                 # Move area to $f12 for printing
    syscall

    # Print newline after area
    li $v0, 4                       # Syscall for printing string
    la $a0, newline                 # Load address of newline string
    syscall

    # Exit the program
    li $v0, 10                      # Syscall to exit
    syscall

invalid:
    # Print error message for invalid radius
    li $v0, 4                       # Syscall for printing string
    la $a0, errorMsg                # Load address of error message
    syscall

    # Exit the program
    li $v0, 10                      # Syscall to exit
    syscall
