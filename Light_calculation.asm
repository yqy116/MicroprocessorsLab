#include p18f87k22.inc
	global	initial, after_y, count_orange
	global	y_count,temp_res,total_light,pos_counter
	extern	LCD_Clear,LCD_delay_ms,validate,comparison,add_z
	extern	myinitial,myArray,temp_store
	
acs0	    udata_acs
y_count		res 1	;number of correct position+colour(green)
temp_res	res 1	;the number of bits set for the LED
total_light	res 1	;initally will be four but will be minus with the number of green+amber lgiht
pos_counter	res 1	;to validate all four position in guess
count_orange	res 1	;number of correct colour but wrong position(amber)
acs_ovr	access_ovr
	
validate_1  code
	
initial;All kind of initialization
	movlw	0x00
	movwf	temp_res  
	movwf	y_count
	lfsr    FSR0, myArray	;point to the guess
	lfsr    FSR2, myinitial	;point to the answer
	movlw	0x04
	movwf	pos_counter ;number of loop, four position to loop through
	movwf	total_light ;set the total number of light
	call	LCD_Clear   ;to clear the guess value that was sent before(LCD)

testtest	
	call	validate    ;to calculate the number of correct positon+colour (game logic)
	decfsz  pos_counter ;loop four times
	goto	testtest
	return
	

;second part of validate
  
after_y	call	comparison  ;to calculate the number of wrong position + wrong colour
	movf	temp_store,W ;temp_store contains the number of wrong guesses 
	addwf	y_count,W   ; add the number of correct guesses with the number of wrong guesses
	subwf	total_light, f	;total_light is the total number of guesses minus the correct&wrong guesses, it is right col + wrong pos
	movff	total_light, count_orange   
	incf	total_light ; increase by one as add_z routine start with decfsz, will cause underflow if 1 isn't added
	call	add_z
	clrf	TRISH	    ;set port H as output althought set before but just in case
	movf	temp_res, W ;debug purpose not needed actually
	movff	temp_res, PORTH ;show result
	return
	
	end
