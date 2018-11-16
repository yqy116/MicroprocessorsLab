#include p18f87k22.inc
	global	colour_count_seq,colour_count, comparison,count
	global	R_count,G_count,Y_count,B_count,R_count_seq,G_count_seq,Y_count_seq,B_count_seq,temp_store,myinitial
	
acs0	    udata_acs
R_count	res 1
G_count	res 1    
Y_count res 1
B_count res 1
B_count_seq res 1
R_count_seq res 1
Y_count_seq res 1
G_count_seq res 1
temp_store  res 1
acs_ovr	access_ovr	
	
match_colour code	;contain the subroutine to count the number of every colour in guess and answer
			;merged with count_run

;count the answer(initial)
colour_count_seq
	movlw	0x00	;this is for red colour
	CPFSEQ	temp_store
	goto	second_count_seq
	incf	R_count_seq, f
	return
	
second_count_seq	
	movlw	0x01	;this is for green colour
	CPFSEQ	temp_store
	goto	third_count_seq
	incf	G_count_seq, f
	return
	
third_count_seq	
	movlw	0x02	;this is for blue colour
	CPFSEQ	temp_store
	goto	fourth_count_seq
	incf	B_count_seq, f
	return	

fourth_count_seq	
	movlw	0x03	;this is for yellow colour
	CPFSEQ	temp_store
	return
	movlw	0x01
	addwf	Y_count_seq, f
	return	

;count the guess
colour_count
	movlw	0x77
	CPFSEQ	temp_store  ;this is for red colour
	goto	second_count
	incf	R_count, f
	return
	
second_count	
	movlw	0xB7
	CPFSEQ	temp_store  ;this is for green colour
	goto	third_count
	incf	G_count, f
	return
	
third_count	
	movlw	0xD7
	CPFSEQ	temp_store  ;this is for blue colour
	goto	fourth_count
	incf	B_count, f
	return	

fourth_count	
	movlw	0xE7
	CPFSEQ	temp_store
	return
	incf	Y_count, f  ;this is for yellow colour
	return	
	
	
;compare the number of colours in answer with the guess	
comparison
	movlw	0x00	
	movwf	temp_store  ;temp_store will contain the number of incorrect colour+position
	
	movf	R_count_seq, W
	CPFSLT	R_count
	subwf	R_count, W	;minus the number of red in answer with the number in guess
	CPFSLT	R_count
	addwf	temp_store, f
	
	movf	G_count_seq, W
	CPFSLT	G_count
	subwf	G_count, W	;same logic as before, but for green
	CPFSLT	G_count
	addwf	temp_store, f
	
	movf	Y_count_seq, W
	CPFSLT	Y_count
	subwf	Y_count, W	;same logic as before, but for yellow
	CPFSLT	Y_count
	addwf	temp_store, f
	
	movf	B_count_seq, W
	CPFSLT	B_count
	subwf	B_count, W	;;same logic as before, but for blue
	CPFSLT	B_count
	addwf	temp_store, f
	return	
	end
	
colour_ini	;initialise each number of colour to zero
	movlw	0x00
	movwf	R_count_seq
	movwf	G_count_seq
	movwf	Y_count_seq
	movwf	B_count_seq
;	movwf	R_count
;	movwf	G_count
;	movwf	Y_count
;	movwf	B_count
	return
	
count	lfsr    FSR2, myinitial	    ;point the fsr to the address of the answer
	call	colour_ini	    ;intiate each number of colour to zero
	movff	POSTINC2, temp_store	;first position
	call	colour_count_seq
	movff	POSTINC2, temp_store	;second position and so on
	call	colour_count_seq
	movff	POSTINC2, temp_store
	call	colour_count_seq
	movff	POSTINC2, temp_store
	call	colour_count_seq
	return
	
;	call	colour_count
;	call	colour_count
;	movff	R_count,R_count_seq
;	movff	G_count,G_count_seq
;	movff	Y_count,Y_count_seq
;	movff	B_count,B_count_seq

;trial
;	movlw	0xeb
;	CPFSEQ	tempo
;	goto	skip
;	goto	trial
;skip	call	point
;	lfsr    FSR2, myinitial
;	movlw	0x04
;	movwf	read_count
;	;will remove the write at end of game
;trial_loop	
;	call	write_ans
;	decfsz	read_count
;	goto	trial_loop
	end