#include p18f87k22.inc
	extern	game_startup
	extern	generate, read
	extern	keyin
	extern	count
	extern	initial
	extern	startgame
	extern	tempo, keyboard
	extern	storage,lookup, write
	extern	LCD_Setup, LCD_Send_Byte_D, LCD_Clear
	extern	UART_Setup, UART_Transmit_Message
	extern	UART_loop
	extern	interrupt_setup, interrupt_1
	extern	after_y
	extern	end_game_logic
	global	myArray, myinitial
	
	
acs0    udata_acs   ; named variables in access ram

myArray res 4 ;save answer
myinitial res 4;save initial values
read_count  res	1

 
rst	code 0x0000 ; reset vector		
	goto start
	
main	code
start	call	game_startup
	call	interrupt_setup
	call	startgame

enter	call	keyboard
;	movlw	0xff
;	CPFSEQ	PORTE
	movlw	0xEB
	CPFSEQ	tempo
	bra	enter	

Initialise_sequence
	call	LCD_Clear
	;Start reading the values
	call	generate    ;generate random number
	call	interrupt_1 ;start interrupt_1,stop interrupt_0
	lfsr    FSR2, myinitial
	movlw	0x04
	movwf	read_count
	;will remove the write at end of game
trial_loop	
	call	write_ans
	decfsz	read_count
	goto	trial_loop
	call	count
	
;key in guess
answering
	call	keyin
	lfsr    FSR0, myArray 
	movf	POSTINC0,W
	movff	PLUSW1, storage
	movf	storage, W
	call	LCD_Send_Byte_D	
	movf	POSTINC0,W
	movff	PLUSW1, storage
	movf	storage, W
	call	LCD_Send_Byte_D	
	movf	POSTINC0,W
	movff	PLUSW1, storage
	movf	storage, W
	call	LCD_Send_Byte_D	
	movf	POSTINC0,W
	movff	PLUSW1, storage
	movf	storage, W
	call	LCD_Send_Byte_D	

calculate_validate
	call	initial	;initialization to green(yes) calculation
	call	after_y	;from yellow light to show result in port H
	call	end_game_logic ;consists of choosing win and lose and restart the game
	goto	start	

;debug purpose
write_ans
	movf	POSTINC2, W				;use the pressed button to obtain the data from bank6
	call	write
	return
	
	end


	