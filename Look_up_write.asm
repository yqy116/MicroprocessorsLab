#include p18f87k22.inc
	extern	LCD_delay_ms, LCD_Send_Byte_D
	global	storage,lookup, write
;this code contain the lookup table and the translation to the colour code
acs0	    udata_acs
storage	    res 1   ;temporary store the colour
acs_ovr	access_ovr

match	code	
	
lookup
	movlb	6		    ;select bank 6
	lfsr	FSR1, 0x680	    ;point FSR1 to the middle of bank 6
	movlw	'R'		    ;load all of the ascii codes into locations +/- away from the FSR1
	movwf	storage
	movlw	0x00		    ;first possible random number
	movff	storage, PLUSW1
	
	movlw	'G'
	movwf	storage
	movlw	0x01		    ;second possible random number and so on
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
	movlw	0x77		    ;value when R is psuh in keypad
	movff	storage, PLUSW1
	
	movlw	'G'
	movwf	storage
	movlw	0xB7		    ;smilar logic
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

	
write	
	movf	PLUSW1, W	    ;translate the random number/keypad to colour
	call	LCD_Send_Byte_D	    ;once it's all retrieved, write it to the LCD
	call	LCD_delay_ms
	call	LCD_delay_ms
	return	
	
	end