#include p18f87k22.inc
	global	end_game_logic
	extern	buzzer,wingame,UART_loop,LCD_Clear,LCD_delay_ms,endgame,secondline,print_answer,keyin,initial,after_y,UART_Transmit_Byte
	extern	y_count,myArray,temp_store,game_counter,myinitial,tempo
;this code contain how to determine the end game result(win/lose) and repeat the game for several tries
ending_the_game	code
	
end_game_logic	    ;determine win/lose
	movlw	0x03
	CPFSGT	y_count	    ;lose condition as win when y=4
	call	buzzer	    ;buzzer sound if wrong
	lfsr	FSR2, myArray	;load the guess result to send to UART
	movlw	0x04	    
	movwf	temp_store  ;set the nubmer of bytes in guess to transmit in UART
	call	UART_loop   ;if didn't win, save result and guess through uart
	movlw	0x04
	CPFSEQ	y_count	    ;win condition
	goto	back_game   ;wrong, try again until game tries are used up
	call	wingame	    ;print winning message (end_start)
	goto	replay

back_game
	call	LCD_Clear   ;clear the previos guess in LCD
	decfsz	game_counter
	goto	retry	    ;go back to key in guess until game tries used up
	call	endgame	   ;print ending message (end_start
	movlw	0x04
	movwf	temp_store  ;(to print the correct answer)
	lfsr	FSR2,myinitial
	call	secondline  ;move to second line

show	call	print_answer	;print the correct answer
	decfsz	temp_store
	goto	show
	goto	replay

replay	movlw	0x7E	;loop the game again if pressed A
	CPFSEQ	tempo
	goto	replay
	call	LCD_Clear   ;clear the game
	clrf	PORTH	    ;clear the LED light
	movlw	'\n'	    ;send an extra empty line to separate past result with the new game result
	call    UART_Transmit_Byte
	return	

retry	call	keyin	    ;allow the guess again
	call	initial	    ;from initialization to green(yes) calculation (light calculation)
	call	after_y	    ;from amber light to show result in port H	(light calculation)
	goto	end_game_logic	;determine win/lose
	
	end