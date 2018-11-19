#include p18f87k22.inc
	 extern LCD_Clear,choice1,choice2,secondline,keyboard,generate,count
	 extern	interrupt_1,point,count_manual
	 extern	tempo
	 global	Game_choice
	
;this contain the subroutine to choose the game mode
	 
mode	 code
	 
Game_choice
	call	LCD_Clear   ;clear the start message (LCD)
	call	choice1	    ;print the game mode in LCD
	call	secondline  ;jump to the second line of LCD
	call	choice2	    ;print the game mode in LCD
invalid
	call	keyboard    ;enable keypad to choose the mode
	movlw	0x7B	    ;press 4 for random mode
	CPFSEQ	tempo
	goto	manual_route	;manual input mode
	goto	random_route	;random mode
	
random_route
	call	LCD_Clear   ;clear the start message (LCD)
	;Start reading the values
	call	generate    ;generate random number(random_generate)
	call	count	    ;count the number of each colour in the answ
	call	interrupt_1 ;allow the keyboard to work and stop the random generator
	return
	
manual_route
	movlw	0x7D
	CPFSEQ	tempo
	goto	invalid	    ;if 4 or 5 not pressed go back and try again
	goto	manual_initiate
manual_initiate
	call	LCD_Clear   ;clear the start message (LCD)
	call	point	    ;allow user to manually input the answ
	call	count_manual ;count the number of each colour in the answ
	call	interrupt_1 ;allow the keyboard to work and stop the random generator
	return

	end