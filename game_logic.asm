#include p18f87k22.inc
	global	validate,add_z,binary_z,iter,mutiplier
	global	temp_ans,temp_scr,temp_pst
	extern	storage, y_count, temp_res, total_light
	
;contain the logic to set the led light for green and amber	
acs0	    udata_acs
temp_ans	res 1	;temporary plave to store the translated guess
temp_scr	res 1	;store a single bit of the result (1st bit for 1st correct,2nd bit for 2nd correct...)
exponent	res 1	;the power of 2 the bit should be set
temp_pst	res 1	;a variable used to push the light up
acs_ovr	access_ovr
	
	
logic	code		

validate    ;fsr0 for guess, fsr2 for answer
	movf	POSTINC0, W	;transfer the guess to W
	movff	PLUSW1, storage	;translate the guess to colour code
	movf	storage, W
	movwf	temp_ans	;move the translate guess to a temporary place
	;call	LCD_Send_Byte_D	 ;error checking
	movf	POSTINC2, W 	;initial sequence
	movff	PLUSW1, storage
	movf	storage, W
	;call	LCD_Send_Byte_D	 ;error checking
	CPFSEQ	temp_ans    ;if correct means correct position and colour
	return
	call	cor_pos	
	return

cor_pos	movlw	0x01	    
	movwf	temp_scr    ;for later use to light up the led
	addwf	y_count ;add the number of correct pos+colour by 1
	movff	y_count,temp_pst  ;number of y_count also meant the position it must be, 1 for 1 bit set,2 for second bit set
	call	iter
	movf	temp_scr, W ;temp_score now contain 0000 0001 or 0000 0010 and so on
	addwf	temp_res    ;add the result to form 0000 0011 and so on 
	return

add_z	decfsz	total_light ;to set the led colour for correct colour but wrong position
	goto	binary_z
	return
	
binary_z    ;to set the led colour for correct colour but wrong position
	movlw	0x01
	movwf	temp_scr
	movff	total_light,exponent
	movlw	0x04
	addwf	exponent,f  ;the first four bit rreserved for the correct pos+colour
	movff	exponent,temp_pst   ;number of exponent meant the position it must be, 5 for fifth bit set,6 for the sixth bit set
	call	iter
	movf	temp_scr, W ;temp_score now contain 0001 0000 or 0010 0000 and so on
	addwf	temp_res, f ;add the result to form 0011 0000 and so on
	goto	add_z	

;push the lights up, can use shift but didn't knwo at that time	
iter	decf	temp_pst    ;push the value up depending on the number in y_count
	movlw	0x00
	CPFSEQ	temp_pst
	call    mutiplier	
	movlw	0x00
	CPFSEQ	temp_pst
	bra	iter
	return	
	
mutiplier   movlw   0x02    ;because t is a binary so mutiply by 2
	    MULWF   temp_scr
	    movff   PRODL, temp_scr ;this is the value to be set
	    return
	    
	    end