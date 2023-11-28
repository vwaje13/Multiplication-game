.data
	nLine: .asciiz "\n"
	space: .asciiz " "
	playerSelected: .asciiz "+"
	computerSelected: .asciiz "-"
	
.globl print
.text
print:
	li $t1, 0
loop:
	mul $t3, $t1, 4
	lw $t4, status($t3)
	beq $t4, 1, print1
	beq $t4, 2, print2
	lw $a0, board($t3)
	li $t3, 10
	slt $t3, $a0, $t3
	beq $t3, 1, printSpecial
	li $v0, 1
	syscall
	j format
	
printSpecial:
	sw $a0, 0($sp)
	la $a0, space
	li $v0, 4
	syscall
	lw $a0, 0($sp)
	li $v0, 1
	syscall
	j format
	
print1:
	la $a0, space
	li $v0, 4
	syscall
	la $a0, playerSelected
	li $v0, 4
	syscall
	j format
	
print2:
	la $a0, space
	li $v0, 4
	syscall
	la $a0, computerSelected
	li $v0, 4
	syscall

format:
	la $a0, space
	li $v0, 4
	syscall
	add $t1, $t1, 1
	rem $t2, $t1, 6
	beq $t2, 0, newLine
	
exit:
	bne $t1, 36, loop
	jr $ra
	
newLine:	
	la $a0, nLine
	li $v0, 4
	syscall
	j exit

