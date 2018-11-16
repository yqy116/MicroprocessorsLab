#include p18f87k22.inc
    global  game_startup,game_counter
    extern  UART_Setup,LCD_Setup,lookup
    
    
acs0	    udata_acs
game_counter	res 1
acs_ovr	access_ovr
	
initialise_game code
 
game_startup
    call UART_Setup
    call LCD_Setup
    clrf TRISD ; Set PORTD as all outputs
    clrf LATD ; Clear PORTD outputs
    clrf LATE
    clrf LATH
    ;intialise
    movlw   0x05
    movwf   game_counter
    call    lookup				;initialise the lookup table
    movlb   0
    
    return
    END