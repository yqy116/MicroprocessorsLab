#include p18f87k22.inc
	extern	counter, temp_store,tempo,myinitial
	extern	interrupt_1, write, LCD_delay_ms
	global	point
	
manual_input	code
	
point	call	interrupt_1
	movlw	.5
	call	LCD_delay_ms
;	movlw	0x77
;	movwf	tempo
	lfsr    FSR2, myinitial
	movlw	0x04
	movwf	counter
;loop_test
;	movlw	0xff
;	CPFSEQ	tempo
;	goto	E_test
;	goto	loop_test

loop1_manual
	movlw	0x77
	CPFSEQ	tempo
	goto	loop2_manual
	goto	E_test
	
loop2_manual	
	movlw	0xB7
	CPFSEQ	tempo
	goto	loop3_manual
	goto	E_test

loop3_manual	
	movlw	0xD7
	CPFSEQ	tempo
	goto	loop4_manual
	goto	E_test
	
loop4_manual
	movlw	0xE7
	CPFSEQ	tempo
	goto	loop5_manual
	goto	E_test
	
	
loop5_manual
	movlw	0xEE
	CPFSEQ	tempo
	goto	loop1_manual
	goto	E_test
	
E_test
	movlw	0xeb
	CPFSEQ	tempo
	goto	answ_test
	goto	loop1_manual	
	
answ_test
	movlw	0xEE
	CPFSEQ	tempo
	goto	loop_3rd
	goto	point
	
loop_3rd
	movf	tempo, W
	movff	tempo, temp_store
	movwf	POSTINC2
	call	write
	decfsz  counter
	goto	loop1_manual
	return
	end