#include p18f87k22.inc
	global	validate,add_z,binary_z,iter,mutiplier
	global	temp_ans,temp_scr,total_light,temp_pst,y_count,temp_res
	extern	storage
	
acs0	    udata_acs
temp_ans	res 1
temp_res	res 1
temp_scr	res 1	
total_light	res 1
exponent	res 1
temp_pst	res 1
y_count		res 1
acs_ovr	access_ovr
	
	
logic	code		

validate
	movf	POSTINC0, W	;key in answer
	movff	PLUSW1, storage
	movf	storage, W
	movwf	temp_ans	
	;call	LCD_Send_Byte_D	 ;error checking
	movf	POSTINC2, W 	;initial sequence
	movff	PLUSW1, storage
	movf	storage, W
	;call	LCD_Send_Byte_D	 ;error checking
	CPFSEQ	temp_ans
	return
	call	cor_pos	
	return

cor_pos	movlw	0x01
	movwf	temp_scr
	addwf	y_count
	movff	y_count,temp_pst
	call	iter
	movf	temp_scr, W
	addwf	temp_res
	return

add_z	decfsz	count_orange
	goto	binary_z
	return
	
binary_z 
	movlw	0x01
	movwf	temp_scr
	movff	count_orange,exponent
	movlw	0x04
	addwf	exponent,f
	movff	exponent,temp_pst
	call	iter
	movf	temp_scr, W
	addwf	temp_res, f
	goto	add_z	

;push the lights up	
iter	decf	temp_pst
	movlw	0x00
	CPFSEQ	temp_pst
	call    mutiplier	
	movlw	0x00
	CPFSEQ	temp_pst
	bra	iter
	return	
	
mutiplier   movlw   0x02
	    MULWF   temp_scr
	    movff   PRODL, temp_scr
	    return
	    
end