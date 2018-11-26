# Microprocessors
Repository for Physics Year 3 microprocessors lab project- Mastermind

An assembly program for PIC18 microprocessor, that produce the code-breaking game.

Four combination of colour(R,G,Y,B) is produced randomly or manually inputted by another player.

The player is then required to guess the answer within a limited amount of tries.

Code structure:
Main code: Simple1.asm

The code is basically separated into three structures.
Initialisation:
1) game_initialise.asm (Call the UART, LCD setup. Clear the values in the port and choose the number of tires in the game)
2) interrupt.asm  (Enable the interrupt for timer0)
3) end-start.asm  (Display the start screen)

Gameplay:
1)keyin_values.asm (Allow the player to key in the guess)

Result:
1)light_calculation.asm (Calculate the value to display on the LEDs)
2)end_game_seq.asm (Decide the game result, win or lost)
3)end-start.asm (Display the end game screen)

Subroutine used:
History_Result.asm (Send history of guess and result to simple serial port terminal)
LCD.asm (Configurate the LCD, enable the LCD functions)
UART.asm (Configurate the UART, enable the UART functions)
Look_up_write.asm (translate the values into the colour ASCII character)
count_colour.asm (count the number of each colour in the guess and answer)
game_logic.asm (determine the number of correct position and colour)
game_mode.asm (allow the selection of game mode)
keyboard.asm (allow the use of keypad)
manual_input.asm (allow the manual input of the answer)
random_generate.asm (generate random number)
