#include p18f87k22.inc
	
	extern	UART_Setup, UART_Transmit_Message  ; external UART subroutines
	extern  LCD_Setup, LCD_Write_Message, LCD_clear, LCD_Send_Byte_D ; external LCD subroutines
	
acs0	udata_acs   ; reserve data space in access ram
counter	    res 1   ; reserve one byte for a counter variable
delay_count res 1   ; reserve one byte for counter in the delay routine
storage     res 1

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
	goto	keyboard


	
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
	
	call	table
	movlb	0
	movf	PORTD, W
	movff	PLUSW1, storage
	movf	storage, W
	
	call	LCD_Send_Byte_D
	
	goto keyboard
	
	
	
	
	;call	translator
	;lfsr	FSR0, PORTD
;write	;movf	0x77, W	
;	call	LCD_Send_Byte_D

	goto	keyboard

;	
;translator  
;	movlw	0x77
;	CPFSEQ	PORTD
;	call	translator2
;	movlw	'5'
;	goto	write
;	
;translator2
;	movlw	0xB7
;	CPFSEQ	PORTD
;	return
;	movlw	'2'
;	goto	write


table
	movlb	6
	lfsr	FSR1, 0x680 
	movlw	'1'
	movwf	storage
	movlw	0x77
	movff	storage, PLUSW1
	
	movlw	'2'
	movwf	storage
	movlw	0xB7
	movff	storage, PLUSW1
	
	
	movlw	'3'
	movwf	storage
	movlw	0xD7
	movff	storage, PLUSW1
	
	movlw	'4'
	movwf	storage
	movlw	0x7B
	movff	storage, PLUSW1
	
	movlw	'5'
	movwf	storage
	movlw	0xBB
	movff	storage, PLUSW1
	
	movlw	'6'
	movwf	storage
	movlw	0xDB
	movff	storage, PLUSW1
	
	movlw	'7'
	movwf	storage
	movlw	0x7D
	movff	storage, PLUSW1
	
	movlw	'8'
	movwf	storage
	movlw	0xBD
	movff	storage, PLUSW1
	
	movlw	'9'
	movwf	storage
	movlw	0xDD
	movff	storage, PLUSW1
	
	movlw	'A'
	movwf	storage
	movlw	0x7E
	movff	storage, PLUSW1
	
	movlw	'B'
	movwf	storage
	movlw	0xDE
	movff	storage, PLUSW1
	
	movlw	'C'
	movwf	storage
	movlw	0xEE	
	movff	storage, PLUSW1
	
	movlw	'D'
	movwf	storage
	movlw	0xED
	movff	storage, PLUSW1
	
	movlw	'E'
	movwf	storage
	movlw	0xEB
	movff	storage, PLUSW1
	
	movlw	'F'
	movwf	storage
	movlw	0xE7
	movff	storage, PLUSW1
	
	movlw	'0'
	movwf	storage
	movlw	0xBE
	movff	storage, PLUSW1
	
	movlw	'?'
	movwf	storage
	movlw	0xFF
	movff	storage, PLUSW1
	
	return
delay	decfsz	0x20	; decrement until zero
	bra delay
	return	
	
	end




	
