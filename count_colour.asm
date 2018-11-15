#include p18f87k22.inc
	global	temp_store,colour_count_seq,colour_count, comparison
	global	R_count,G_count,Y_count,B_count,R_count_seq,G_count_seq,Y_count_seq,B_count_seq
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
	
match_colour code	

;count the initial
colour_count_seq
	movlw	0x00
	CPFSEQ	temp_store
	goto	second_count_seq
	incf	R_count_seq, f
	return
	
second_count_seq	
	movlw	0x01
	CPFSEQ	temp_store
	goto	third_count_seq
	incf	G_count_seq, f
	return
	
third_count_seq	
	movlw	0x02
	CPFSEQ	temp_store
	goto	fourth_count_seq
	incf	B_count_seq, f
	return	

fourth_count_seq	
	movlw	0x03
	CPFSEQ	temp_store
	return
	movlw	0x01
	addwf	Y_count_seq, f
	return	

;count the guess
colour_count
	movlw	0x77
	CPFSEQ	temp_store
	goto	second_count
	incf	R_count, f
	return
	
second_count	
	movlw	0xB7
	CPFSEQ	temp_store
	goto	third_count
	incf	G_count, f
	return
	
third_count	
	movlw	0xD7
	CPFSEQ	temp_store
	goto	fourth_count
	incf	B_count, f
	return	

fourth_count	
	movlw	0xE7
	CPFSEQ	temp_store
	return
	incf	Y_count, f
	return	
	
comparison
	movlw	0x00	
	movwf	temp_store
	
	movf	R_count_seq, W
	CPFSLT	R_count
	subwf	R_count, W
	CPFSLT	R_count
	addwf	temp_store, f
	
	movf	G_count_seq, W
	CPFSLT	G_count
	subwf	G_count, W
	CPFSLT	G_count
	addwf	temp_store, f
	
	movf	Y_count_seq, W
	CPFSLT	Y_count
	subwf	Y_count, W
	CPFSLT	Y_count
	addwf	temp_store, f
	
	movf	B_count_seq, W
	CPFSLT	B_count
	subwf	B_count, W
	CPFSLT	B_count
	addwf	temp_store, f
	return	
end