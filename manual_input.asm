;point	lfsr    FSR2, myinitial
;	movlw	0x04
;	movwf	temp_store
;loop_test
;	movlw	0xff
;	CPFSEQ	tempo
;	goto	answ_test
;	goto	loop_test
;	
;answ_test
;	movlw	0xEE
;	CPFSEQ	tempo
;	goto	loop_3rd
;	goto	point
;	
;loop_3rd
;	call	input_ans
;	decfsz	temp_store
;	goto	loop_test
;	
;	lfsr    FSR2, myinitial
;	;will remove the write at end of game
;	movlb	0				;select bank 0 so the access bank is used again
;	movff	POSTINC2, pos1
;	movff	POSTINC2, pos2
;	movff	POSTINC2, pos3
;	movff	POSTINC2, pos4
;;	
;
;
;input_ans
;	movf	tempo, W
;	movff	tempo, POSTINC2
;	call	write
;	return