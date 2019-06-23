
#include <Wire.h>

// This is ATmega328P specific implementation!

enum { // REMEMBER TO CHANGE THIS BEFORE PROGRAMMING!  0..4
  BoardSelector = 0
};

const uint8_t     I2CSlaveAddresses[5] = { 0x04, 0x05, 0x06, 0x07, 0x08 };      
const uint8_t     I2CSlaveAddress = I2CSlaveAddresses[BoardSelector];    
const bool        I2CMode = true;

volatile bool     demoMode = true;             // Starts in Demo mode where Timer2 interrupt will automatically increment the gauge values

//  PwmScaler   Resolution    Frequency    Notes
//   2          8             2 MHz        Too fast, doesn't generate valid PWM
//   3         16             1 MHz        
//   4         32           500 kHz        
//   5         64           250 kHz        
//   6        128           125 kHz        
//   7        256            63 kHz        
//   8        512            31 kHz         
//   9        1Ki            16 kHz        ? Test and add comments here
//  10        2Ki          7812 Hz
//  11        4Ki          3906 Hz         ? Too much jitter?
//  12        8Ki          1953 Hz         
//  13       16Ki           976 Hz         ? 
//  14       32Ki           488 Hz         
//  15       64Ki           244 Hz         
const uint8_t    PwmScaler = 11;        // 2..15
const uint16_t   PwmPulseWidth = uint16_t(1) << PwmScaler;
const uint16_t   PwmPulseMask2 = PwmPulseWidth*2 - 1;        

const float sineGamma = 0.9f;      // 0.9 .. 1.0 .. 1.1 ?


const int GaugeCount = 8;
// The actual gauge values. As bytes they can be read or write with interrups enabled. For read-modify-write disable interrupts!
volatile uint8_t gaugeValue[GaugeCount] = { 0 };      // angle = 0..255

// This takes 1024 bytes of RAM
uint16_t  sin256Table[256] = { 0 };

const uint8_t PortMaskD = I2CMode ? B11111111 : B11111100;
const uint8_t PortMaskB = B00001111;
const uint8_t PortMaskC = I2CMode ? B00001111 : B00111111;

// Main clock, Timer1, 16-bit
inline uint32_t getTickCount16() {
  cli();
    uint16_t   timer = TCNT1;                   // (1a) Read HW timer
  sei();

  return timer;
}


// Timer2 interrupt, called 244.140625 times per second in Demo mode
ISR(TIMER2_OVF_vect) {
  if (demoMode) {
    for (uint8_t i = 0; i < GaugeCount; ++i) {
        ++gaugeValue[i];
    }  
  }
}


 
void setup() {                
  DDRB  |=  B00100000;      // Pin 13 output => LED + PWM Sync for oscilloscope
  PORTB |=  B00100000;      // LED on 

  cli();
    // Set Timer1 to 16 MHz
    TCCR1A = 0;                                             // Normal mode, no PWM
    TCCR1B = B001;                                          // 16000000 Hz / 1 = ~244 Hz overflow
    TIMSK1 = B0;                                            // Overflow Interrupt Disabled
    TCNT1 = 0x0000;                                         // Reset the counter
  
    // Set Timer2 to ~15 kHz
    TCCR2A = 0;                                             // Normal mode, no PWM
    TCCR2B = B00000111;                                     // 16000000 Hz / 1024 = 15625 Hz / 256 = ~61 Hz overflow
    TIMSK2 = B00000001;                                     // Overflow Interrupt Enable
    TCNT2 = 0x00;                                           // Reset the counter

    // Fill init values   
    for (uint8_t i = 0; i < GaugeCount; ++i) {
      gaugeValue[i] = 13*i;
    }  
  sei();

  if (I2CMode) {
    // Set I2C    
    Wire.begin(I2CSlaveAddress);                              // Join i2c bus with address #I2C_SLAVE_ADDR
    Wire.onReceive(receiveEvent);                             // Register event handler
    //digitalWrite(A4, HIGH);                                   // Enable the pull-up for SDA
    //digitalWrite(A5, HIGH);                                   // Enable the pull-up for SCL
  }
  
  // Enable driving pins  
  DDRD |= PortMaskD;
  DDRB |= PortMaskB;
  DDRC |= PortMaskC;
  
  // Precalculate sine table
  for (uint16_t i = 0; i < 256; ++i) {
    const float scalehalf = float(PwmPulseWidth - 1)*0.5f;        // 255 => 127.5, 4095 => 2047.5
    float sinehalf = sin(2*M_PI * ((float)i)/256);
    if (sinehalf >= 0.0f) {
      sin256Table[i] = (uint16_t)(scalehalf * ( 1.0f*pow( sinehalf, sineGamma)) + scalehalf + 0.5f);
    } else {
      sin256Table[i] = (uint16_t)(scalehalf * (-1.0f*pow(-sinehalf, sineGamma)) + scalehalf + 0.5f);
    }

}

 
  // Status ok
  PORTB &= ~B00100000;      // LED off
  
}

void receiveEvent(int howMany)
{
    if (howMany < 2)
    {
        goto FAILCLEAN;
    }

    demoMode = false;
    TIMSK2 = B00000000;     // Stop timer2 interrupts for demo mode
    
    uint8_t reg_addr = Wire.read();
    uint8_t max_reg = reg_addr + howMany - 1;
    if (reg_addr >= GaugeCount || max_reg > GaugeCount)
    {
        goto FAILCLEAN;
    }
    
    for (uint8_t i = reg_addr; i < max_reg; ++i)
    {
        gaugeValue[i] = Wire.read();
    }
    return;

FAILCLEAN:
    while(Wire.available())
    {
        Wire.read();
    }
}


 
bool upslope = false;  
uint16_t  pwmValue0,  pwmValue1,  pwmValue2,  pwmValue3,  pwmValue4,  pwmValue5,  pwmValue6,  pwmValue7;
uint16_t  pwmValue8,  pwmValue9,  pwmValue10, pwmValue11, pwmValue12, pwmValue13, pwmValue14, pwmValue15;

void loop() {
  
  cli(); 
    // Read current time    
    uint32_t pwmTime = getTickCount16() & PwmPulseMask2;
    
    // Phase&frequency corrected PWM
    if (pwmTime < PwmPulseWidth) {
      if (!upslope) {
        // Load new values
        pwmValue0  = sin256Table[uint8_t(gaugeValue[0] +  0)];  pwmValue1  = sin256Table[uint8_t(gaugeValue[0] + 64)];
        pwmValue2  = sin256Table[uint8_t(gaugeValue[1] +  0)];  pwmValue3  = sin256Table[uint8_t(gaugeValue[1] + 64)];
        pwmValue4  = sin256Table[uint8_t(gaugeValue[2] +  0)];  pwmValue5  = sin256Table[uint8_t(gaugeValue[2] + 64)];
        pwmValue6  = sin256Table[uint8_t(gaugeValue[3] +  0)];  pwmValue7  = sin256Table[uint8_t(gaugeValue[3] + 64)];
        pwmValue8  = sin256Table[uint8_t(gaugeValue[4] +  0)];  pwmValue9  = sin256Table[uint8_t(gaugeValue[4] + 64)];
        pwmValue10 = sin256Table[uint8_t(gaugeValue[5] +  0)];  pwmValue11 = sin256Table[uint8_t(gaugeValue[5] + 64)];
        pwmValue12 = sin256Table[uint8_t(gaugeValue[6] +  0)];  pwmValue13 = sin256Table[uint8_t(gaugeValue[6] + 64)];
        pwmValue14 = sin256Table[uint8_t(gaugeValue[7] +  0)];  pwmValue15 = sin256Table[uint8_t(gaugeValue[7] + 64)];
      }
      
      upslope = true;
      PORTB |=  B00100000;    // Pin 13 high for up slope, can be used as scope trigger
    } else { 
      pwmTime = PwmPulseMask2 - pwmTime;
      upslope = false;
      PORTB &= ~B00100000;    // Pin 13 low for down slope
    }
    
    // Totally unrolled with direct port banging to utilize SBI/CBI instructions

    // Gauge 0 pin positions are moved depending on I2C or RX/TX mode
    if (I2CMode) {
      if (pwmValue0 < pwmTime) { PORTD |= B00000001; } else { PORTD &= ~B00000001; }      // Arduino pin 0  (RX)
      if (pwmValue1 < pwmTime) { PORTD |= B00000010; } else { PORTD &= ~B00000010; }      // Arduino pin 1  (TX)
    } else {
      if (pwmValue0 < pwmTime) { PORTC |= B00010000; } else { PORTC &= ~B00010000; }      // Arduino pin A4 (SDA)
      if (pwmValue1 < pwmTime) { PORTC |= B00100000; } else { PORTC &= ~B00100000; }      // Arduino pin A5 (SCL)
    }
    if (pwmValue2  < pwmTime) { PORTD |= B00000100; } else { PORTD &= ~B00000100; }       // Arduino pin 2
    if (pwmValue3  < pwmTime) { PORTD |= B00001000; } else { PORTD &= ~B00001000; }       // Arduino pin 3
    if (pwmValue4  < pwmTime) { PORTD |= B00010000; } else { PORTD &= ~B00010000; }       // Arduino pin 4
    if (pwmValue5  < pwmTime) { PORTD |= B00100000; } else { PORTD &= ~B00100000; }       // Arduino pin 5
    if (pwmValue6  < pwmTime) { PORTD |= B01000000; } else { PORTD &= ~B01000000; }       // Arduino pin 6
    if (pwmValue7  < pwmTime) { PORTD |= B10000000; } else { PORTD &= ~B10000000; }       // Arduino pin 7
    
    if (pwmValue8  < pwmTime) { PORTC |= B00000001; } else { PORTC &= ~B00000001; }       // Arduino pin A0
    if (pwmValue9  < pwmTime) { PORTC |= B00000010; } else { PORTC &= ~B00000010; }       // Arduino pin A1
    if (pwmValue10 < pwmTime) { PORTC |= B00000100; } else { PORTC &= ~B00000100; }       // Arduino pin A2
    if (pwmValue11 < pwmTime) { PORTC |= B00001000; } else { PORTC &= ~B00001000; }       // Arduino pin A3

    if (pwmValue12 < pwmTime) { PORTB |= B00000001; } else { PORTB &= ~B00000001; }       // Arduino pin 8
    if (pwmValue13 < pwmTime) { PORTB |= B00000010; } else { PORTB &= ~B00000010; }       // Arduino pin 9
    if (pwmValue14 < pwmTime) { PORTB |= B00000100; } else { PORTB &= ~B00000100; }       // Arduino pin 10
    if (pwmValue15 < pwmTime) { PORTB |= B00001000; } else { PORTB &= ~B00001000; }       // Arduino pin 11

  sei();
}
