#include p18f87k22.inc
	
	extern	UART_Setup, UART_Transmit_Message  ; external UART subroutines
	extern  LCD_Setup, LCD_Write_Message, LCD_clear, LCD_Send_Byte_D ; external LCD subroutines
	
acs0	udata_acs   ; reserve data space in access ram
counter	    res 1   ; reserve one byte for a counter variable
delay_count res 1   ; reserve one byte for counter in the delay routine
storage     res 10

tables	udata	0x400    ; reserve data anywhere in RAM (here at 0x400)
myArray res 0x80    ; reserve 128 bytes for message data

rst	code	0    ; reset vector
	goto	setup

pdata	code    ; a section of programme memory for storing data
	; ******* myTable, data in programme memory, and its length *****
myTable data	    "Hello World!\n"	; message, plus carriage return
	constant    myTable_l=.13	; length of data
	
main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup LCD
	goto	start
	
	; ******* Main programme ****************************************
start 	lfsr	FSR0, myArray	; Load FSR0 with address in RAM	
	movlw	upper(myTable)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(myTable)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(myTable)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	myTable_l	; bytes to read
	movwf 	counter		; our counter register
loop 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter		; count down to zero
	bra	loop		; keep going until finished
		
	movlw	myTable_l-1	; output message to LCD (leave out "\n")
	lfsr	FSR2, myArray
	call	LCD_Write_Message
	

	movlw	myTable_l	; output message to UART
	lfsr	FSR2, myArray
	call	UART_Transmit_Message


	
keyboard	;banksel cannot be same line with a label,etc.start
	banksel PADCFG1
	bsf	PADCFG1,REPU,BANKED
	clrf	LATE
	;Start the row 
	movlw	0x0F
	movwf	TRISE
	call	delay
	movwf	PORTE
	call	delay
	movf	PORTE, W, ACCESS
	movwf   0x10
	;Start the column 
	call	delay
	movlw	0xF0
	movwf	TRISE
	call	delay
	movwf	PORTE
	call	delay
	movf	PORTE, W, ACCESS
	iorwf	0x10,0,0
	clrf	TRISD
	movwf	PORTD
	
	call	translator

;	lfsr	FSR1, 0x77
;	movlw	0x41
;	call	LCD_Send_Byte_D
	
	goto	keyboard

	
translator  
	movlb	6
	;lsfr	FSR1, 0x68

	movlw	'1'
	movwf	0x77, BANKED
	
	
	movlw	'2'
	movwf	0xB7, BANKED	
	
	
	movlw	'3'
	movwf	0xD7, BANKED
	
	
	movlw	'4'
	movwf	0x7B, BANKED
	
	
	movlw	'5'
	movwf	0xBB, BANKED
	
	
	movlw	'6'
	movwf	0xDB, BANKED
	
	
	movlw	'7'
	movwf	0x7D, BANKED
	
	
	movlw	'8'
	movwf	0xBD, BANKED
	
	
	movlw	'9'
	movwf	0xDD, BANKED
	
	
	movlw	'A'
	movwf	0x7E, BANKED
	
	
	movlw	'B'
	movwf	0xDE, BANKED
	
	
	movlw	'C'
	movwf	0xEE, BANKED
	
	
	movlw	'D'
	movwf	0xED, BANKED
	
	
	movlw	'E'
	movwf	0xEB, BANKED
	
	
	movlw	'F'
	movwf	0xE7, BANKED
	
	
	movlw	'0'
	movwf	0xBE, BANKED
	
	movlw	'?'
	movwf	0xBA, BANKED
	return


	
delay	decfsz	0x20	; decrement until zero
	bra delay
	return	
	
	end


	
	end

	
