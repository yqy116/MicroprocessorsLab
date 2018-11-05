#include p18f87k22.inc

    global  LCD_Setup, LCD_Write_Message, LCD_Write_Hex, LCD_Send_Byte_D ,calculation, LCD_delay_ms
    

acs0    udata_acs   ; named variables in access ram
LCD_cnt_l   res 1   ; reserve 1 byte for variable LCD_cnt_l
LCD_cnt_h   res 1   ; reserve 1 byte for variable LCD_cnt_h
LCD_cnt_ms  res 1   ; reserve 1 byte for ms counter
LCD_tmp	    res 1   ; reserve 1 byte for temporary use
LCD_counter res 1   ; reserve 1 byte for counting through nessage
high_16	    res 1
low_16	    res	1
eight	    res	1    
temp_1	    res	1
temp_2	    res	1
temp_3	    res	1
temp_4	    res	1
temp_5	    res 1
carry	    res 1
bigthing    res 1
multiplier  res 1
lowbit	    res 1
highbit	    res 1
ans_1	    res 1
ans_2	    res 1
ans_3	    res 1
ans_4	    res 1
ans_5	    res 1
ans_6	    res 1

acs_ovr	access_ovr
LCD_hex_tmp res 1   ; reserve 1 byte for variable LCD_hex_tmp	

	constant    LCD_E=5	; LCD enable bit
    	constant    LCD_RS=4	; LCD register select bit

LCD	code
    
LCD_Setup
	clrf    LATB
	movlw   b'11000000'	    ; RB0:5 all outputs
	movwf	TRISB
	movlw   .40
	call	LCD_delay_ms	; wait 40ms for LCD to start up properly
	movlw	b'00110000'	; Function set 4-bit
	call	LCD_Send_Nib
	movlw	.10		; wait 40us
	call	LCD_delay_x4us
	movlw	b'00101000'	; 2 line display 5x8 dot characters
	call	LCD_Send_Byte_I
	movlw	.10		; wait 40us
	call	LCD_delay_x4us
	movlw	b'00101000'	; repeat, 2 line display 5x8 dot characters
	call	LCD_Send_Byte_I
	movlw	.10		; wait 40us
	call	LCD_delay_x4us
	movlw	b'00001111'	; display on, cursor on, blinking on
	call	LCD_Send_Byte_I
	movlw	.10		; wait 40us
	call	LCD_delay_x4us
	movlw	b'00000001'	; display clear
	call	LCD_Send_Byte_I
	movlw	.2		; wait 2ms
	call	LCD_delay_ms
	movlw	b'00000110'	; entry mode incr by 1 no shift
	call	LCD_Send_Byte_I
	movlw	.10		; wait 40us
	call	LCD_delay_x4us
	return

LCD_Write_Hex	    ; Writes byte stored in W as hex
	movwf	LCD_hex_tmp
	swapf	LCD_hex_tmp,W	; high nibble first
	call	LCD_Hex_Nib
	movf	LCD_hex_tmp,W	; then low nibble
LCD_Hex_Nib	    ; writes low nibble as hex character
	andlw	0x0F
	movwf	LCD_tmp
	movlw	0x0A
	cpfslt	LCD_tmp
	addlw	0x07	; number is greater than 9 
	addlw	0x26
	addwf	LCD_tmp,W
	call	LCD_Send_Byte_D ; write out ascii
	return
	
LCD_Write_Message	    ; Message stored at FSR2, length stored in W
	movwf   LCD_counter
LCD_Loop_message
	movf    POSTINC2, W
	call    LCD_Send_Byte_D
	decfsz  LCD_counter
	bra	LCD_Loop_message
	return

LCD_Send_Byte_I		    ; Transmits byte stored in W to instruction reg
	movwf   LCD_tmp
	swapf   LCD_tmp,W   ; swap nibbles, high nibble goes first
	andlw   0x0f	    ; select just low nibble
	movwf   LATB	    ; output data bits to LCD
	bcf	LATB, LCD_RS	; Instruction write clear RS bit
	call    LCD_Enable  ; Pulse enable Bit 
LCD_Send_Nib
	movf	LCD_tmp,W   ; swap nibbles, now do low nibble
	andlw   0x0f	    ; select just low nibble
	movwf   LATB	    ; output data bits to LCD
	bcf	LATB, LCD_RS    ; Instruction write clear RS bit
        call    LCD_Enable  ; Pulse enable Bit 
	return

LCD_Send_Byte_D		    ; Transmits byte stored in W to data reg
	movwf   LCD_tmp
	swapf   LCD_tmp,W   ; swap nibbles, high nibble goes first
	andlw   0x0f	    ; select just low nibble
	movwf   LATB	    ; output data bits to LCD
	bsf	LATB, LCD_RS	; Data write set RS bit
	call    LCD_Enable  ; Pulse enable Bit 
	movf	LCD_tmp,W   ; swap nibbles, now do low nibble
	andlw   0x0f	    ; select just low nibble
	movwf   LATB	    ; output data bits to LCD
	bsf	LATB, LCD_RS    ; Data write set RS bit	    
        call    LCD_Enable  ; Pulse enable Bit 
	movlw	.10	    ; delay 40us
	call	LCD_delay_x4us
	return

LCD_Enable	    ; pulse enable bit LCD_E for 500ns
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bsf	    LATB, LCD_E	    ; Take enable high
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bcf	    LATB, LCD_E	    ; Writes data to LCD
	return
    
; ** a few delay routines below here as LCD timing can be quite critical ****
LCD_delay_ms		    ; delay given in ms in W
	movwf	LCD_cnt_ms
lcdlp2	movlw	.250	    ; 1 ms delay
	call	LCD_delay_x4us	
	decfsz	LCD_cnt_ms
	bra	lcdlp2
	return
    
LCD_delay_x4us		    ; delay given in chunks of 4 microsecond in W
	movwf	LCD_cnt_l   ; now need to multiply by 16
	swapf   LCD_cnt_l,F ; swap nibbles
	movlw	0x0f	    
	andwf	LCD_cnt_l,W ; move low nibble to W
	movwf	LCD_cnt_h   ; then to LCD_cnt_h
	movlw	0xf0	    
	andwf	LCD_cnt_l,F ; keep high nibble in LCD_cnt_l
	call	LCD_delay
	return

LCD_delay			; delay routine	4 instruction loop == 250ns	    
	movlw 	0x00		; W=0
lcdlp1	decf 	LCD_cnt_l,F	; no carry when 0x00 -> 0xff
	subwfb 	LCD_cnt_h,F	; no carry when 0x00 -> 0xff
	bc 	lcdlp1		; carry, then loop again
	return			; carry reset so return
	

calculation movlw   low(0x04D2)
	    movwf   low_16   
	    movlw   high(0x04D2)
	    movwf   high_16  
	    movlw   0x8A
	    movwf   eight
	    call    conversion_1
	    movff   temp_4, ans_1
	    movff   temp_5, ans_2
	    movff   temp_1, ans_3	
	    movlw   0x41
	    movwf   eight
	    call    conversion_1
	    movff   temp_4, ans_4
	    movff   temp_5, ans_5
	    movff   temp_1, ans_6	

	    movf    ans_2, W
	    ADDWFC  ans_4, W
	    movwf   ans_2
	    
	    movf    ans_3, W
	    ADDWFC  ans_5, W
	    movwf   ans_3
	    
	    
	    movlw   0x00
	    addwfc  ans_6, W
	    movwf   ans_6
	    
	    movf    ans_1, W
	    movwf   0x30
	    movf    ans_2, W
	    movwf   0x31
	    movf    ans_3, W
	    movwf   0x32
	    movf    ans_6, W
	    movwf   0x33
	    
conversion_1  

	    movff   eight, multiplier
	    movff   low_16, bigthing
	    call    multiply
	    movff   highbit, temp_2
	    movff   lowbit, temp_1
	   

	    movff   high_16, bigthing
	    call    multiply
	    movff   highbit, temp_4
	    movff   lowbit, temp_3
	    
	    
	    movf    temp_2, W
	    ADDWFC  temp_3, W
	    movwf   temp_5
	    bc	    add_carry
	    bra	    merge
	    return
	    
add_carry   movlw   0x00
	    addwfc  temp_4, W
	    

merge	    movf    temp_4, W
	    movwf   0x30
	    ;call    LCD_Send_Byte_D
	    movf    temp_5, W
	    movwf   0x31
	    ;call    LCD_Send_Byte_D
	    movf    temp_1, W
	    movwf   0x32
;	    movf    temp_2, W
;	    movwf   0x33
;	    movf    temp_3, W
;	    movwf   0x34
	    
	    return
	    
	    ;call    LCD_Send_Byte_D
multiply    movf    bigthing, W
	    mulwf   multiplier
	    movff   PRODH, highbit
	    movff   PRODL, lowbit	    
	    return  	    	    
	    end


