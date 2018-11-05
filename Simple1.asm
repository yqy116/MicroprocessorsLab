    #include p18f87k22.inc
extern	LCD_Setup, LCD_Write_Message, LCD_Write_Hex, LCD_Send_Byte_D ,LCD_delay_ms
acs0    udata_acs   ; named variables in access ram
pos1	res 1
pos2	res 1
pos3	res 1
pos4	res 1
read_pos res 1
	
rst	code 0x0000 ; reset vector	
	call LCD_Setup	
	goto start
int_hi	code 0x0008 ; high vector, no low vector
	btfss INTCON,TMR0IF ; check that this is timer0 interrupt
	retfie FAST ; if not then return
	incf LATD ; increment PORTD
	bcf INTCON,TMR0IF ; clear interrupt flag
	retfie FAST ; fast return from interrupt

main	code
start	clrf TRISD ; Set PORTD as all outputs
	clrf LATD ; Clear PORTD outputs
	movlw b'10000000' ; Set timer0 to 16-bit, Fosc/4/256
	movwf T0CON ; = 62.5KHz clock rate, approx 1sec rollover
	bsf INTCON,TMR0IE ; Enable timer0 interrupt
	bsf INTCON,GIE ; Enable all interrupts
	
check	setf	TRISE
	movlw	0xff
	movwf	0x01
	CPFSEQ	PORTE
	bra	check
	;Start reading the values
	call	read
	movff	read_pos, pos1
	call	read
	movff	read_pos, pos2
	call	read
	movff	read_pos, pos3
	call	read
	movff	read_pos, pos4
	;stop interupt
	movlw	b'00000000'
	movwf	T0CON
	;move value to W for mask
	movlw	0x03
	ANDWF	pos1, f
	ANDWF	pos2, f
	ANDWF	pos3, f
	ANDWF	pos4, f

	
	goto $ ; Sit in infinite loop
		
read	movff	PORTD, read_pos
	call	LCD_delay_ms
	return

convert	
	
delay	decfsz 0x01 ; decrement until zero
	bra delay
	return
	end