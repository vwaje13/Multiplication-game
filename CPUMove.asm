.data
    nLine: .asciiz "\n"
    space: .asciiz " "
    computerMessage: .asciiz "\nComputer's Turn:\n"
    board: .word 1,2,3,4,5,6,7,8,9,10,12,14,15,16,18,20,21,24,25,27,28,30,32,35,36,40,42,45,48,49,54,56,63,64,72,81
    status: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    slider: .word 0,0,0,0,0,0,0,0,0
    turn: .word 
.text
generate_CPU_turn:

    # Display computer's turn message
    li $v0, 4
    la $a0, computerMessage
    syscall

retryGenerate:
    # Generate random number between 1 and 9
    li $v0, 42
    li $a1, 9
    syscall
    mul $t0, $a0, 4

    # Calculate product of slider's number and computer-generated number
    mul $a0, $t0, 4
    lw $t1, slider($a0)
    mul $a0, $t0, $t1

    # Check if the product is already taken in the status array
    la $t2, status
    sll $t3, $a0, 2
    add $t2, $t2, $t3
    lw $t4, 0($t2)
    beqz $t4, updateStatus

    # Retry if the product is already taken
    j retryGenerate

updateStatus:
    # Update the corresponding product in the status array
    sll $a0, $a0, 2
    add $t2, $t2, $a0
    li $t3, 2  # Assuming computer's marker is 2
    sw $t3, 0($t2)

    # Update the slider value with the computer-generated number
    sw $a0, slider($t0)

    # Jump to the main function
    #j main
    jr $ra
