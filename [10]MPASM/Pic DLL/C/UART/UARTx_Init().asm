#include <p18f45k22.inc>
R0 EQU H'0000'                ;1 byte
R1 EQU H'0001'                ;1 byte
_UART_Wr_Ptr EQU H'0015'      ;4 byte
_UART_Tx_Idle_Ptr EQU H'0019' ;4 byte
_UART_Rdy_Ptr EQU H'001D'     ;4 byte 
_UART_Rd_Ptr EQU H'0021'      ;4 byte
FARG_UART1_Write_data_ EQU H'0025' ;1 byte - UARTx_Write(char data_);

    org		0x0000 

    goto	_main
    nop
    nop
    goto	0x00
    nop
    nop
    nop
    nop
    nop
    nop
    bra		0
    nop
    
;void UARTx_Init(const unsigned long baud_rate);
_UART1_Init:
    movlw	0xff              ;_UART1_Write
    movwf	_UART_Wr_Ptr+0, 0
    movlw	0xff              ;hi_addr(_UART1_Write)
    movwf	_UART_Wr_Ptr+1, 0    
    movlw	0xff              ;FARG_UART1_Write_data_
    movwf	_UART_Wr_Ptr+2, 0    
    movlw	0xff              ;hi_addr(FARG_UART1_Write_data_)
    movwf	_UART_Wr_Ptr+3, 0

    movlw	0xff              ;_UART1_Read
    movwf	_UART_Rd_Ptr+0, 0
    movlw	0xff              ;hi_addr(_UART1_Read)
    movwf	_UART_Rd_Ptr+1, 0    
    movlw	0x00
    movwf	_UART_Rd_Ptr+2, 0    
    movlw	0x00
    movwf	_UART_Rd_Ptr+3, 0
    
    movlw	0xff              ;_UART1_Data_Ready
    movwf	_UART_Rdy_Ptr+0, 0
    movlw	0xff              ;hi_addr(_UART1_Data_Ready)
    movwf	_UART_Rdy_Ptr+1, 0    
    movlw	0x00
    movwf	_UART_Rdy_Ptr+2, 0    
    movlw	0x00
    movwf	_UART_Rdy_Ptr+3, 0
    
    movlw	0xff              ;_UART1_Tx_Idle 
    movwf	_UART_Tx_Idle_Ptr+0, 0
    movlw	0xff              ;hi_addr(_UART1_Tx_Idle)
    movwf	_UART_Tx_Idle_Ptr+1, 0    
    movlw	0x00
    movwf	_UART_Tx_Idle_Ptr+2, 0    
    movlw	0x00
    movwf	_UART_Tx_Idle_Ptr+3, 0
    
    bsf		TXSTA1, TXEN, 0  ;Transmit Enable bit(TXEN)
    movlw	0x90                                             
    movwf	RCSTA1, 0        ;Serial Port Enable bit(SPEN)
                                 ;Continuous Receive Enable bit(CREN)
    bsf         TRISC, TRISC7, 0 ;RX
    bcf         TRISC, TRISC6, 0 ;TX

L_UART1_Init0:
    btfss       PIR1, RC1IF, 0
    bra         L_UART1_Init1
    movff       RCREG1, R0
    bra         L_UART1_Init0
L_UART1_Init1:
L_end_UART1_Init:
    return 0

;char UARTx_Data_Ready();    
_UART1_Data_Ready:
    movlw       0x00
    btfsc       PIR1, RC1IF, 0 
    movlw       0x01
    movwf       R0, 0  		
L_end_UART1_Data_Ready:
    return      0

;char UARTx_Tx_Idle();
_UART1_Tx_Idle:
    movlw       0x00
    btfsc       TXSTA1, TRMT, 0  ;Transmit Shift Register Status bit
    movlw       0x01
    movwf       R0, 0  		
L_end_UART1_Tx_Idle:
    return      0
    
;char UARTx_Read();    
_UART1_Read:		
    movff       RCREG1, R1		
    btfss       RCSTA1, OERR, 0 
    bra         L_UART1_Read0		
    bcf         RCSTA1, CREN, 0  		
    bsf         RCSTA1, CREN, 0 		
L_UART1_Read0:		
    movff       R1, R0 		
L_end_UART1_Read:
    return      0

;void UARTx_Write(char data_);    
_UART1_Write:		
L_UART1_Write0:
    btfsc       TXSTA1, TRMT, 0 
    bra         L_UART1_Write1		
    nop
    bra         L_UART1_Write0
L_UART1_Write1:		
    movff       FARG_UART1_Write_data_, TXREG1		
L_end_UART1_Write:
    return      0
    
_main:
;void main() {
;UART1_Init(9600);
    bsf         BAUDCON1, BRG16, 0
    clrf        SPBRGH1, 0 
    movlw       0xCF
    movwf       SPBRG1, 0 
    bsf         TXSTA1, BRGH, 0
    rcall       _UART1_Init
;if(UART1_Data_Ready()==1){
    rcall       _UART1_Data_Ready
    movf        R0, 0 
    xorlw       1
    bnz         L_main0
;UART1_Read();
    rcall       _UART1_Read
;}
L_main0:
;if (UART1_Tx_Idle() == 1) {
    rcall       _UART1_Tx_Idle
    movf        R0, 0 
    xorlw       1
    bnz         L_main1
;UART1_Write(0x41);
    movlw       0x41
    movwf       FARG_UART1_Write_data_ 
    rcall       _UART1_Write
;}
L_main1:
;}
L_end_main:
    bra         $+0
    
    end
    
    