	    #include p18f87k22.inc
high_16	    res 1
low_16	    res	1
eight	    res	1    
temp_1	    res	1
temp_2	    res	1
temp_3	    res	1
temp_4	    res	1
temp_5	    res 1
carry	    res 1
upper_24    res 1
high_24	    res 1
low_24	    res	1
myArray	    0x40
	    
conversion  
	    movlw   low(0x418A)
	    movwf   low_16
	    movlw   high(0x418A)
	    movwf   high_16
	    movlw   0x0A
	    movwf   eight
	    
	    movf    low_16, W
	    mulwf   eight
	    movff   PRODH, temp_2
	    movff   PRODL, temp_1
	    
	    movlw   high_16
	    mulwf   eight
	    movff   PRODH, temp_4
	    movff   PRODL, temp_3
	    
	    movlw   temp_2
	    ADDWFC  temp_3, W
	    movwf   temp_5
	    bc	    add_carry
	    bra	    merge

add_carry   movlw   0x00
	    addwfc   temp_4, W
	    

merge	    lfsr    FSR1, myArray
	    movwf   TBLPTRU	
	    movff   temp_5, TBLPTRH
	    movff   temp_1, TBLPTRL
	    