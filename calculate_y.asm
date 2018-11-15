#include p18f87k22.inc
	global	initial
	global	y_count,temp_res,total_light,pos_counter
	extern	LCD_Clear,LCD_delay_ms,validate,myinitial,myArray
	
acs0	    udata_acs
y_count		res 1	 
temp_res	res 1
total_light	res 1
pos_counter	res 1
acs_ovr	access_ovr
	
	
initial;All kind of initialization
	movlw	0x00
	movwf	temp_res
	movwf	y_count
	lfsr    FSR0, myArray 
	lfsr    FSR2, myinitial
	movlw	0x04
	movwf	pos_counter ;number of loop
	movwf	total_light
	call	LCD_Clear
	movlw	.5	    ;Need some time before it clear
	call	LCD_delay_ms

testtest	
	call	validate
	decfsz  pos_counter 
	goto	testtest
	return
	
end