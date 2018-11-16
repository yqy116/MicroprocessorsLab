#include p18f87k22.inc
	extern	LCD_Send_Byte_D, LCD_delay_ms, write
	extern	temp_store
	global	startgame, endgame, wingame, buzzer, print_answer
	    
acs0	    udata_acs
word_count  res 1 ;number of words to be key in lcd
mssg res 15	  ;store the message
acs_ovr	access_ovr

start_end_screen	code	;this contain all the subroutine to send end/start game messsage to LCD
	
startTable data	    "Start:Press E"	; start message
winTable data	    "You win!"	; win message
myTable data	    "You lose!Ans is:"	;ending message
 
startgame	
	lfsr	FSR0, mssg	; Load FSR0 with address in RAM	
	movlw	upper(startTable)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(startTable)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(startTable)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	.13		
	movwf	temp_store	;store number of bytes of message into mssg
	movlw	0x0d
	movwf	word_count	;number of words to be key in lcd
	goto	loop_end
 
endgame	
	lfsr	FSR0, mssg	; Load FSR0 with address in RAM	
	movlw	upper(myTable)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(myTable)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(myTable)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	.16
	movwf	temp_store	;store number of bytes of message into mssg
	movlw	0x10
	movwf	word_count	;number of words to be key in lcd
	goto	loop_end

wingame	
	lfsr	FSR0, mssg	; Load FSR0 with address in RAM	
	movlw	upper(winTable)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(winTable)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(winTable)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	.8
	movwf	temp_store	;store number of bytes of message into mssg
	movlw	0x08
	movwf 	word_count	
	goto	loop_end

loop_end
	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	temp_store	; count down to zero
	bra	loop_end	; keep going until finished	
	lfsr	FSR2, mssg
	goto	print	
	
print	movf	POSTINC2, W	;move by one memory address after moving the content to W
	call	LCD_Send_Byte_D	;send the byte to lcd screen
	decfsz	word_count	;count down the number of bytes to be key in
	goto	print		;repeat until finish displaying all the message in lcd
	return	

;a subroutine to send a square wave for the buzzer	
buzzer	movlw	0x01		
	movwf	PORTD		;this will be connected to the buzzer
	movlw	0xf0
	call	LCD_delay_ms	;let the buzzer to last longer
	call	LCD_delay_ms
	clrf	PORTD		;close the buzzer
	return	

;a subroutine to send the answer to LCD
print_answer
	movf	POSTINC2, W	
	call	write
	return
	end