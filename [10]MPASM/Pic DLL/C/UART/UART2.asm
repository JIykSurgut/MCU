#include <p18f45k22.inc>
R0 EQU 0x0000                   ;1 byte
R1 EQU 0x0001                   ;1 byte
lstr2_UARTx_Init EQU 0x0015     ;5byte
lstr1_UARTx_Init EQU 0x001A     ;3byte - Delimiter  void UART_Read_Text(char* Output, char* Delimiter, char Attempts);
_UART_Rd_Ptr EQU 0x001D         ;4 byte - N/A
_UART_Rdy_Ptr EQU 0x0021        ;4 byte - N/A
_UART_Tx_Idle_Ptr EQU 0x0025    ;4 byte - N/A
_UART_Wr_Ptr EQU 0x0029         ;4 byte - N/A
_output EQU 0x002D              ;2 byte - Output  void UART_Read_Text(char* Output, char* Delimiter, char Attempts);
FARG_UART1_Read_Text_Output EQU 0x002F    ;2byte copy _output  
FARG_UART1_Read_Text_Delimiter EQU 0x0031 ;2byte copy lstr1_UARTx_Init
FARG_UART1_Read_Text_Attempts EQU 0x0033  ;1byte - Attempts void UART_Read_Text(char* Output, char* Delimiter, char Attempts);
UART1_Read_Text_r_data_L0 EQU 0x0034      ;1byte - read 1 byte in UART_Read_Text(...)
UART1_Read_Text_out_idx_L0 EQU 0x0035     ;1byte - N/A
UART1_Read_Text_delim_idx_L0 EQU 0x0036   ;1byte - N/A


UART1_Write_Text_data__L0 EQU H'0031' ;тест
FARG_UART1_Write_Text_uart_text EQU H'0031'
UART1_Write_Text_counter_L0 EQU H'0031'



 


FARG_UART1_Write_data_ EQU H'0025' ;1 byte - UARTx_Write(char data_);

    org		0x0000 

    goto	_main
    nop
    nop
    goto	0x00000
    nop
    nop
    nop
    nop
    nop
    nop
    bra		0x000
    nop

;void UARTx_Init(const unsigned long baud_rate)
_UART1_Init:
    movlw	0xff              ;_UART1_Write
    movwf	_UART_Wr_Ptr, ACCESS 
    movlw	0xff              ;hi_addr(_UART1_Write)
    movwf	_UART_Wr_Ptr+1, ACCESS    
    movlw	0xff              ;FARG_UART1_Write_data_
    movwf	_UART_Wr_Ptr+2, ACCESS    
    movlw	0xff              ;hi_addr(FARG_UART1_Write_data_)
    movwf	_UART_Wr_Ptr+3, ACCESS

    movlw	0xff              ;_UART1_Read
    movwf	_UART_Rd_Ptr, ACCESS
    movlw	0xff              ;hi_addr(_UART1_Read)
    movwf	_UART_Rd_Ptr+1, ACCESS    
    movlw	0x00
    movwf	_UART_Rd_Ptr+2, ACCESS    
    movlw	0x00
    movwf	_UART_Rd_Ptr+3, ACCESS
    
    movlw	0xff              ;_UART1_Data_Ready
    movwf	_UART_Rdy_Ptr, ACCESS
    movlw	0xff              ;hi_addr(_UART1_Data_Ready)
    movwf	_UART_Rdy_Ptr+1, ACCESS    
    movlw	0x00
    movwf	_UART_Rdy_Ptr+2, ACCESS    
    movlw	0x00
    movwf	_UART_Rdy_Ptr+3, ACCESS
    
    movlw	0xff              ;_UART1_Tx_Idle 
    movwf	_UART_Tx_Idle_Ptr, ACCESS
    movlw	0xff              ;hi_addr(_UART1_Tx_Idle)
    movwf	_UART_Tx_Idle_Ptr+1, ACCESS    
    movlw	0x00
    movwf	_UART_Tx_Idle_Ptr+2, ACCESS    
    movlw	0x00
    movwf	_UART_Tx_Idle_Ptr+3, ACCESS
    
    bsf		TXSTA1, TXEN, ACCESS  ;Transmit Enable bit(TXEN)
    movlw	0x90                                             
    movwf	RCSTA1, ACCESS      ;Serial Port Enable bit(SPEN)
			            ;Continuous Receive Enable bit(CREN)
    bsf         TRISC, TRISC7, ACCESS ;RX
    bcf         TRISC, TRISC6, ACCESS ;TX
L_UART1_Init0:
    btfss       PIR1, RC1IF, ACCESS
    bra         L_UART1_Init1
    movff       RCREG1, R0
    bra         L_UART1_Init0
L_UART1_Init1:
L_end_UART1_Init:
    return 0
    
;char UARTx_Data_Ready();    
_UART1_Data_Ready:
    movlw       0x00
    btfsc       PIR1, RC1IF, ACCESS 
    movlw       0x01
    movwf       R0, ACCESS  		
L_end_UART1_Data_Ready:
    return      0

;char UARTx_Tx_Idle();
_UART1_Tx_Idle:
    movlw       0x00
    btfsc       TXSTA1, TRMT, ACCESS  ;Transmit Shift Register Status bit
    movlw       0x01
    movwf       R0, ACCESS  		
L_end_UART1_Tx_Idle:
    return      0
    
;char UARTx_Read();    
_UART1_Read:		
    movff       RCREG1, R1		
    btfss       RCSTA1, OERR, ACCESS 
    bra         L_UART1_Read0		
    bcf         RCSTA1, CREN, ACCESS  		
    bsf         RCSTA1, CREN, ACCESS 		
L_UART1_Read0:		
    movff       R1, R0 		
L_end_UART1_Read:
    return      0
            
;void UARTx_Write(char data_);    
_UART1_Write:		
L_UART1_Write0:
    btfsc       TXSTA1, TRMT, ACCESS 
    bra         L_UART1_Write1		
    nop
    bra         L_UART1_Write0
L_UART1_Write1:		
    movff       FARG_UART1_Write_data_, TXREG1		
L_end_UART1_Write:
    return      0    

;void UARTx_Read_Text(char* Output, char* Delimiter, char Attempts);
_UART1_Read_Text:		
    clrf        UART1_Read_Text_out_idx_L0, ACCESS        ;UART1_Read_Text_out_idx_L0 = 0
    clrf        UART1_Read_Text_delim_idx_L0, ACCESS 	  ;UART1_Read_Text_delim_idx_L0 = 0	
L_UART1_Read_Text7:
    movf        FARG_UART1_Read_Text_Attempts, F, ACCESS  ;if(Attempts == 0) goto L_Text8
    bz          L_UART1_Read_Text8                        ;
    movf        FARG_UART1_Read_Text_Attempts, W, ACCESS  ;if(Attempts == 255) Attemps--;
    xorlw       0xFF                                      ;
    btfss       STATUS, Z  		                  ;
    decf        FARG_UART1_Read_Text_Attempts, F, ACCESS  ;
L_UART1_Read_Text9: 		
L_UART1_Read_Text10:                                      ;Text10:                   ;while(UARTx_Data_Ready() == 0){}
    rcall       _UART1_Data_Ready                         ;R0 = UARTx_Data_Ready();
    movf        R0, W, ACCESS                             ;if(R0 == 1) goto Text11; 
    xorlw       0x00                                      ;   else goto Text10;
    bnz         L_UART1_Read_Text11                       ;Text11:
    bra         L_UART1_Read_Text10                       ;
L_UART1_Read_Text11: 		
    rcall       _UART1_Read                               ;R0 = UARTx_Read();
    movff       R0, UART1_Read_Text_r_data_L0 		  ;UART1_Read_Text_r_data_L0 = R0
    movf        UART1_Read_Text_out_idx_L0, W, ACCESS     ;FSR1L = UART1_Read_Text_out_idx_L0 + FARG_UART1_Read_Text_Output ;адрес            
    addwf       FARG_UART1_Read_Text_Output, W, ACCESS    ;
    movwf       FSR1L, ACCESS                             ;
    movlw       0x00                                      ;
    addwfc      FARG_UART1_Read_Text_Output+1, W, ACCESS  ;FSR1H = 0x00 + (FARG_UART1_Read_Text_Output+1);   ;адрес 
    movwf       FSR1H, ACCESS                             ;
    movff       R0, POSTINC1                              ;&FSR = R0; FSR++;
    INCF        UART1_Read_Text_out_idx_L0, F, ACCESS     ;UART1_Read_Text_out_idx_L0++;
    MOVF        UART1_Read_Text_delim_idx_L0, W, ACCESS   ;FSR0L = UART1_Read_Text_delim_idx_L0 + FARG_UART1_Read_Text_Delimiter;
    ADDWF       FARG_UART1_Read_Text_Delimiter, W, ACCESS ;
    MOVWF       FSR0L, ACCESS                             ;
    MOVLW       0x00                                      ;
    ADDWFC      FARG_UART1_Read_Text_Delimiter+1, W, ACCESS ; 
    MOVWF       FSR0H, ACCESS                               ;
    MOVF        POSTINC0, W, ACCESS 
    XORWF       UART1_Read_Text_r_data_L0, W, ACCESS 
    BNZ         L_UART1_Read_Text12 		
    INCF        UART1_Read_Text_delim_idx_L0, F, ACCESS  		
    BRA         L_UART1_Read_Text13
L_UART1_Read_Text12: 		
    CLRF        UART1_Read_Text_delim_idx_L0 		
    MOVFF       FARG_UART1_Read_Text_Delimiter, FSR0L
    MOVFF       FARG_UART1_Read_Text_Delimiter+1, FSR0H
    MOVF        POSTINC0, W, ACCESS 
    XORWF       UART1_Read_Text_r_data_L0, W, ACCESS 
    BTFSC       STATUS, 2  		
    INCF        UART1_Read_Text_delim_idx_L0, F, ACCESS 	
L_UART1_Read_Text14:
L_UART1_Read_Text13: 		
    MOVF        UART1_Read_Text_delim_idx_L0, W, ACCESS 
    ADDWF       FARG_UART1_Read_Text_Delimiter, W, ACCESS 
    MOVWF       FSR0L 
    MOVLW       0x00
    ADDWFC      FARG_UART1_Read_Text_Delimiter+1, 0 
    MOVWF       FSR0H 
    MOVF        POSTINC0, 0 
    XORLW       0
    BNZ         L_UART1_Read_Text15 		
    MOVF        UART1_Read_Text_delim_idx_L0, 0 
    SUBWF       UART1_Read_Text_out_idx_L0, 0 
    MOVWF       R0 
    CLRF        R1 
    MOVLW       0
    SUBWFB      R1, 1 
    MOVF        R0, 0 
    ADDWF       FARG_UART1_Read_Text_Output, 0 
    MOVWF       FSR1L 
    MOVF        R1, 0 
    ADDWFC      FARG_UART1_Read_Text_Output+1, 0 
    MOVWF       FSR1H 
    CLRF        POSTINC1  		
    BRA         L_end_UART1_Read_Text 		
L_UART1_Read_Text15: 		
    BRA         L_UART1_Read_Text7
L_UART1_Read_Text8: 		
    MOVFF       FARG_UART1_Read_Text_Output+0, FSR1L
    MOVFF       FARG_UART1_Read_Text_Output+1, FSR1H
    CLRF        POSTINC1  		
L_end_UART1_Read_Text:
    RETURN      0
        
_UART1_Write_Text:
    clrf        UART1_Write_Text_counter_L0 
    movff       FARG_UART1_Write_Text_uart_text+0, FSR0L
    movff       FARG_UART1_Write_Text_uart_text+1, FSR0H
    movff       POSTINC0, UART1_Write_Text_data__L0 		
L_UART1_Write_Text5:
    movf        UART1_Write_Text_data__L0, 0 
    xorlw       0
    bz          L_UART1_Write_Text6 		
    movff       UART1_Write_Text_data__L0, FARG_UART1_Write_data_
    rcall       _UART1_Write 		
    incf        UART1_Write_Text_counter_L0, 1  		
    movf        UART1_Write_Text_counter_L0, 0 
    addwf       FARG_UART1_Write_Text_uart_text, 0 
    movwf       FSR0L 
    movlw       0x00
    addwfc      FARG_UART1_Write_Text_uart_text+1, 0 
    movwf       FSR0H 
    movff       POSTINC0, UART1_Write_Text_data__L0 		
    bra         L_UART1_Write_Text5
L_UART1_Write_Text6: 		
L_end_UART1_Write_Text:
    return      0
        
_main:
    movlw       'U'
    movwf       lstr2_UARTx_Init, ACCESS 
    movwf       'A'
    movwf       lstr2_UARTx_Init+1, ACCESS 
    movwf       'R' 
    movwf       lstr2_UARTx_Init+2, ACCESS
    movlw       'T' 
    movwf       lstr2_UARTx_Init+3, ACCESS 
    clrf        lstr2_UARTx_Init+4, ACCESS ;'NULL'
    movlw       'O'
    movwf       lstr1_UARTx_Init, ACCESS 
    movlw       'K'
    movwf       lstr1_UARTx_Init+1, ACCESS
    clrf        lstr1_UARTx_Init+2, ACCESS ;'NULL'
;void main() {
;UART1_Init(9600);
    bsf         BAUDCON1, BRG16, ACCESS ;N/A
    clrf        SPBRGH1, ACCESS 
    movlw       0xCF
    movwf       SPBRG1, ACCESS 
    bsf         TXSTA1, BRGH, ACCESS ;High Baud Rate Select bit
    rcall       _UART1_Init
;if(UART1_Data_Ready()==1){
    rcall       _UART1_Data_Ready
    movf        R0, W, ACCESS 
    xorlw       0x01
    bnz         L_main0
;UART1_Read_Text(output, "OK", 10);
    movff       _output, FARG_UART1_Read_Text_Output
    movff       _output+1, FARG_UART1_Read_Text_Output+1
    movlw       low lstr1_UARTx_Init
    movwf       FARG_UART1_Read_Text_Delimiter, ACCESS 
    movlw       high lstr1_UARTx_Init
    movwf       FARG_UART1_Read_Text_Delimiter+1, ACCESS 
    movlw       0x0A
    movwf       FARG_UART1_Read_Text_Attempts, ACCESS 
    rcall       _UART1_Read_Text
;}
L_main0:
;if (UART1_Tx_Idle() == 1) {
    rcall       _UART1_Tx_Idle
    movf        R0, W, ACCESS 
    xorlw       0x01
    bnz         L_main1
;UART1_Write_Text("UART");
    movlw       low lstr2_UARTx_Init
    movwf       FARG_UART1_Write_Text_uart_text, ACCESS 
    movlw       high lstr2_UARTx_Init
    movwf       FARG_UART1_Write_Text_uart_text+1, ACCESS 
    rcall       _UART1_Write_Text
;}
L_main1:
;}
L_end_main:
    bra         $+0

    end