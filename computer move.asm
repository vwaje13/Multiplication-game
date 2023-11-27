.data
board:      # Updated game board with predefined products
    .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 14, 15, 16, 18, 20, 21, 24, 25, 27, 28, 30, 32, 35, 36, 40, 42, 45, 48, 49, 54, 56, 63, 64, 72, 81

status:     # Status array to track whether a product is taken or not
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

# Function to generate a random number between 1 and 9
random_number:
    li   $v0, 42       # System call for generating a random number
    li   $a0, 9        # Maximum random number (inclusive)
    syscall
    addi $v0, $v0, 1    # Ensure the result is between 1 and 9
    jr   $ra            # Return

# Function to check if a product is already taken
is_taken:
    lw   $t0, status($a0)   # Load the status of the product
    bnez $t0, retry         # If taken, retry
    li   $v0, 1             # If not taken, set result to 1 (true)
    jr   $ra                # Return

retry:
    jal  random_number      # Retry with a new random number
    j    is_taken           # Check again

# Function to update the board and status array with a valid move
update_board:
    jal  random_number      # Generate the first random number
    move $s0, $v0

    # Check if the first random number is in the board array
    li   $t2, 0            # Initialize a flag to check if the product is in the board
    la   $t3, board         # Load the address of the board array

    # Iterate through the board array to check if the product is present
    check_board:
        lw   $t4, 0($t3)     # Load the product from the board array
        beq  $s0, $t4, found_product  # If the product is found, set the flag
        addi $t3, $t3, 4      # Move to the next product in the board array
        bnez $t4, check_board  # If the current product is not 0, continue checking

    # If the product is not in the board array, retry
    j    retry

found_product:
    # Check the index in the board array corresponding to the first random number
    sub  $t1, $t3, $t3      # Calculate the index in the board array
    divu $t1, $t1, 4        # Divide by 4 to get the index
    mflo $t1                # Store the index in $t1

retry_first:
    jal  is_taken           # Check if the status at the board's index is already taken
    bnez $v0, retry_first   # If taken, retry

    # If the status is not taken, update the status array
    sw   $s0, status($t1)   # Mark the first random number as taken by the player

    # Update the corresponding product in the status array
    sw   $t1, status($s0)   # Mark the corresponding product as taken by the player

retry_second:
    jal  random_number      # Generate the second random number
    move $s1, $v0

    mul  $t0, $s0, $s1       # Calculate the product

    jal  is_taken           # Check if the product is already taken
    beq  $v0, 0, retry_second  # If taken, retry

    # If the product is not taken, update the status array
    sw   $s1, status(1)      # Mark the second random number as taken by the computer

    # Update the corresponding product in the status array
    sw   $t0, status($s1)   # Mark the corresponding product as taken by the computer

    jr   $ra                # Return

.text
main:
    # Call the update_board function
    jal update_board

    # The status array is now updated with a valid move
    # You can use the updated values for your game logic