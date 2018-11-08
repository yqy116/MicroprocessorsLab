    #include p18f87k22.inc
extern	LCD_Setup, LCD_Send_Byte_D ,LCD_delay_ms, LCD_Clear
   

acs0    udata_acs   ; named variables in access ram
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
ans1	res 1
ans2	res 1
ans3	res 1
ans4	res 1
myArray res 4 ;save answer
counter res 1 ;count answer
dumpster res 1
temp_ans  res 1
myinitial res 4;save initial values
 
rst	code 0x0000 ; reset vector	
	call LCD_Setup	
	goto start
int_hi	code 0x0008 ; high vector, no low vector
	btfss INTCON,TMR0IF ; check that this is timer0 interrupt
	retfie FAST ; if not then return
	;bra   scd_int
	incf LATD ; increment PORTD
	call	keyboard
	bcf INTCON,TMR0IF ; clear interrupt flag
	retfie FAST ; fast return from interrupt

;scd_int	btfss PIE1,TMR1IE; check that this is timer1 interrupt
;	retfie FAST ; if not then return
;	call	keyboard
;	retfie FAST
	
main	code
start	clrf TRISD ; Set PORTD as all outputs
	clrf LATD ; Clear PORTD outputs
	movlw b'10000000' ; Set timer0 to 16-bit, Fosc/4/256
	movwf T0CON ; = 62.5KHz clock rate, approx 1sec rollover
	bsf INTCON,TMR0IE ; Enable timer0 interrupt
	bsf INTCON,GIE ; Enable all interrupts
	
check	setf	TRISE
	movlw	0xff
	CPFSEQ	PORTE
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

	lfsr    FSR2, myinitial
	call	lookup				;initialise the lookup table
	movlb	0				;select bank 0 so the access bank is used again
	movf	pos1, W				;use the pressed button to obtain the data from bank6
	call	write
	movwf	POSTINC2
	movf	pos2, W	
	call	write
	movwf	POSTINC2
	movf	pos3, W	
	call	write
	movwf	POSTINC2
	movf	pos4, W	
	call	write	
	movwf	POSTINC2

	
keyin	movlw b'10000000' ; Set timer0 to 16-bit, Fosc/4/256
	movwf T0CON ; = 62.5KHz clock rate, approx 1sec rollover
	bsf INTCON,TMR0IE ; Enable timer0 interrupt
	bsf INTCON,GIE ; Enable all interrupts
	lfsr FSR0, myArray 
	movlw	0x04
	movwf	counter
	
loop	movlw	0xff
	CPFSEQ	tempo
	goto	answ
	goto	loop
	
answ	movf	tempo, W
	movff	tempo, POSTINC0
	call	write
	decfsz  counter
	goto	loop
	
	movlw	0x05
	movwf	counter
	call	LCD_Clear
	lfsr    FSR0, myArray 
	lfsr    FSR2, myinitial
snip	movf	POSTINC2, W 
	call	LCD_Send_Byte_D	
	goto	snip
testtest	
	call	validate
	movf	POSTINC0, W 
	decfsz  counter 
	goto	testtest
	goto	$


validate
	movff	PLUSW1, storage
	movf	storage, W
	movwf	temp_ans
	movf	POSTINC2, W 			;use the pressed button to obtain the data from bank6
	movff	PLUSW1, storage
	movf	storage, W
	CPFSEQ	temp_ans
	call	wrong
	CPFSEQ	temp_ans
	return
	call	correct	
	return

correct	movlw	'Y'
	call	LCD_Send_Byte_D	
	call	LCD_delay_ms
	call	LCD_delay_ms
	return
wrong	movlw	'N'
	call	LCD_Send_Byte_D	
	call	LCD_delay_ms
	call	LCD_delay_ms
	return
	
	
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
	clrf	TRISH
	movwf	PORTH	
	movwf	tempo
	return
	
read	movff	PORTD, read_pos
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
	
;	
;	movlw	0x00		    ; load all of the ascii codes into locations +/- away from the FSR1
;	movwf	storage
;	movlw	0x77
;	movff	storage, PLUSW1
;	
;	movlw	0x01
;	movwf	storage
;	movlw	0xB7
;	movff	storage, PLUSW1
;	
;	
;	movlw	0x02
;	movwf	storage
;	movlw	0xD7
;	movff	storage, PLUSW1
;	
;	movlw	0x03
;	movwf	storage
;	movlw	0xE7
;	movff	storage, PLUSW1
	
	return


delay	decfsz 0x01 ; decrement until zero
	bra delay
	return
	end