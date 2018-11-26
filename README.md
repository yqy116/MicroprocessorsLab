# Microprocessors

This is the repository for Physics Year 3 microprocessors lab project- Mastermind. This is an assembly program for the PIC18 microprocessor, which produces the code-breaking game.

This game is inspired by the popular game Mastermind. There are 4 possible colours to choose from and 4 possible positions. Colours may be repeated and the order of the colours matter. When you guess a colour in the right position, a green light will appear on the LED. If you guess the correct colour but it is in the wrong position, an orange/amber light will appear on the LED. If you guess the wrong colour and the wrong position, then no light will appear on the LED. With the UART, green lights are denoted with ‘G’ and displayed next to the guess. Amber lights are denoted with ‘A’ and is displayed next to the guess. The number of ‘G’s and ‘A’s are displayed in front of the respective letter. If you win the game, the LCD will says "you win" and the game will end. If you don't win, the LCD displays 'you lose' and will display the correct sequence. 


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

Subroutine used 
