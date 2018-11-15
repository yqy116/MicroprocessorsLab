#include p18f87k22.inc
	global	initial, after_y, count_orange
	global	y_count,temp_res,total_light,pos_counter
	extern	LCD_Clear,LCD_delay_ms,validate,comparison,add_z
	extern	myinitial,myArray,temp_store
	
acs0	    udata_acs
y_count		res 1	 
temp_res	res 1
total_light	res 1
pos_counter	res 1
count_orange	res 1
acs_ovr	access_ovr
	
validate_1  code
	
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
	

;second part of validate
  
after_y	call	comparison
	movf	temp_store,W ;temp_store contain number of the yellow light
	addwf	y_count,W
	subwf	total_light, f
	movff	total_light, count_orange
	incf	total_light
	call	add_z
	clrf	TRISH	
	movf	temp_res, W
	movff	temp_res, PORTH ;show result
	return
	
end