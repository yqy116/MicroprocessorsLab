#include p18f87k22.inc
	extern	counter, temp_store,tempo,myinitial
	extern	keyboard, write, LCD_delay_ms
	global	point
	
manual_input	code
	
point	movlw	.5
	call	LCD_delay_ms
;	movlw	0x77
;	movwf	tempo
	lfsr    FSR2, myinitial
	movlw	0x04
	movwf	counter
loop_test
	movlw	0xff
	CPFSEQ	tempo
	goto	E_test
	goto	loop_test

E_test
	movlw	0xeb
	CPFSEQ	tempo
	goto	answ_test
	goto	loop_test	
	
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
	goto	loop_test
	return
	end