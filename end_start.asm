#include p18f87k22.inc
	extern LCD_Send_Byte_D, LCD_delay_ms, write
	global startgame, endgame, wingame , counter, buzzer, print_answer
	    
acs0	    udata_acs
counter	    res 1 
word_count  res 1 
end_mssg res 15
acs_ovr	access_ovr

input	code
	
startTable data	    "Start:Press E"	; message, plus carriage return
winTable data	    "You win!"	; message, plus carriage return		
myTable data	    "You lose!Ans is:"	; message, plus carriage return
 
startgame	
	lfsr	FSR0, end_mssg	; Load FSR0 with address in RAM	
	movlw	upper(startTable)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(startTable)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(startTable)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	.13
	movwf	counter
	movlw	0x0d
	movwf	word_count
	goto	loop_end
 
endgame	
	lfsr	FSR0, end_mssg	; Load FSR0 with address in RAM	
	movlw	upper(myTable)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(myTable)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(myTable)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	.16
	movwf	counter
	movlw	0x10
	movwf	word_count
	goto	loop_end

wingame	
	lfsr	FSR0, end_mssg	; Load FSR0 with address in RAM	
	movlw	upper(winTable)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(winTable)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(winTable)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	.8
	movwf	counter
	movlw	0x08
	movwf 	word_count	
	goto	loop_end

loop_end
	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter		; count down to zero
	bra	loop_end	; keep going until finished	
	lfsr	FSR2, end_mssg
	goto	print	
	
print	movf	POSTINC2, W
	call	LCD_Send_Byte_D
	decfsz	word_count
	goto	print
	return	

buzzer	movlw	0x01
	movwf	PORTD
	movlw	0xf0
	call	LCD_delay_ms
	call	LCD_delay_ms
	clrf	PORTD
	return	

print_answer
	movf	POSTINC2, W
	call	write
	return
end