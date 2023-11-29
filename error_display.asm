.data
	board:  .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 14, 15, 16, 18, 20, 21, 24, 25, 27, 28, 30, 32, 35, 36, 40, 42, 45, 48, 49, 54, 56, 63, 64, 72, 81
	status: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	slider: .word 0, 0, 0, 0, 0, 0, 0, 0, 0
	message1: .asciiz "\nOne of the values you inputted are out of the bounds [1,9]. Input again.\n"
	message2: .asciiz "\nOne (and only one) of your values must be a value currently selected on the slider. Input again.\n"
	message3: .asciiz "\nThis value is already chosen on the board. Input again.\n" 
.text
	main:
	error_1: 
		li $v0, 4
		la $a0, message1:
		syscall
		j user_input
		
	error_2: 
		li $v0, 4
		la $a0, message2:
		syscall
		j user_input
	
	error_3: 
		li $v0, 4
		la $a0, message3:
		syscall
		j user_input
		
		