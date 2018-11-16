#include p18f87k22.inc
	global	count
	extern	colour_count_seq,R_count_seq,G_count_seq,Y_count_seq,B_count_seq
	extern	temp_store, myinitial

	

	code
colour_ini  
	movlw	0x00
	movwf	R_count_seq
	movwf	G_count_seq
	movwf	Y_count_seq
	movwf	B_count_seq

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
	
	end