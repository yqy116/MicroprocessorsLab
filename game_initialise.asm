#include p18f87k22.inc
    global  game_startup,game_counter
    extern  UART_Setup,LCD_Setup,lookup
    extern  keyboard, tempo
;this code initialse the setup and game tries
acs0	    udata_acs
game_counter	res 1
hold		res 1
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
    movwf   game_counter    ;set game tries
    call    lookup	    ;initialise the lookup table
    movlb   0
    return
   
    
;checker
;    call    keyboard
;    movlw	0xFF
;    CPFSLT	tempo
;    bra	checker	
;    movlw   0x00
;    movwf   hold
;    call keyboard
;    movlw   0x7B
;    cpfseq  tempo
;    movlw   0xBB
;    cpfseq  tempo
;    movlw   0x00
;    movf    tempo, W
;    addwf   hold
;    call    selecter
;    return
;    
; selecter
;    call keyboard
;    movlw   0x7B
;    cpfseq  hold
;    call    game_counter_4
;    cpfseq  hold
;    return
;    call    game_counter_5   
;    return
    
    
    
;checker	
;    call    keyboard
;    movlw   0x7B
;    CPFSEQ  tempo
;    goto    checker
;    call    
;;    movlw   0xBB
;;    CPFSEQ  tempo
;;    goto    checker
;    
;key_in_game_counter   
;    movlw   0x7B
;    CPFSEQ  tempo
;    call    game_counter_5
;    CPFSEQ  tempo
;    goto    key_in_game_counter
;    movlw   0xBB
;    CPFSEQ  tempo
;    call    game_counter_4
;    CPFSEQ  tempo
;    goto    key_in_game_counter
;    return
;  
game_counter_5
    movlw   0x05
    movwf   game_counter
    return
    
game_counter_4
    movlw   0x04
    movwf   game_counter
    return  
    
    END