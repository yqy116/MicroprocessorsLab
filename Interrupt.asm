#include p18f87k22.inc
	global	interrupt_setup
	extern	int_ct,keyboard
	
int_hi	code 0x0008 ; high vector, no low vector
	btfss INTCON,TMR0IF ; check that this is timer0 interrupt
	goto	 second
	movlw	.1
	movwf	TMR0L
	incf	int_ct
	bcf INTCON,TMR0IF ; clear interrupt flag
	retfie FAST ; fast return from interrupt

second	btfss PIR1,TMR1IF
	retfie FAST
	call	keyboard
	bcf PIR1,TMR1IF ; clear interrupt flag
	retfie FAST ; fast return from interrupt	
	
interrupt code
	
interrupt_setup
	movlw b'00000100' ; Close timer 1, when repeat apparently not closed
	movwf T1CON 
	movlw b'10000000' ; Set timer0 to 16-bit, Fosc/4/256
	movwf T0CON ; = 62.5KHz clock rate, approx 1sec rollover
	bsf INTCON,TMR0IE ; Enable timer0 interrupt
	bsf INTCON,GIE ; Enable all interrupts
	bsf INTCON,PEIE 
	
	
end