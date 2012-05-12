
#define I2C_SLAVE_ADDR 0x4 // the 7-bit address (remember to change this)
#include <Wire.h>


#include "Sin4096.h"

enum { MotorCount = 8 };          //      1   2   3   4   5   6    7    8
const uint8_t meterPinX[MotorCount] = {   0,  2,  4,  6,  8,  10,  A0,  A2, };
const uint8_t meterPinY[MotorCount] = {   1,  3,  5,  7,  9,  11,  A1,  A3, };

volatile uint8_t meterValue[MotorCount] = { 0 };      // angle = 0..255


const uint32_t   MicrosecondInTicks = 16;
const uint32_t   MillisecondInTicks = 16000;
const uint32_t   SecondInTicks = 16000000;
const uint8_t    pwmScaler = 9;                  // 0..8?

const bool       demo = false;                    // Demo mode


volatile uint32_t tick_counter_overflow = 0;     // Incremented 244,140625 times per second
ISR(TIMER1_OVF_vect) {          // interrupt service routine that wraps a user defined function supplied by attachInterrupt
  ++tick_counter_overflow;
}

inline uint32_t getTickCount() {
  cli();
  uint16_t   timer = TCNT1;             // (1a) Read HW timer
  if (TIFR1 & (1 << TOV1)) {
    timer = TCNT1;                      // (1b) Overflow occured concurrently, read timer again to get new value after overflow
    ++tick_counter_overflow;            // Handle it here, instead of the interrupt handler  
    TIFR1 = (1 << TOV1);                // Clear the pending flag and 
  }
  
  uint32_t ticks = uint32_t(tick_counter_overflow << 16) | timer;    // (2) Read volatile overflow counter
  sei();

  return ticks;
}


 
void setup() {                



  pinMode(13, OUTPUT);     // Status LED
  

  // Set Timer1 to 16 MHz 
  cli(); 
    // 15.11.1 TCCR1A – Timer/Counter1 Control Register A
    TCCR1A = 0;                                 // No PWM is used.So set this to zero.
    
    // 15.11.2 TCCR1B – Timer/Counter1 Control Register B
    TCCR1B = 0 << CS12 | 0 << CS11 | 1 << CS10;                             // Input clock is set to clk_io/1 (No prescaling)

    // 15.11.3 TCCR1C – Timer/Counter1 Control Register C

    // 15.11.8 TIMSK1 – Timer/Counter1 Interrupt Mask Register
    TIMSK1 = 1 << TOIE1;                       // Bit 0 – TOIE1: Timer/Counter1, Overflow Interrupt Enable

    // 15.11.4 TCNT1H and TCNT1L – Timer/Counter1  
    TCNT1 = 0x0000;       
  sei();
  


  // Enable driving pins  
  for (uint8_t i = 0; i < MotorCount; ++i) {
    pinMode(meterPinX[i], OUTPUT);
    pinMode(meterPinY[i], OUTPUT);
  }    


  Wire.begin(I2C_SLAVE_ADDR);                // join i2c bus with address #I2C_SLAVE_ADDR
  Wire.onReceive(receiveEvent); // register event
  // Enable the pull-ups
  digitalWrite(A4, HIGH);
  digitalWrite(A5, HIGH);
 
  // Status ok
  digitalWrite(13, HIGH);
}


void receiveEvent(int howMany)
{
    byte reg_addr = Wire.read();
    byte max_reg = reg_addr + howMany - 1;
    
    for (byte i = reg_addr; i < max_reg; i++)
    {
        meterValue[i] = Wire.read();
    }
}



void loop() {
  uint32_t time = getTickCount();
  

  
  
  uint8_t  pwmTime = uint8_t((time >> pwmScaler) & 0xff);      //  0 = 62.5 kHz, 7 = 488 Hz      

  // fill dummy values
  if (demo) {  
    uint32_t position = time / (MillisecondInTicks*4);    
    
    for (uint8_t i = 0; i < MotorCount; ++i) {
        meterValue[i] = position*4; //(i + 3);
    }
  }


  // Generate PWM-signals      
  for (uint8_t i = 0; i < MotorCount; ++i) {
    cli();
    uint16_t value = meterValue[i] << 4; 
    digitalWrite(meterPinX[i], (sine4096(value +    0) < pwmTime));
    digitalWrite(meterPinY[i], (sine4096(value + 1024) < pwmTime));
    sei();
  }  

}


