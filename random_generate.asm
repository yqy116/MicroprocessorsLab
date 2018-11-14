#include p18f87k22.inc
	global	fair,read
	global	dig_1
	extern	int_ct, LCD_delay_ms


acs0	    udata_acs
read_pos    res 1
dig_2	    res 1
dig_1	    res 1
acs_ovr	access_ovr	
	
generate    code
    
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
	
read	movff	int_ct, read_pos
	call	LCD_delay_ms
	return
	
end