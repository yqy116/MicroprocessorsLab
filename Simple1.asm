#include p18f87k22.inc

	extern	LCD_Setup, LCD_Send_Byte_D ,LCD_delay_ms, LCD_Clear
	extern	UART_Setup, UART_Transmit_Message
   

acs0    udata_acs   ; named variables in access ram
int_ct	res 1
pos1	res 1 ;first position for squence of colour
pos2	res 1 ;second position for squence of colour
pos3	res 1 ;so on
pos4	res 1
dig_1	res 1
dig_2	res 1
read_pos res 1
storage	res 1
number	res 1
adder	res 1
tempo	res 1	
myArray res 4 ;save answer
counter res 1 ;count answer
dumpster res 1
temp_ans  res 1
myinitial res 4;save initial values
pos_counter res 1   ;the position 
ans_pos	res 1	    ;key in position
ran_pos	res 1	    ;rsequence position
scoring	res 1
temp_pst res 1
temp_scr res 1
temp_res res 1
correct_count res 1
not_socorrect_count res 1
not_socorrect_temp  res 1
temp_res_2  res 1  
game_counter res 1
R_count	res 1
G_count	res 1    
Y_count res 1
B_count res 1
temp_store res 1
B_count_seq res 1
R_count_seq res 1
Y_count_seq res 1
G_count_seq res 1
total_light res 1
y_count	res 1 
exponent res 1
 
 
rst	code 0x0000 ; reset vector	
	call LCD_Setup	
	goto start
int_hi	code 0x0008 ; high vector, no low vector
	btfss INTCON,TMR0IF ; check that this is timer0 interrupt
	retfie FAST ; if not then return
	;incf	LATD
	incf	int_ct
	call	keyboard
	bcf INTCON,TMR0IF ; clear interrupt flag
	retfie FAST ; fast return from interrupt
	
main	code
start	call UART_Setup
	clrf TRISD ; Set PORTD as all outputs
	clrf LATD ; Clear PORTD outputs
	clrf LATE
	clrf LATC
	movlw b'10000000' ; Set timer0 to 16-bit, Fosc/4/256
	movwf T0CON ; = 62.5KHz clock rate, approx 1sec rollover
	bsf PIE1, TMR1IE ; Enable timer2 interrupt
	bsf INTCON,TMR0IE ; Enable timer0 interrupt
	bsf INTCON,GIE ; Enable all interrupts
	
check	movlw	0xEB
	CPFSEQ	tempo
	bra	check	
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
	
	;intialise
	movlw	0x05
	movwf	game_counter
	movlw	0x00
	movwf	R_count_seq
	movwf	G_count_seq
	movwf	Y_count_seq
	movwf	B_count_seq
	lfsr    FSR2, myinitial
	call	lookup				;initialise the lookup table
	
	movlb	0				;select bank 0 so the access bank is used again
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
;count
	movff	pos1, temp_store
	movf	temp_store, W
	call	colour_count_seq
	movff	pos2, temp_store
	call	colour_count_seq
	movff	pos3, temp_store
	call	colour_count_seq
	movff	pos4, temp_store
	call	colour_count_seq
	goto	keyin
		
	
keyin	movlw b'10000000' ; Set timer0 to 16-bit, Fosc/4/256
	movwf T0CON ; = 62.5KHz clock rate, approx 1sec rollover
	bsf INTCON,TMR0IE ; Enable timer0 interrupt
	bsf INTCON,GIE ; Enable all interrupts
	lfsr FSR0, myArray 
	movlw	0x04
	movwf	counter
	movlw	0x00
	movwf	R_count
	movwf	G_count
	movwf	Y_count
	movwf	B_count
	
loop	movlw	0xff
	CPFSEQ	tempo
	goto	answ
	goto	loop
	
answ	movf	tempo, W
	movff	tempo, temp_store
	movff	tempo, POSTINC0
	call	write
	call	colour_count
	
back	decfsz  counter
	goto	loop
	goto	initial
	
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
	clrf	TRISC
	movff	temp_res, PORTC
	movlw	0x04
	CPFSGT	y_count
	movwf	PORTD
	call	LCD_delay_ms
;	movlw	0x04
;	lfsr	FSR2, myArray
;	call	UART_Transmit_Message
	goto	back_game

back_game
	movlw	.5	    ;Need some time before it clear
	call	LCD_delay_ms
	call	LCD_Clear
	movlw	.5	    ;Need some time before it clear
	call	LCD_delay_ms
	decfsz	game_counter
	goto	keyin
	goto	$

	
;EVERYTHING HERE ONWARDS IS SUBROUTINE	
add_z	decfsz	total_light
	goto	binary_z
	return
	
binary_z 
	movlw	0x01
	movwf	temp_scr
	movff	total_light,exponent
	movlw	0x04
	addwf	exponent,f
	movff	exponent,temp_pst
	call	iter
	movf	temp_scr, W
	addwf	temp_res, f
	goto	add_z	

validate
	movf	POSTINC0, W	;key in answer
	movff	PLUSW1, storage
	movf	storage, W
	movwf	temp_ans	
	;call	LCD_Send_Byte_D	 ;error checking
	movf	POSTINC2, W 	;initial sequence
	movff	PLUSW1, storage
	movf	storage, W
	;call	LCD_Send_Byte_D	 ;error checking
	CPFSEQ	temp_ans
	return
	call	cor_pos	
	return

cor_pos	movlw	0x01
	movwf	temp_scr
	addwf	y_count
	movff	y_count,temp_pst
	call	iter
	movf	temp_scr, W
	addwf	temp_res
	return
	
iter	decf	temp_pst
	movlw	0x00
	CPFSEQ	temp_pst
	call    mutiplier	
	movlw	0x00
	CPFSEQ	temp_pst
	bra	iter
	return	
	
mutiplier   movlw   0x02
	    MULWF   temp_scr
	    movff   PRODL, temp_scr
	    return

comparison
	movlw	0x00	
	movwf	temp_store

	movf	R_count_seq, W
	CPFSLT	R_count
	subwf	R_count, W
	CPFSLT	R_count
	addwf	temp_store, f
	
	movf	G_count_seq, W
	CPFSLT	G_count
	subwf	G_count, W
	CPFSLT	G_count
	addwf	temp_store, f
	
	movf	Y_count_seq, W
	CPFSLT	Y_count
	subwf	Y_count, W
	CPFSLT	Y_count
	addwf	temp_store, f
	
	movf	B_count_seq, W
	CPFSLT	B_count
	subwf	B_count, W
	CPFSLT	B_count
	addwf	temp_store, f
	return
	
;CORRECT CODE
fair	call	read
	movff	read_pos, dig_2
	call	read
	movff	read_pos, dig_1
	movlw	0x01 ;masking
	ANDWF	dig_2, f
	ANDWF	dig_1, f
	movlw	0x02
	MULWF	dig_2, W
	movf	PRODL, W
	ADDWF	dig_1, f
	return

keyboard	;banksel cannot be same line with a label,etc.start
	banksel PADCFG1				;enable pull-ups and all that for PORTE
	bsf	PADCFG1,RJPU,BANKED
	movlw	0xFF
	movwf	0x01
	;Start the row 
	movlw	0x0F				;gets the row byte
	movwf	TRISJ
	call	delay
	movwf	PORTJ
	call	delay
	movf	PORTJ, W, ACCESS
	movwf   adder
	;Start the column			;gets the column byte
	call	delay
	movlw	0xF0
	movwf	TRISJ
	call	delay
	movwf	PORTJ
	call	delay
	movf	PORTJ, W, ACCESS		;combine the row and column binary stuff and output it to portD
	iorwf	adder, W
	movwf	tempo
	return
	
read	movff	int_ct, read_pos
	call	LCD_delay_ms
	return

write	
	movff	PLUSW1, storage
	movf	storage, W
	call	LCD_Send_Byte_D			;once it's all retrieved, write it to the LCD
	call	LCD_delay_ms
	call	LCD_delay_ms
	return
	
	
lookup
	movlb	6		    ;select bank 6
	lfsr	FSR1, 0x680	    ;point FSR1 to the middle of bank 6
	movlw	'R'		    ; load all of the ascii codes into locations +/- away from the FSR1
	movwf	storage
	movlw	0x00
	movff	storage, PLUSW1
	
	movlw	'G'
	movwf	storage
	movlw	0x01
	movff	storage, PLUSW1
	
	movlw	'B'
	movwf	storage
	movlw	0x02
	movff	storage, PLUSW1
	
	movlw	'Y'
	movwf	storage
	movlw	0x03
	movff	storage, PLUSW1
	
	;keyin table
	movlw	'R'		    ; load all of the ascii codes into locations +/- away from the FSR1
	movwf	storage
	movlw	0x77
	movff	storage, PLUSW1
	
	movlw	'G'
	movwf	storage
	movlw	0xB7
	movff	storage, PLUSW1
	
	
	movlw	'B'
	movwf	storage
	movlw	0xD7
	movff	storage, PLUSW1
	
	movlw	'Y'
	movwf	storage
	movlw	0xE7
	movff	storage, PLUSW1
	
	return

colour_count_seq
	movlw	0x00
	CPFSEQ	temp_store
	goto	second_count_seq
	movlw	0x01
	addwf	R_count_seq, f
	return
	
second_count_seq	
	movlw	0x01
	CPFSEQ	temp_store
	goto	third_count_seq
	movlw	0x01
	addwf	G_count_seq, f
	return
	
third_count_seq	
	movlw	0x02
	CPFSEQ	temp_store
	goto	fourth_count_seq
	movlw	0x01
	addwf	B_count_seq, f
	return	

fourth_count_seq	
	movlw	0x03
	CPFSEQ	temp_store
	return
	movlw	0x01
	addwf	Y_count_seq, f
	return	

colour_count
	movlw	0x77
	CPFSEQ	temp_store
	goto	second_count
	movlw	0x01
	addwf	R_count, f
	return
	
second_count	
	movlw	0xB7
	CPFSEQ	temp_store
	goto	third_count
	movlw	0x01
	addwf	G_count, f
	return
	
third_count	
	movlw	0xD7
	CPFSEQ	temp_store
	goto	fourth_count
	movlw	0x01
	addwf	B_count, f
	return	

fourth_count	
	movlw	0xE7
	CPFSEQ	temp_store
	return
	movlw	0x01
	addwf	Y_count, f
	return		
	
delay	decfsz 0x01 ; decrement until zero
	bra delay
	return
	end