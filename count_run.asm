#include p18f87k22.inc
	global	count
	extern	colour_count_seq,R_count_seq,G_count_seq,Y_count_seq,B_count_seq
	extern	temp_store, myinitial,R_count,G_count,Y_count,B_count
	extern	colour_count

;abandoned! merge with count_colour
	code
colour_ini  
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
	
count	lfsr    FSR2, myinitial
	call	colour_ini
	movff	POSTINC2, temp_store
	call	colour_count_seq
	movff	POSTINC2, temp_store
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