.data
	.globl board, status, main, exitProg, slider, turn
	board: .word 1,2,3,4,5,6,7,8,9,10,12,14,15,16,18,20,21,24,25,27,28,30,32,35,36,40,42,45,48,49,54,56,63,64,72,81
	status: .word 0, 0, 1, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	slider: .word 0,1,0,0,1,0,0,0,0
	turn: .word 1
	
.text
	# CHOOSE RANDOM NUMBER FOR SLIDER

	# INITIAL BOARD PRINT
	la $ra, main
	j print
	
main:

	# CHECK WHOS TURN IT IS
	lw $t1, turn
	
	# CALL EITHER GET PLAYER INPUT OR GENERATE COMPUTER MOVE BASED ON CHOICE
	beq $t1, 1, callPlayerTurn
	j callComputerTurn
	
callPlayerTurn:
	j playerTurn
	
callComputerTurn:
	# will change depending on generate computer move function
	
exitProg:
	li $v0, 10
	syscall
