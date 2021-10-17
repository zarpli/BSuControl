//  Brightsign Serial Port Control 1.0
//  Zarpli - Tecnología Interactiva
 
#define BS_SERIAL     Serial1
#define STX           0x02
#define ETX           0x03

void setup() {
    Serial.begin(115200);
    BS_SERIAL.begin(115200);

    while (!Serial);
    Serial.println("BrightSign Serial Port Control 1.0");    
    Serial.println("(type h for help)");
}

void loop() {
  handle_commands();
  status_bs();
}

void status_bs() {
    if (BS_SERIAL.available()>2)
    {
          if (BS_SERIAL.read() != STX) return;
          byte cmd = BS_SERIAL.read(); 
          if (BS_SERIAL.read() == ETX)
          {
          Serial.print("BS : ");
          if(cmd == 0x00) Serial.println("error");
          if(cmd == 0x01) Serial.println("ok");
          if(cmd == 0x02) Serial.println("online");
          if(cmd == 0x08) Serial.println("media_ended");
          }
    }   
}

void handle_commands() {
    if (Serial.available() > 0)
    {
        char cmd = Serial.read();
        switch (cmd)
        {
        case 'd':
            Serial.println("\nPLAY DEMO.MOV");
            BS_SERIAL.print("PLAY DEMO.MOV\r");
            break;

        case 's':
            Serial.println("\nSTOP");
            BS_SERIAL.print("STOP\r");
            break;

        case 'p':
            Serial.println("\nPAUSE");
            BS_SERIAL.print("PAUSE\r");
            break;

        case 'r':
            Serial.println("\nRESUME");
            BS_SERIAL.print("RESUME\r");
            break;

        case 'z':
            Serial.println("\nREBOOT");
            BS_SERIAL.print("REBOOT\r");
            break;

        case 'h':
            Serial.println("\nUsage:");
            Serial.println("d: play demo");
            Serial.println("s: stop");
            Serial.println("p: pause");
            Serial.println("r: resume");
            Serial.println("z: reboot");
            Serial.println("h: display this help");            
            break;

        default:
            break;
        }
    }
}
