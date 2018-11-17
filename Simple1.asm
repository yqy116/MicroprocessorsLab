#include p18f87k22.inc
	extern	game_startup
	extern	generate, read
	extern	keyin
	extern	count
	extern	initial
	extern	startgame
	extern	tempo, keyboard
	extern	storage,lookup, write
	extern	LCD_Send_Byte_D, LCD_Clear
	extern	interrupt_setup, interrupt_1
	extern	after_y
	extern	end_game_logic
	global	myArray, myinitial
	extern	UART_Transmit_Byte
	extern	game_counter
	extern	point
	extern	tempo
	
;main file, this contains the main script and the order in which the routines are called. Regarding comments,
; if there is a bracket with writing inside, e.g (game_initialise), located at the end of the comment, this is
; the file in which te called subroutine, variable or file is located.

acs0    udata_acs   ; named variables in access ram
myArray res 4 ;save answer
myinitial res 4;save initial values for PVP mode
read_count  res	1

 
rst	code 0x0000 ; reset vector		
	goto start
	
main	code
start	call	game_startup	;initialise setup and game tries (game_initialise)
	call	interrupt_setup	;start timer 0 and enable all flag setup (interrupt)
	call	startgame   ;send start game message to lcd (end_start)
	
enter	call	keyboard    ;to enable keypad
;	movlw	0xff	    ;when want to avoid using keypad
;	CPFSEQ	PORTE
	movlw	0xEB	    ;only when press E the code will procede
	CPFSEQ	tempo	    ;tempo is the key(unstranslated) pressed
	bra	enter	    ;loop until E is pressed in keypad
	;call	checker
	;movf	game_counter,W
	;goto	$
Initialise_sequence
	call	LCD_Clear   ;clear the start message(lcd)
	;Start reading the values
	call	generate    ;generate random number(random_generate)
	call	interrupt_1 ;start interrupt_1,stop interrupt_0 (interrupt)
;	lfsr    FSR2, myinitial	;this commented code is for debug purpose to see the answer
;	movlw	0x04
;	movwf	read_count
;	;will remove the write at end of game
;trial_loop	
;	call	write_ans
;	decfsz	read_count
;	goto	trial_loop
;	call	count
;	
;key in guess
answering
	call	keyin		    ;call the routine to key in the guesses(
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


	
