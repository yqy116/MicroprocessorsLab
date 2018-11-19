#include p18f87k22.inc
	extern	game_startup,game_tries
	extern	keyin
	extern	initial
	extern	startgame,trials
	extern	tempo, keyboard
	extern	storage,lookup, write
	extern	LCD_Clear
	extern	interrupt_setup
	extern	after_y
	extern	end_game_logic
	global	myArray, myinitial,start
	extern	Game_choice
	
;main file, this contains the main script and the order in which the routines are called. Regarding comments,
; if there is a bracket with writing inside, e.g (game_initialise), located at the end of the comment, this is
; the file in which te called subroutine, variable or file is located.

acs0    udata_acs   ; named variables in access ram
myArray res 4 ;save answer
myinitial res 4;save initial values 
read_count  res	1

 
rst	code 0x0000 ; reset vector		
	goto start
	
main	code
start	call	game_startup	;initialise setup and game tries (game_initialise)
	call	interrupt_setup	;start timer 0 and enable all flag setup (interrupt)
	call	startgame   ;send start game message to lcd (end_start)
	
enter_key
	call	keyboard    ;to enable keypad (keyboard)
;	movlw	0xff	    ;when the keyboard isn't used, all bits are high.
;	CPFSEQ	PORTE
	movlw	0xEB	    ;only when you press E the code will procede
	CPFSEQ	tempo	    ;tempo is the uncoded value of the paypad when it is pressed
	bra	enter_key	;loop until E is pressed in keypad. The keypad value won't proceed until E is pressed
	
choose_tries
	call	LCD_Clear   ;clear the previous message
	call	trials	    ;print game tries message to LCD(end_start)
	call	game_tries  ;choose the game try
	
;uncomment to test manual input
choose_mode
	call	Game_choice ;choose game mode(game_mode)

;	lfsr    FSR2, myinitial	;this commented code is for debug purpose to see the answer
;	movlw	0x04
;	movwf	read_count
;	;will remove the write at end of game
;trial_loop	
;	call	write_ans
;	decfsz	read_count
;	goto	trial_loop

;key in guess
answering
	call	keyin		    ;call the routine to key in the guesses (keyin_values)

calculate_validate ;compare the guess and answer and make an end game decision(win/lose)+show result in UART/LED
	call	initial	;from initialization to green(yes) calculation (light calculation)
	call	after_y	;from amber light to show result in port H	(light calculation)
	call	end_game_logic ;consists of choosing win and lose and restart the game	(end_game_seq)
	goto	start	;restart the game

;debug purpose
;write_ans
;	movf	POSTINC2, W				;use the pressed button to obtain the data from bank6
;	call	write
;	return
;	
	end


	
