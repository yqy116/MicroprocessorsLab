#include p18f87k22.inc
	extern	game_startup,loop1_gametry
	extern	generate, read
	extern	keyin
	extern	count
	extern	initial
	extern	startgame,choice1,choice2,trials
	extern	tempo, keyboard
	extern	storage,lookup, write
	extern	LCD_Send_Byte_D, LCD_Clear
	extern	interrupt_setup, interrupt_1
	extern	after_y
	extern	end_game_logic
	global	myArray, myinitial,start
	extern	UART_Transmit_Byte
	extern	game_counter
	extern	point
	extern	tempo
	extern	secondline,count_manual
	
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
	;call	checker
	;movf	game_counter,W
	;goto	$
choose_tries
	call	LCD_Clear
	call	trials
	call	loop1_gametry
	
;uncomment to test manual input
Initialise_sequence
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
	goto	resume
	
manual_route
	movlw	0x7D
	CPFSEQ	tempo
	goto	invalid	    ;if 4 or 5 not pressed go back and try again
	goto	manual_initiate
manual_initiate
	call	LCD_Clear   ;clear the start message (LCD)
	call	point	    ;allow user to manually input the answ
	call	count_manual	;count the number of each colour in the answ
	goto	resume
	
resume	goto	answering
	
;revert back if doesnt work	
;Initialise_sequence
;	call	LCD_Clear   ;clear the start message (LCD)
;	;Start reading the values
;	call	generate    ;generate random number(random_generate)
;	call	interrupt_1 ;start interrupt_1,stop interrupt_0 (interrupt)
;	call	count
	
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
;	lfsr    FSR0, myArray	    ;for debugging purpose to see whether the guess was able to be called correctly
;	movf	POSTINC0,W
;	movff	PLUSW1, storage
;	movf	storage, W
;	call	LCD_Send_Byte_D	
;	movf	POSTINC0,W
;	movff	PLUSW1, storage
;	movf	storage, W
;	call	LCD_Send_Byte_D	
;	movf	POSTINC0,W
;	movff	PLUSW1, storage
;	movf	storage, W
;	call	LCD_Send_Byte_D	
;	movf	POSTINC0,W
;	movff	PLUSW1, storage
;	movf	storage, W
;	call	LCD_Send_Byte_D	

calculate_validate ;compare the guess and answer and make an end game decision(win/lose)+show result in UART/LED
	call	initial	;from initialization to green(yes) calculation (light calculation)
	call	after_y	;from amber light to show result in port H	(light calculation)
	call	end_game_logic ;consists of choosing win and lose and restart the game	(end_game_seq)
	goto	start	;restart the game

;debug purpose
write_ans
	movf	POSTINC2, W				;use the pressed button to obtain the data from bank6
	call	write
	return
	
	end


	
