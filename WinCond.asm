.data
statusArray: .word 0:36     # Status array to track the board status, assuming a 6x6 board
sliderArray: .word 1:9      # Slider positions, assuming 9 positions

.text
.globl main

# Function to check for horizontal win condition
checkHorizontalWin:
    # Registers:
    # $t0 - base address of statusArray
    # $t1 - row counter
    # $t2 - column counter
    # $t3 - temporary value for comparison
    # $t4 - consecutive count
    # $t5 - player number (1 or 2, depending on whose turn it is)
    # $t6 - index calculation
    # $t7 - constant value 4 for comparison

    la $t0, statusArray     # Load base address of statusArray

    li $t1, 0               # Initialize row counter
    li $t7, 4               # Set comparison value for 4 in a row

    horizontal_loop:
        li $t2, 0           # Initialize column counter for each row
        li $t4, 0           # Reset consecutive count
        li $t5, 1           # Assuming it's player's turn, set to 2 for computer's turn

        horizontal_inner_loop:
            bge $t2, 3, end_horizontal_row # End of row check
            
            # Calculate index in statusArray
            mul $t6, $t1, 6 # Multiply row counter by row size
            add $t6, $t6, $t2 # Add column counter
            sll $t6, $t6, 2 # Convert to word offset
            add $t6, $t0, $t6 # Add offset to base address
            
            lw $t3, 0($t6) # Load the current element

            # Check if the current element matches the player's number
            beq $t3, $t5, increment_consecutive # Increment if same as player's number
            li $t4, 0 # Reset consecutive count if not a match

            increment_consecutive:
                addi $t4, $t4, 1 # Increment consecutive count
                beq $t4, $t7, horizontal_win # Check if four in a row is reached

            addi $t2, $t2, 1 # Move to next column
            j horizontal_inner_loop

        end_horizontal_row:
            addi $t1, $t1, 1 # Move to next row
            blt $t1, 6, horizontal_loop # Loop back if more rows to check

    li $v0, 0 # Set return value to 0 (no win)
    jr $ra # Return

horizontal_win:
    li $v0, 1 # Set return value to 1 (win found)
    jr $ra # Return

# Function to check for vertical win condition
# (Similar structure to checkHorizontalWin, but iterating column-wise)

# Additional functions to check diagonal wins

# Function to check for valid moves
checkValidMoves:
    # Similar structure to checking win conditions, but iterating over sliderArray
    # and checking if any corresponding product in statusArray is unclaimed (0)

main:
    # Main game logic
    # ...

    # Call checkWinCondition function at the appropriate place
    jal checkHorizontalWin # Example call to check for a horizontal win
    beqz $v0, no_horizontal_win
    # Code to handle horizontal win

no_horizontal_win:
    # Similarly, call other win check functions and handle their outcomes

    # Call checkValidMoves function at the appropriate place
    # ...

    # Continue with the rest of the game logic
    # ...
