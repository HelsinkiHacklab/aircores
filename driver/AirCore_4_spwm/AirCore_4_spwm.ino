
#include <Wire.h>

// This is ATmega328P specific implementation!
enum { BoardSelector = 4 };  // REMEMBER TO CHANGE THIS BEFORE PROGRAMMING!
const uint8_t     I2CSlaveAddresses[5] = { 0x04, 0x05, 0x06, 0x07, 0x08 };      
const uint8_t     I2CSlaveAddress = I2CSlaveAddresses[BoardSelector];    
const bool        I2CMode = true;

volatile bool     demoMode = true;             // Starts in Demo mode where timer2 interrupt will automatically increment the gauge values

const uint8_t    PwmScaler = 11;     // 0..15!
const uint16_t   PwmPulseWidth = (1 << PwmScaler);

//  PwmScaler   Resolution    Frequency    Notes
//   0          2            16 MHz        Too fast, doesn't even generate valid PWM
//   1          4             8 MHz        
//   2          8             2 MHz        Too fast still, but the aircore already moving, very jerky
//   3         16             1 MHz        
//   4         32           500 kHz        
//   5         64           250 kHz        
//   6        128           125 kHz        
//   7        256            63 kHz        
//   8        512            31 kHz        Aircore moves, but still jerky 
//   9        1Ki            16 kHz
//  10        2Ki          7812 Hz
//  11        4Ki          3906 Hz         Aircore moves fine, some noise
//  12        8Ki          1953 Hz         WAT, now it works fine?  // Aircore moves smoothly, but noise is very irritating
//  13       16Ki           976 Hz         Optimal?
//  14       32Ki           488 Hz         Optimal?
//  15       64Ki           244 Hz         Aircore needle starts to vibrate a little bit at the quadrants. This could be minimized by tweaking the sine table -> TODO

const int GaugeCount = 8;
// The actual gauge values. As bytes they can be read or write with interrups enabled. For read-modify-write disable interrupts!
volatile uint8_t gaugeValue[GaugeCount] = { 0 };      // angle = 0..255

// This takes 1024 bytes of RAM
uint16_t  sin256Table[256] = { 0 };

const uint8_t PortMaskD = I2CMode ? B11111111 : B11111100;
const uint8_t PortMaskC = B00001111;
const uint8_t PortMaskB = I2CMode ? B00001111 : B00111111;


// Main clock, Timer1, 32-bit
volatile uint16_t tick_counter_31to16 = 0;     	// Incremented ~488 times per second
ISR(TIMER1_OVF_vect, ISR_BLOCK) {          		// interrupt service routine that wraps a user defined function supplied by attachInterrupt
  ++tick_counter_31to16;
}

inline uint32_t getTickCount32() {
  cli();
    uint16_t   timer = TCNT1;             // (1a) Read HW timer
    if (TIFR1 & (1 << TOV1)) {            // INTFLAGS[0] X OVFIF: Overflow/Underflow Interrupt Flag
	// Handle it straight here, instead of the interrupt handler
  	TIFR1 = (1 << TOV1);              // Clear the pending interrupt
  	timer = TCNT1;                    // (1b) Overflow occurred concurrently, read timer again to get new value after overflow
	++tick_counter_31to16;
    }
    
    uint32_t ticks = uint32_t(tick_counter_31to16) << 16 | timer;    // (2) Read volatile overflow counter
  
  sei();

  return ticks;
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

  pinMode(13, OUTPUT);     // Status LED
  digitalWrite(13, HIGH);
  
  cli(); {
    // Set Timer1 to 16 MHz
    TCCR1A = 0;                                             // Normal mode, no PWM
    TCCR1B = B001;                                          // 16000000 Hz / 1 = ~244 Hz overflow
    TIMSK1 = B1;                                            // Overflow Interrupt Enable
    TCNT1 = 0x0000;                                         // Reset the counter
  } sei();

  cli(); {
    // Set Timer2 to ~15 kHz
    TCCR2A = 0;                                             // Normal mode, no PWM
    TCCR2B = B00000111;                                     // 16000000 Hz / 1024 = 15625 Hz / 256 = ~61 Hz overflow
    TIMSK2 = B00000001;                                     // Overflow Interrupt Enable
    TCNT2 = 0x00;                                           // Reset the counter
  } sei();

  for (uint8_t i = 0; i < GaugeCount; ++i) {
    gaugeValue[i] = 13*i;
  }  

  if (I2CMode) {
    // Set I2C    
    Wire.begin(I2CSlaveAddress);                              // Join i2c bus with address #I2C_SLAVE_ADDR
    Wire.onReceive(receiveEvent);                             // Register event handler
    digitalWrite(A4, HIGH);                                   // Enable the pull-up for SDA
    digitalWrite(A5, HIGH);                                   // Enable the pull-up for SCL
  }
  
  // Enable driving pins  
  DDRD |= PortMaskD;
  DDRC |= PortMaskC;
  DDRB |= PortMaskB;
  
  // Precalculate sine table
  for (uint16_t i = 0; i < 256; ++i) {
    const float scalehalf = float(PwmPulseWidth - 1)*0.5f;        // 255 => 127.5, 4095 => 2047.5
    float sinehalf = sin(2*M_PI * ((float)i)/256);
      sin256Table[i] = (int16_t)(scalehalf * (1.0f*sinehalf) + scalehalf + 0.5);
  }

 
  // Status ok
  digitalWrite(13, LOW);
  
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


inline bool sinPwm(uint16_t pwmTime, uint8_t angle) {
  return sin256Table[uint8_t(angle +  0)] > pwmTime;
}

inline bool cosPwm(uint16_t pwmTime, uint8_t angle) {
  return sin256Table[uint8_t(angle + 64)] > pwmTime;
}
 

void loop() {
  
  cli(); {
    // Read current time    
    uint16_t pwmTime = getTickCount32() & (PwmPulseWidth*2 - 1);
    if (pwmTime > (PwmPulseWidth - 1)) { pwmTime = PwmPulseWidth*2 - pwmTime; }  // Phase corrected PWM

    uint8_t  portBitsD = PORTD & ~PortMaskD;
    uint8_t  portBitsC = PORTC & ~PortMaskC;
    uint8_t  portBitsB = PORTB & ~PortMaskB;
    
    uint8_t  gauge = 0;

    // Port D
    if (I2CMode) {
        if (sinPwm(pwmTime, gaugeValue[gauge  ])) { portBitsD |= B00000001; }
        if (cosPwm(pwmTime, gaugeValue[gauge++])) { portBitsD |= B00000010; }
    }
    if (sinPwm(pwmTime, gaugeValue[gauge  ])) { portBitsD |= B00000100; }
    if (cosPwm(pwmTime, gaugeValue[gauge++])) { portBitsD |= B00001000; }
    if (sinPwm(pwmTime, gaugeValue[gauge  ])) { portBitsD |= B00010000; }
    if (cosPwm(pwmTime, gaugeValue[gauge++])) { portBitsD |= B00100000; }
    if (sinPwm(pwmTime, gaugeValue[gauge  ])) { portBitsD |= B01000000; }
    if (cosPwm(pwmTime, gaugeValue[gauge++])) { portBitsD |= B10000000; }

    // Port C
    if (sinPwm(pwmTime, gaugeValue[gauge  ])) { portBitsC |= B00000001; }
    if (cosPwm(pwmTime, gaugeValue[gauge++])) { portBitsC |= B00000010; }
    if (sinPwm(pwmTime, gaugeValue[gauge  ])) { portBitsC |= B00000100; }
    if (cosPwm(pwmTime, gaugeValue[gauge++])) { portBitsC |= B00001000; }

    // Port B
    if (sinPwm(pwmTime, gaugeValue[gauge  ])) { portBitsB |= B00000001; }
    if (cosPwm(pwmTime, gaugeValue[gauge++])) { portBitsB |= B00000010; }
    if (sinPwm(pwmTime, gaugeValue[gauge  ])) { portBitsB |= B00000100; }
    if (cosPwm(pwmTime, gaugeValue[gauge++])) { portBitsB |= B00001000; }
    if (!I2CMode) {
        if (sinPwm(pwmTime, gaugeValue[gauge  ])) { portBitsB |= B00010000; }
        if (cosPwm(pwmTime, gaugeValue[gauge++])) { portBitsB |= B00100000; }
    }

    // Write patterns    
    PORTD = portBitsD;
    PORTC = portBitsC;
    PORTB = portBitsB;

  }; sei();

}


