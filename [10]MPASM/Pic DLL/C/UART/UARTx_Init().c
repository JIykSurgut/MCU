void main() {
UART1_Init(9600);

if(UART1_Data_Ready()==1){
   UART1_Read();
 }

if (UART1_Tx_Idle() == 1) {
   UART1_Write(0x41);
 }
}