	    #include p18f87k22.inc
	    
extern  LCD_Setup, LCD_Write_Message, LCD_Send_Byte_D	
global	conversion_1, merge	    
	code
	org 0x0
	goto	conversion
	
	org 0x100		    ; Main code starts here at address 0x100    
	
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
	    
conversion_1  
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
	    

merge	    movf    temp_4, W
	    call    LCD_Send_Byte_D
	    movf    temp_5, W
	    call    LCD_Send_Byte_D
	    movf    temp_1, W
	    call    LCD_Send_Byte_D
	    
	    return
	    end
;	    lfsr    FSR1, myArray
;	    movwf   TBLPTRU	
;	    movff   temp_5, TBLPTRH
;	    movff   temp_1, TBLPTRL

;multiply    movf    constant1, W
;	    mulwf   eight
;	    movff   PRODH, constant2
;	    movff   PRODL, constant3