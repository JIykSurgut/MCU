// glcd pinout settings
char GLCD_DataPort at PORTD;

sbit GLCD_CS1 at RB0_bit;
sbit GLCD_CS2 at RB1_bit;
sbit GLCD_RS  at RB2_bit;
sbit GLCD_RW  at RB3_bit;
sbit GLCD_EN at RB4_bit;
sbit GLCD_RST at RB5_bit;

sbit GLCD_CS1_Direction at TRISB0_bit;
sbit GLCD_CS2_Direction at TRISB1_bit;
sbit GLCD_RS_Direction at TRISB2_bit;
sbit GLCD_RW_Direction at TRISB3_bit;
sbit GLCD_EN_Direction at TRISB4_bit;
sbit GLCD_RST_Direction at TRISB5_bit;

void _Glcd_Strobe(){
  Delay_10us();
  GLCD_EN = 1;
  Delay_10us();
  GLCD_EN = 0;
}

void _Glcd_Init(){
//
//
//
  GLCD_RST_Direction = 0;
  GLCD_CS1_Direction = 0;
  GLCD_CS2_Direction = 0;
  GLCD_RST = 0;
  TRISD = 0x00;
  GLCD_RS = 0;
  GLCD_RW = 0;
  GLCD_CS1 = 0;
  GLCD_CS2 = 1;
  GLCD_RST = 1;
  GLCD_DataPort = 0x3F;
  _Glcd_Strobe();
  GLCD_DataPort = 0xC0;
  _Glcd_Strobe();
  GLCD_CS1 = 1;
  GLCD_CS2 = 0;
  GLCD_DataPort = 0x3F;
  _Glcd_Strobe();
  GLCD_DataPort = 0xC0;
  _Glcd_Strobe();
}

//ANSEL = 0;
//ANSELH = 0;

char data_[5] = {'O','K',0x0D,0x0A,0x00};
void main() {
UART1_Init(115200);
Glcd_Init();
Glcd_Set_Page(0);
Glcd_Set_Side(0);
Glcd_Set_X(0);
UART1_Write_Text(&data_);

Glcd_Write_Data(UART1_Read());

}

