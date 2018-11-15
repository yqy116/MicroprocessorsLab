#include p18f87k22.inc
	extern	fair,read
	extern	keyin
	extern	count
	extern	dig_1
	extern	startgame, endgame, wingame ,print, counter, loop_end, buzzer, print_answer
	extern	temp_store,colour_count_seq,colour_count, comparison
	extern	tempo, keyboard
	extern	storage,lookup, write
	extern	LCD_Setup, LCD_Send_Byte_D ,LCD_delay_ms, LCD_Clear, LCD_Write_Message, secondline
	extern	temp_ans,temp_scr,total_light,temp_pst,y_count,temp_res
	extern	validate,add_z,binary_z,iter,mutiplier
	extern	UART_Setup, UART_Transmit_Message
	global	int_ct,pos1,pos2,pos3,pos4,myArray, myinitial, count_orange
	extern	UART_loop
	
acs0    udata_acs   ; named variables in access ram
int_ct	res 1
pos1	res 1 ;first position for squence of colour
pos2	res 1 ;second position for squence of colour
pos3	res 1 ;so on
pos4	res 1
myArray res 4 ;save answer
myinitial res 4;save initial values
count_orange	res 1; save number for orange led
pos_counter res 1   ;the logic position 
game_counter res 1  ;the loop of game

 
rst	code 0x0000 ; reset vector	
	call LCD_Setup	
	goto start
int_hi	code 0x0008 ; high vector, no low vector
	btfss INTCON,TMR0IF ; check that this is timer0 interrupt
	goto	 second
	movlw	.1
	movwf	TMR0L
	incf	int_ct
	bcf INTCON,TMR0IF ; clear interrupt flag
	retfie FAST ; fast return from interrupt

second	btfss PIR1,TMR1IF
	retfie FAST
	call	keyboard
	bcf PIR1,TMR1IF ; clear interrupt flag
	retfie FAST ; fast return from interrupt
	
main	code
start	call UART_Setup
	clrf TRISD ; Set PORTD as all outputs
	clrf LATD ; Clear PORTD outputs
	clrf LATE
	clrf LATC
	clrf LATH
	movlw b'00000100' ; Close timer 1, when repeat apparently not closed
	movwf T1CON 
	;clrf TRISH ;test
	movlw b'10000000' ; Set timer0 to 16-bit, Fosc/4/256
	movwf T0CON ; = 62.5KHz clock rate, approx 1sec rollover

	bsf INTCON,TMR0IE ; Enable timer0 interrupt
	bsf INTCON,GIE ; Enable all interrupts
	bsf INTCON,PEIE 
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
	call	fair
	movff	dig_1, pos1
	call	fair
	movff	dig_1, pos2
	call	fair
	movff	dig_1, pos3
	call	fair
	movff	dig_1, pos4

	;stop interupt
	movlw	b'00000000'
	movwf	T0CON
	;start interrupt 1
	movlw b'00000101' ; Set timer0 to 16-bit, Fosc/4/256
	movwf T1CON 
        movlw b'00000000' ; Set timer0 to 16-bit, Fosc/4/256
	movwf T1GCON 

	bsf PIE1, TMR1IE ; Enable timer1 interrupt
	;intialise
	movlw	0x05
	movwf	game_counter
	call	lookup				;initialise the lookup table
	movlb	0
	lfsr    FSR2, myinitial

	;will remove the write at end of game
	movf	pos1, W				;use the pressed button to obtain the data from bank6
	movwf	POSTINC2
	call	write
	movf	pos2, W	
	movwf	POSTINC2
	call	write
	movf	pos3, W	
	movwf	POSTINC2
	call	write
	movf	pos4, W	
	movwf	POSTINC2
	call	write	
	call	count

;key in guess
answering
	call	keyin
	
initial	;All kind of initialization
	movlw	0x00
	movwf	temp_res
	movwf	y_count
	movwf	temp_pst
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
	movff	total_light, count_orange
	movlw	0x01
	addwf	total_light,f
	call	add_z
	clrf	TRISH
	movff	temp_res, PORTH
	movlw	0x04
	CPFSGT	y_count	    ;lose condition
	call	buzzer
	lfsr	FSR2, myArray
	movlw	0x04
	movwf	temp_store  ;UART initialize
	CPFSEQ	y_count	    ;win condition
	call	UART_loop
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

retry	;call	keyboard
	movlw	0x7E	;loop the game again
	CPFSEQ	tempo
	goto	retry
	call	LCD_Clear
	movlw	.5
	call	LCD_delay_ms
	clrf	PORTH 
	goto	start	

	end


	