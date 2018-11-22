#include p18f87k22.inc
    global  game_startup,game_counter,game_tries, enter_key
    extern  UART_Setup,LCD_Setup,lookup
    extern  keyboard, tempo
;this code initialse the setup and game tries
acs0	    udata_acs
game_counter	res 1;number of game tries
acs_ovr	access_ovr
	
initialise_game code
 
game_startup
    call UART_Setup ; function provided in microprocessors lab
    call LCD_Setup  ; function provided in microprocessors lab
    clrf TRISD ; Set PORTD as all outputs
    clrf LATD ; Clear PORTD outputs
    clrf LATE ; Clear PORTE outputs
    clrf LATH ; Clear PORTH outputs
    
    ;intialise the game parameters
    movlw   0x05
    movwf   game_counter    ;set game tries
    call    lookup	    ;initialise the lookup table
    movlb   0
    return
   
game_tries
	
	call	keyboard    ;enable keyboard to be used
	movlw	0x7E
	CPFSEQ	tempo
	goto	loop2_gametry	;if key A is not pressed goto second check
	goto	game_counter_10	;10 game tries is chosen
	
loop2_gametry
	movlw	0xBB
	CPFSEQ	tempo
	goto	game_tries	;if invalid key is pressed try again
	goto	game_counter_5	;5 game tries is chosen
	
game_counter_5
    movlw   0x05
    movwf   game_counter
    return
    
game_counter_10
    movlw   0x0A
    movwf   game_counter
    return  
    
enter_key
	call	keyboard    ;to enable keypad (keyboard)
	movlw	0xEB	    ;only when you press E the code will procede
	CPFSEQ	tempo	    ;tempo is the uncoded value of the paypad when it is pressed
	bra	enter_key	;loop until E is pressed in keypad. The keypad value won't proceed until E is pressed
	return
	
    END
