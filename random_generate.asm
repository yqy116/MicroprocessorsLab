#include p18f87k22.inc
	global	read, generate
	extern	int_ct, LCD_delay_ms,myinitial
;this contain all the code to generate the random colour(untranslated)
acs0	    udata_acs
read_pos    res 1   ;variable to take the value from int_ct
dig_2	    res 1   ;second digit of the random number
dig_1	    res 1   ;first digit of the random number
acs_ovr	access_ovr	
	
generate    code
    
fair	call	read	;move the int_ct into read_pos
	movff	read_pos, dig_2	;move to the second bit of the random binary number
	call	read
	movff	read_pos, dig_1	;move to first bit
	movlw	0x01	    ;mask and left with the 1st bit
	ANDWF	dig_2, f    
	ANDWF	dig_1, f
	RLNCF	dig_2, W    ;move the 2nd digit up by a bit
;	movlw	0x02	    ;alternative emthod using multiply
;	MULWF	dig_2, W
;	movf	PRODL, W
	ADDWF	dig_1, f    ;add digit 1 with digit 2
	return
	
read	movff	int_ct, read_pos
	movlw	.5
	call	LCD_delay_ms	;delay to ensure int_ct increase during this duration
	return

generate	;move the random generated binary number into  myinitial
	lfsr    FSR2, myinitial
	call	fair
	movff	dig_1, POSTINC2
	call	fair
	movff	dig_1, POSTINC2
	call	fair
	movff	dig_1, POSTINC2
	call	fair
	movff	dig_1, POSTINC2
	return

	end