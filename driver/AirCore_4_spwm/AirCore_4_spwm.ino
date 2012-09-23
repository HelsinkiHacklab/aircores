
#include <Wire.h>

// This is ATmega328P specific implementation!
const uint8_t     I2CSlaveAddress =   0x04;    // The 7-bit address, remember to change this!

volatile bool     demoMode = true;             // Starts in Demo mode where timer2 interrupt will automatically increment the gauge values

const uint8_t  PwmFrequencySelector = 13;     // 0..13..21
//  Selector    Resolution    Frequency    Notes
//   0          2            16 MHz        Too fast, doesn't even generate valid PWM
//   1          4             8 MHz        
//   2          8             2 MHz        Too fast still, but the aircore already moving, very jerky
//   3         16             1 MHz        
//   4         32           500 kHz        
//   5         64           250 kHz        
//   6        128           125 kHz        
//   7        256            63 kHz        
//   8        512            31 kHz        Aircore moves, but still jerky 
//   9       1024            16 kHz
//  10       2048          7812 Hz
//  11       4096          3906 Hz         Aircore moves fine, some noise
//  12       8192          1953 Hz         Aircore moves smoothly, but noise is very irritating
//  13      16386           976 Hz         Optimal?
//  14      32768           488 Hz         Optimal?
//  15      65536           244 Hz         Aircore needle starts to vibrate a little bit at the quadrants. This could be minimized by tweaking the sine table -> TODO
//  16      16368           122 Hz         
//  17      32768            61 Hz         Too slow for aircores!
//  18      65536            31 Hz
//  19      16384            15 Hz
//  20      32768           7.7 Hz
//  21      65536           3.8 Hz         Jeah, right, om nom nom

const uint8_t   PwmTimerPrescaler[22] =  {  1, 1, 1,  1,  1,  1,   1,   1,   1,    1,    1,    1,    1,     1,     1,     1,     2,     2,     2,      3,      3,     3, };
const uint16_t  PwmTimerDuration[22] =   {  1, 1, 1,  1,  1,  1,   1,   1,   1,    1,    1,    1,    1,     1,     1,     1,     8,     8,     8,     64,     64,    64, };       
const uint32_t  PwmPulseWidth[22] =      {  2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 65536, 16368, 32768, 65536,  16384,  32768, 65536, };      

// There are two pins per gauge, and they are allocated from ports D, C and B. I2C mode assumed!
const uint8_t     GaugeCountPortD = 4; 
const uint8_t     GaugePinSinPortD[GaugeCountPortD] = { B00000001, B00000100, B00010000, B01000000, };
const uint8_t     GaugePinCosPortD[GaugeCountPortD] = { B00000010, B00001000, B00100000, B10000000, };
const uint8_t     PortMaskD = B11111111;
  
const uint8_t     GaugeCountPortC = 2; 
const uint8_t     GaugePinSinPortC[GaugeCountPortC] = { B00000001, B00000100 };
const uint8_t     GaugePinCosPortC[GaugeCountPortC] = { B00000010, B00001000 };
const uint8_t     PortMaskC = B00001111;

const uint8_t     GaugeCountPortB = 2; 
const uint8_t     GaugePinSinPortB[GaugeCountPortB] = { B00000001, B00000100 };
const uint8_t     GaugePinCosPortB[GaugeCountPortB] = { B00000010, B00001000 };
const uint8_t     PortMaskB = B00001111;

const uint8_t     GaugeCount = GaugeCountPortD + GaugeCountPortC + GaugeCountPortB;              // Should be 8!

// The actual gauge values. As bytes they can be read or write with interrups enabled. For read-modify-write disable interrupts!
volatile uint8_t gaugeValue[GaugeCount] = { 0 };      // angle = 0..255

// This takes 1024 bytes of RAM
uint16_t  sin256Table[256] = { 0 };

// Timer2 interrupt, called 244.140625 times per second
ISR(TIMER2_OVF_vect) {
  if (demoMode) {
    for (uint8_t i = 0; i < GaugeCount; ++i) {
        ++gaugeValue[i];
    }  
  }
}


 
void setup() {                

  pinMode(13, OUTPUT);     // Status LED
  
  cli(); {
    // Set Timer1 to X MHz
    TCCR1A = 0;                                             // No PWM is used. So set this to zero. - 15.11.1 TCCR1A – Timer/Counter1 Control Register A
    TCCR1B = PwmTimerPrescaler[PwmFrequencySelector];       // See 15.11.2 TCCR1B – Timer/Counter1 Control Register B
    TIMSK1 = 0 << TOIE1;                                    // Bit 0 – TOIE1: Timer/Counter1, Overflow Interrupt Enable - // 15.11.8 TIMSK1 – Timer/Counter1 Interrupt Mask Register
    TCNT1 = 0x0000;                                         // Reset the conuter - 15.11.4 TCNT1H and TCNT1L – Timer/Counter1       
    // Now TCNT1 wraps around 244.140625 times per second and can count maximum of 4.095 ms durations
  } sei();

  cli(); {
    // Set Timer2 to X MHz
    TCCR2A = 0;                                             // Normal mode, no PWM
    TCCR2B = B00000111;                                     // 16000000 Hz / 1024 = 15625 Hz / 256 = ~61 Hz overflow
    TIMSK2 = B00000001;                                     // Overflow Interrupt Enable
    TCNT2 = 0x00;                                           // Reset the counter
  } sei();

  // Set I2C    
  Wire.begin(I2CSlaveAddress);                              // Join i2c bus with address #I2C_SLAVE_ADDR
  Wire.onReceive(receiveEvent);                             // Register event handler
  digitalWrite(A4, HIGH);                                   // Enable the pull-up for SDA
  digitalWrite(A5, HIGH);                                   // Enable the pull-up for SCL

  // Generate initial values with difference phase 
  if (demoMode) {
    for (uint8_t i = 0; i < GaugeCount; ++i) {
        gaugeValue[i] = 13*i;
    }  
  }
  
  // Enable driving pins  
  DDRD |= PortMaskD;
  DDRC |= PortMaskC;
  DDRB |= PortMaskB;
  
  // Precalculate sine table
  for (uint16_t i = 0; i < 256; ++i) {
    const float scalehalf = float(PwmPulseWidth[PwmFrequencySelector] - 1)*0.5f;        // 255 => 127.5, 4095 => 2047.5
    float sinehalf = sin(2*M_PI * ((float)i)/256);
      sin256Table[i] = (int16_t)(scalehalf * (1.0f*sinehalf) + scalehalf + 0.5);
  }

 
  // Status ok
  digitalWrite(13, HIGH);
}

// TODO: Check that we have at least two bytes before going on and supposing first one is register...
void receiveEvent(int howMany)
{
    if (howMany < 2) {
        return;  // We're only interested when we know we can suppose the first byte is register address
    }

    demoMode = false;
    TIMSK2 = B00000000;     // Stop timer2 interrupts for demo mode
    
    uint8_t reg_addr = Wire.read();
    uint8_t max_reg = reg_addr + howMany - 1;
    
    for (uint8_t i = reg_addr; i < max_reg; ++i) {
        if (i < GaugeCount) gaugeValue[i] = Wire.read();
    }
    
}



void loop() {

  cli(); {
    // Read current time    
    uint16_t pwmTime = TCNT1 % PwmPulseWidth[PwmFrequencySelector];

    uint8_t  portBitsD = PORTD & ~PortMaskD;
    uint8_t  portBitsC = PORTC & ~PortMaskC;
    uint8_t  portBitsB = PORTB & ~PortMaskB;
    
    uint8_t  gauge = 0;

    // Generate PWM-signals with different phase shift on each gauges
    for (uint8_t i = 0; i < GaugeCountPortD; ++i) {
      uint8_t angle = gaugeValue[gauge++];     
      if (sin256Table[uint8_t(angle +  0)] < pwmTime) { portBitsD |= GaugePinSinPortD[i]; }
      if (sin256Table[uint8_t(angle + 64)] < pwmTime) { portBitsD |= GaugePinCosPortD[i]; }
    }
    
    for (uint8_t i = 0; i < GaugeCountPortC; ++i) {
      uint8_t angle = gaugeValue[gauge++];     
      if (sin256Table[uint8_t(angle +  0)] < pwmTime) { portBitsC |= GaugePinSinPortC[i]; }
      if (sin256Table[uint8_t(angle + 64)] < pwmTime) { portBitsC |= GaugePinCosPortC[i]; }
    }

    for (uint8_t i = 0; i < GaugeCountPortB; ++i) {
      uint8_t angle = gaugeValue[gauge++];     
      if (sin256Table[uint8_t(angle +  0)] < pwmTime) { portBitsB |= GaugePinSinPortB[i]; }
      if (sin256Table[uint8_t(angle + 64)] < pwmTime) { portBitsB |= GaugePinCosPortB[i]; }
    }
    

    // Write patterns    
    PORTD = portBitsD;
    PORTC = portBitsC;
    PORTB = portBitsB;

  }; sei();

}


