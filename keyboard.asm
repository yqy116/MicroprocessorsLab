#include p18f87k22.inc
	global	tempo, keyboard
	
acs0	    udata_acs
adder	res 1
tempo	res 1
delay_constant	res 1
acs_ovr	access_ovr	
;this code conatin the subroutine for keyboard	
key	code	
	
keyboard	;banksel cannot be same line with a label,etc.start
	banksel PADCFG1				;enable pull-ups and all that for PORTE
	bsf	PADCFG1,RJPU,BANKED
	movlw	0xFF
	movwf	delay_constant
	;Start the row 
	movlw	0x0F				;gets the row byte
	movwf	TRISJ
	call	delay
	movwf	PORTJ
	call	delay				;underflow allows delay to happen again
	movf	PORTJ, W, ACCESS
	movwf   adder				; location to add the row data
	;Start the column			;gets the column byte
	call	delay
	movlw	0xF0
	movwf	TRISJ
	call	delay
	movwf	PORTJ
	call	delay
	movf	PORTJ, W, ACCESS		;move the column data to the W register
	iorwf	adder, W			; combine the row and column data to get one value
	movwf	tempo
	return

delay	decfsz delay_constant ; decrement until zero
	bra delay
	return
	end
