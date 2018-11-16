#include p18f87k22.inc

    extern	storage, y_count, count_orange, UART_Transmit_Byte,temp_store
    global	UART_loop
	
;this code contain all the code to send the attempts and result to UART	
history	code

UART_loop
	call	restart
	decfsz	temp_store  ;loop four times to send all foru guess
	goto	UART_loop
	call	result
	return
restart	
	movf    POSTINC2, W	;as fsr2 contain untranslated guess need to be translted before send to UART
	movff	PLUSW1, storage
	movf	storage, W
	call    UART_Transmit_Byte
	return	

result	movlw	' '	;show result, how many green/amber
	call    UART_Transmit_Byte
	movf	y_count,W
	addlw	0x30
	call    UART_Transmit_Byte
	movlw	'G'
	call    UART_Transmit_Byte
	movf	y_count,w
	movf	count_orange, W
	addlw	0x30
	call    UART_Transmit_Byte
	movlw	'A'
	call    UART_Transmit_Byte
	movlw	','
	call    UART_Transmit_Byte
	movlw	'\n'
	call    UART_Transmit_Byte
	return
	
	end