#include p18f87k22.inc
	extern	generate, read
	extern	keyin
	extern	count
	extern	initial
	extern	startgame, endgame, wingame ,print, counter, loop_end, buzzer, print_answer
	extern	temp_store,colour_count_seq,colour_count, comparison
	extern	tempo, keyboard
	extern	storage,lookup, write
	extern	LCD_Setup, LCD_Send_Byte_D ,LCD_delay_ms, LCD_Clear, LCD_Write_Message, secondline
	extern	y_count
	extern	UART_Setup, UART_Transmit_Message
	extern	UART_loop
	extern	interrupt_setup, interrupt_1
	extern	after_y
	global	int_ct,myArray, myinitial
	
acs0    udata_acs   ; named variables in access ram
int_ct	res 1
myArray res 4 ;save answer
myinitial res 4;save initial values
count_orange	res 1; save number for orange led
pos_counter res 1   ;the logic position 
game_counter res 1  ;the loop of game
read_count  res	1

 
rst	code 0x0000 ; reset vector		
	goto start
	
main	code
start	call UART_Setup
	call LCD_Setup
	clrf TRISD ; Set PORTD as all outputs
	clrf LATD ; Clear PORTD outputs
	clrf LATE
	clrf LATH
	call	interrupt_setup
	call	startgame
	call	loop_end
	call	print

check	call	keyboard
;	movlw	0xff
;	CPFSEQ	PORTE
	movlw	0xEB
	CPFSEQ	tempo
	bra	check	
	call	LCD_Clear
	movlw	.5
	call	LCD_delay_ms
	;Start reading the values
	call	generate    ;generate random number
	call	interrupt_1 ;start interrupt_1,stop interrupt_0
	;intialise
	movlw	0x05
	movwf	game_counter
	call	lookup				;initialise the lookup table
	movlb	0
	
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
	
	movlw	0x04
	CPFSGT	y_count	    ;lose condition
	call	buzzer
	lfsr	FSR2, myArray
	movlw	0x04
	movwf	temp_store  ;UART initialize
	CPFSEQ	y_count	    ;win condition
	call	UART_loop   ;if didn't win, save result and guess through uart
	CPFSEQ	y_count	    ;win condition
	goto	back_game
	call	wingame
	call	loop_end
	call	print
	goto	retry

back_game
	call	LCD_Clear
	movlw	.5	    ;Need some time before it clear
	call	LCD_delay_ms
	decfsz	game_counter
	goto	answering
	call	endgame
	call	loop_end
	call	print
	movlw	0x04
	movwf	temp_store
	lfsr	FSR2,myinitial
	call	secondline

show	call	print_answer
	decfsz	temp_store
	goto	show
	goto	retry

retry	movlw	0x7E	;loop the game again
	CPFSEQ	tempo
	goto	retry
	call	LCD_Clear
	movlw	.5
	call	LCD_delay_ms
	clrf	PORTH 
	goto	start	

;debug purpose
write_ans
	movf	POSTINC2, W				;use the pressed button to obtain the data from bank6
	call	write
	return
	
	end


	