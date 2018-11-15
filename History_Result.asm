#include p18f87k22.inc

    extern	storage, y_count, count_orange, UART_Transmit_Byte,temp_store
    global	UART_loop
	
	
history	code

UART_loop
	call	restart
	decfsz	temp_store
	goto	UART_loop	
	call	result
	return
restart	
	movf    POSTINC2, W
	movff	PLUSW1, storage
	movf	storage, W
	call    UART_Transmit_Byte
	return	

result	movlw	' '
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
	movlw	'Y'
	call    UART_Transmit_Byte
	movlw	','
	call    UART_Transmit_Byte
	return
	
end