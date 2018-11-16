#include p18f87k22.inc
	global	interrupt_setup, interrupt_1,stop_timer_2,int_ct
	extern	keyboard
;this contain all the subroutine for the on and off of interrupt and the interrupt routine
acs0	    udata_acs
int_ct	res 1	;variable to generate a pseudo random number
acs_ovr	access_ovr	
	
int_hi	code 0x0008 ; high vector, no low vector
	btfss INTCON,TMR0IF ; check that this is timer0 interrupt
	goto	 second	;go to the second timer
	movlw	.1  ;offset the frequency of timer 0
	movwf	TMR0L	
	incf	int_ct	;to create a pseudo random number
	bcf INTCON,TMR0IF ; clear interrupt flag
	retfie FAST ; fast return from interrupt

second	btfss PIR1,TMR1IF
	retfie FAST
	call	keyboard    ;allow the key apd to work
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
	bsf INTCON,PEIE ;enable peripheral clock
	return

stop_timer_1
	;stop timer0
	movlw	b'00000000'
	movwf	T0CON
	return
	
interrupt_1
	call	stop_timer_1
	;start interrupt 1
	movlw b'00000101' ; Set timer 1
	movwf T1CON 
        movlw b'00000000' ;Enable the gate for timer 1 
	movwf T1GCON 	
	bsf PIE1, TMR1IE ; Enable timer1 interrupt
	return

stop_timer_2
	;stop interupt
	movlw	b'00000000' ;close timer 1
	movwf	T1CON
	return	
	
	end