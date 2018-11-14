#include p18f87k22.inc
	global	count
	extern	colour_count_seq,R_count_seq,G_count_seq,Y_count_seq,B_count_seq
	extern	temp_store,pos1,pos2,pos3,pos4

	

code
colour_ini  
	movlw	0x00
	movwf	R_count_seq
	movwf	G_count_seq
	movwf	Y_count_seq
	movwf	B_count_seq
	movwf	R_count
	movwf	G_count
	movwf	Y_count
	movwf	B_count
	return
	
count	call	colour_ini
	movff	pos1, temp_store
	call	colour_count_seq
	movff	pos2, temp_store
	call	colour_count_seq
	movff	pos3, temp_store
	call	colour_count_seq
	movff	pos4, temp_store
	call	colour_count_seq
	return
	
end