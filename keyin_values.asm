#include p18f87k22.inc
	extern	colour_count, write, LCD_Clear, keyboard
	extern	myArray,tempo, temp_store, R_count, G_count, Y_count, B_count
	global	keyin, counter
;this contain the subroutine to write adn store the guess
acs0	    udata_acs
counter	    res 1   ;variable to count the number of guess keyed in
acs_ovr	access_ovr
	
	
	code
keyin	call	LCD_Clear   ;clear the lcd so that previous guess is cleared
	lfsr FSR0, myArray ;point FSR0 to myarray which store the guess
;	movlw b'10000000' ; Set timer0 to 16-bit, Fosc/4/256	;shoudnt be needed
;	movwf T0CON ; = 62.5KHz clock rate, approx 1sec rollover
;	bsf INTCON,TMR0IE ; Enable timer0 interrupt
;	bsf INTCON,GIE ; Enable all interrupts
	movlw	0x04	    ;four guesses
	movwf	counter
	movlw	0x00	    ;initialise the colour count for subroutine colour_count below
	movwf	R_count
	movwf	G_count
	movwf	Y_count
	movwf	B_count
	
	
loop	;call keyboard	
	movlw	0xFF
	CPFSEQ	tempo
	goto	answ
	goto	loop
	
	
;or maybe this one is better as it has less options?;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;this one only let's you proceed if you've pressed the correct button otherwise it keeps on looping

loop1	movlw	0x77
	CPFSEQ	tempo
	goto	loop2
	goto	answ
	
loop2	movlw	0xB7
	CPFSEQ	tempo
	goto	loop3
	goto	answ

loop3	movlw	0xD7
	CPFSEQ	tempo
	goto	loop4
	goto	answ
	
loop4	movlw	0xE7
	CPFSEQ	tempo
	goto	loop5
	goto	answ
	
	
loop5	movlw	0xEE
	CPFSEQ	tempo
	goto	loop1
	goto	answ

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
;hi you can comment all of this out if it doesn't work;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
loop1	movlw	0xff	    ;ensure that when no key is pressed(ff) go back to loop
	CPFSEQ	tempo	    ;check if key is pressed in keypad
	goto	loop2
	bra	loop1
	
loop2	movlw	0x7B	    ;ensure that when invalid key pressed(7B) go back to loop1 (no keys pressed)
	CPFSEQ	tempo	    ;check if invalid key is pressed in keypad
	goto	loop3
	goto 	loop1
	
loop3	movlw	0xBB	  ;invalid key  
	CPFSEQ	tempo	    
	goto	loop4
	goto	loop1
	
loop4	movlw	0xDB	   ;invalid key
	CPFSEQ	tempo	    
	goto	loop5
	goto 	loop1
	
loop5	movlw	0x7D	    ;invalid key
	CPFSEQ	tempo	    
	goto	loop6
	goto	loop1
	
loop6	movlw	0xBD	    ;invalid key
	CPFSEQ	tempo	    
	goto	loop7
	goto	loop1
	
loop7	movlw	0xDD	    ;invalid key
	CPFSEQ	tempo	    
	goto	loop8
	goto	loop1

loop8	movlw	0xED	    ;invalid key
	CPFSEQ	tempo	    
	goto	loop9
	goto	loop1
	
loop9	movlw	0xEB	   ;invalid key 
	CPFSEQ	tempo	    
	goto	loopA
	goto	loop1
	
loopA	movlw	0x7E	    ;invalid key
	CPFSEQ	tempo	    
	goto	loopB
	goto	loop1
	
loopB	movlw	0xBE	    ;invalid key
	CPFSEQ	tempo	    
	goto	loopC
	goto	loop1

loopC	movlw	0xDE		;invalid key
	CPFSEQ	tempo
	goto 	answ		;all invalid keys have now been checked, if no invalid keys have been pressed, can now proceed to answ
	goto	loop1

;end of changes;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	
answ	movlw	0xEE	;If c is pressed, redo the myarray again
	CPFSEQ	tempo	;check if e is pressed in keypad
	goto	accept
	goto	keyin

accept	movf	tempo, W    ;move the key pressed into W 
	movff	tempo, temp_store ;this is needed to count the colour
	movwf	POSTINC0    ;store the value to myarray
	call	write	    ;write and translate the key press into colour code (look_up_write)
	call	colour_count	;count the number of each colour in the guess (count_colour)
	
back	decfsz  counter	    ;decrease the count of guess until it reach 4
	goto	loop
	return
	end

;checker	movlw	0x52
;	CPFSEQ	tempo
;	goto	loop
;	movlw	0x47
;	CPFSEQ	tempo
;	movlw	0x42
;	CPFSEQ	tempo
;	movlw	0x59
;	CPFSEQ	tempo
	return
