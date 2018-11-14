#include p18f87k22.inc
	global	initial
	extern	LCD_Clear, LCD_delay_ms, secondline
	extern	validate, comparison, add_z, buzzer, wingame, loop_end,print,print_answer
	extern	temp_res,y_count,myArray,myinitial,total_light

acs0    udata_acs 
    pos_counter res 1   ;the logic position 
acs_ovr	access_ovr
	
code
initial	;All kind of initialization
	movlw	0x00
	movwf	temp_res
	movwf	y_count
	lfsr    FSR0, myArray 
	lfsr    FSR2, myinitial
	movlw	0x04
	movwf	pos_counter ;number of loop
	movwf	total_light
	call	LCD_Clear
	movlw	.5	    ;Need some time before it clear
	call	LCD_delay_ms

testtest	
	call	validate
	decfsz  pos_counter 
	goto	testtest
	
after_y	call	comparison
	movf	temp_store,W
	addwf	y_count,W
	subwf	total_light, f
	movf	total_light, W
	movlw	0x01
	addwf	total_light,f
	call	add_z
	clrf	TRISH
	movff	temp_res, PORTH
	movlw	0x04
	CPFSGT	y_count	    ;lose condition
	call	buzzer
	movlw	0x04
	CPFSEQ	y_count	    ;win condition
	goto	restart
	call	wingame
	call	loop_end
	call	print
	return

restart	lfsr	FSR2, myArray
	call	UART_Transmit_Message
	goto	back_game

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
	return