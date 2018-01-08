
__Glcd_Strobe:

;UARTx_Init.c,18 :: 		void _Glcd_Strobe(){
;UARTx_Init.c,19 :: 		Delay_10us();
	CALL        _Delay_10us+0, 0
;UARTx_Init.c,20 :: 		GLCD_EN = 1;
	BSF         RB4_bit+0, BitPos(RB4_bit+0) 
;UARTx_Init.c,21 :: 		Delay_10us();
	CALL        _Delay_10us+0, 0
;UARTx_Init.c,22 :: 		GLCD_EN = 0;
	BCF         RB4_bit+0, BitPos(RB4_bit+0) 
;UARTx_Init.c,23 :: 		}
L_end__Glcd_Strobe:
	RETURN      0
; end of __Glcd_Strobe

__Glcd_Init:

;UARTx_Init.c,25 :: 		void _Glcd_Init(){
;UARTx_Init.c,29 :: 		GLCD_RST_Direction = 0;
	BCF         TRISB5_bit+0, BitPos(TRISB5_bit+0) 
;UARTx_Init.c,30 :: 		GLCD_CS1_Direction = 0;
	BCF         TRISB0_bit+0, BitPos(TRISB0_bit+0) 
;UARTx_Init.c,31 :: 		GLCD_CS2_Direction = 0;
	BCF         TRISB1_bit+0, BitPos(TRISB1_bit+0) 
;UARTx_Init.c,32 :: 		GLCD_RST = 0;
	BCF         RB5_bit+0, BitPos(RB5_bit+0) 
;UARTx_Init.c,33 :: 		TRISD = 0x00;
	CLRF        TRISD+0 
;UARTx_Init.c,34 :: 		GLCD_RS = 0;
	BCF         RB2_bit+0, BitPos(RB2_bit+0) 
;UARTx_Init.c,35 :: 		GLCD_RW = 0;
	BCF         RB3_bit+0, BitPos(RB3_bit+0) 
;UARTx_Init.c,36 :: 		GLCD_CS1 = 0;
	BCF         RB0_bit+0, BitPos(RB0_bit+0) 
;UARTx_Init.c,37 :: 		GLCD_CS2 = 1;
	BSF         RB1_bit+0, BitPos(RB1_bit+0) 
;UARTx_Init.c,38 :: 		GLCD_RST = 1;
	BSF         RB5_bit+0, BitPos(RB5_bit+0) 
;UARTx_Init.c,39 :: 		GLCD_DataPort = 0x3F;
	MOVLW       63
	MOVWF       PORTD+0 
;UARTx_Init.c,40 :: 		_Glcd_Strobe();
	CALL        __Glcd_Strobe+0, 0
;UARTx_Init.c,41 :: 		GLCD_DataPort = 0xC0;
	MOVLW       192
	MOVWF       PORTD+0 
;UARTx_Init.c,42 :: 		_Glcd_Strobe();
	CALL        __Glcd_Strobe+0, 0
;UARTx_Init.c,43 :: 		GLCD_CS1 = 1;
	BSF         RB0_bit+0, BitPos(RB0_bit+0) 
;UARTx_Init.c,44 :: 		GLCD_CS2 = 0;
	BCF         RB1_bit+0, BitPos(RB1_bit+0) 
;UARTx_Init.c,45 :: 		GLCD_DataPort = 0x3F;
	MOVLW       63
	MOVWF       PORTD+0 
;UARTx_Init.c,46 :: 		_Glcd_Strobe();
	CALL        __Glcd_Strobe+0, 0
;UARTx_Init.c,47 :: 		GLCD_DataPort = 0xC0;
	MOVLW       192
	MOVWF       PORTD+0 
;UARTx_Init.c,48 :: 		_Glcd_Strobe();
	CALL        __Glcd_Strobe+0, 0
;UARTx_Init.c,49 :: 		}
L_end__Glcd_Init:
	RETURN      0
; end of __Glcd_Init

_main:

;UARTx_Init.c,55 :: 		void main() {
;UARTx_Init.c,56 :: 		UART1_Init(115200);
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       16
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;UARTx_Init.c,57 :: 		Glcd_Init();
	CALL        _Glcd_Init+0, 0
;UARTx_Init.c,58 :: 		Glcd_Set_Page(0);
	CLRF        FARG_Glcd_Set_Page_page+0 
	CALL        _Glcd_Set_Page+0, 0
;UARTx_Init.c,59 :: 		Glcd_Set_Side(0);
	CLRF        FARG_Glcd_Set_Side_x_pos+0 
	CALL        _Glcd_Set_Side+0, 0
;UARTx_Init.c,60 :: 		Glcd_Set_X(0);
	CLRF        FARG_Glcd_Set_X_x_pos+0 
	CALL        _Glcd_Set_X+0, 0
;UARTx_Init.c,61 :: 		UART1_Write_Text(&data_);
	MOVLW       _data_+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_data_+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;UARTx_Init.c,63 :: 		Glcd_Write_Data(UART1_Read());
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Glcd_Write_Data_ddata+0 
	CALL        _Glcd_Write_Data+0, 0
;UARTx_Init.c,65 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
