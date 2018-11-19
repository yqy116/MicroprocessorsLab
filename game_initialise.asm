#include p18f87k22.inc
    global  game_startup,game_counter,loop1_gametry
    extern  UART_Setup,LCD_Setup,lookup
    extern  keyboard, tempo
;this code initialse the setup and game tries
acs0	    udata_acs
game_counter	res 1
hold		res 1
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
   
loop1_gametry
	call	keyboard
	movlw	0x7E
	CPFSEQ	tempo
	goto	loop2_gametry
	goto	game_counter_10
	
loop2_gametry
	movlw	0xBB
	CPFSEQ	tempo
	goto	loop1_gametry
	goto	game_counter_5
	
game_counter_5
    movlw   0x05
    movwf   game_counter
    return
    
game_counter_10
    movlw   0x0A
    movwf   game_counter
    return  
    END
