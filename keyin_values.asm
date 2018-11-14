#include p18f87k22.inc
	extern	colour_count, write, LCD_Clear
	extern	myArray, counter,tempo, temp_store
	global	keyin
	
	
code
keyin	call	LCD_Clear
	movlw b'10000000' ; Set timer0 to 16-bit, Fosc/4/256
	movwf T0CON ; = 62.5KHz clock rate, approx 1sec rollover
	bsf INTCON,TMR0IE ; Enable timer0 interrupt
	bsf INTCON,GIE ; Enable all interrupts
	lfsr FSR0, myArray 
	movlw	0x04
	movwf	counter
	
loop	movlw	0xff
	CPFSEQ	tempo
	goto	answ
	goto	loop
	
answ	movlw	0xEE
	CPFSEQ	tempo
	goto	accept
	goto	keyin

accept	movf	tempo, W
	movff	tempo, temp_store
	movff	tempo, POSTINC0
	call	write
	call	colour_count
	
back	decfsz  counter
	goto	loop
	return
end