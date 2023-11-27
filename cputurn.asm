.data
	space: .asciiz " "
.globl generate_CPU_turn
.text
generate_CPU_turn:
    	 jal update_board
    	 jal print
    	 
    	 # jump somewhere

	# Function to update the board and status array with a valid move
update_board:
	addi $sp, $sp, 4
	sw $ra, 0($sp)

	jal  random_number			# Generate the first random number
	move $a0, $v0				# store it in argument register
	jal random_number			# Generate the second random number
	move $a1, $v0				# store it in second argument register
	
	lw $ra, 0($sp)
	subi $sp, $sp, 4

	j is_taken					# check if this product is taken

found_product:
	# SET PRODUCT IN STATUS ARRAY
	li $t0, 2
	sw $t0, status($v0)
	
	# RESET SLIDER ARRAY TO ZERO
	
	li $t1, -4						# loop to set each value in slider to zero
	resetLoop:
	addi $t1, $t1, 4
	sw $zero, slider($t1)
	bne $t1, 32, resetLoop
	
	
	# SET RANDOM NUMBERS IN SLIDER ARRAY
	move $t1, $a0				# get word index for first random
	subi $t1, $t1, 1				# ^
	mul $t1, $t1, 4				# ^
	
	move $t2, $a1				# get word index for second random
	subi $t2, $t2 1				# ^
	mul $t2, $t2, 4				# ^
	
	li $t0, 1						# set indices to 1
	sw $t0, slider($t1)			# ^
	sw $t0, slider($t2)			# ^

	jr $ra
	
is_taken:
	sw $a0, 	4($sp)				# store first random number for later
	mul $a0, $a0, $a1			# find product of random numbers
	
	j getBoardIndex				# get index of the product form board array
	
is_takenCont:
	lw $t0, status($v0)			# check if tile is empty, retry if taken
	bne $t0, 0, update_board		# ^
	
	lw $a0, 4($sp)				# restore first random number
	j found_product				# continue to update status
    
	# takes a product on the board and returns its index (word aligned)
getBoardIndex:
	li $v0, -4
	indexLoop1:
		addi $v0, $v0, 4
		lw $t0, board($v0)
		bne $t0, $a0, indexLoop1
	j is_takenCont
	
	#Function to generate a random number between 1 and 9
random_number:
	sw $a0, 4($sp)
	li $v0, 42
	li $a1, 9
	syscall
	addi $a0, $a0, 1
	move $v0, $a0
	lw $a0, 4($sp)
	 jr   $ra
