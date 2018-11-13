#include p18f87k22.inc
global	fair
extern	LCD_Setup

    
acs0    udata_acs     
dig_1	res 1
dig_2	res 1
read_pos res 1
acs_ovr	access_ovr

	
	
	
read	movff	PORTD, read_pos
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
