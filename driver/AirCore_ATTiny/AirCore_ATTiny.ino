//TinyWire uses variable named I2C_SLAVE_ADDR, so we use the longer writing form here
#define I2C_DEFAULT_SLAVE_ADDRESS 0x4 // the 7-bit address (remember to change this)
#define REGS_EEPROM_OFFSET 1 // From which value onwards to write the regs to EEPROM
#define REGS_ADDRESS_OFFSET 2 // From which value onwards to write the regs to EEPROM
// Get this from https://github.com/rambo/TinyWire
#include <TinyWireS.h>
#include "sintable.h"
// Use the AVR block functions directly (looping over arrays using the EEPROM Arduino library writing a byte at a time is just stupid), see also http://arduino.cc/playground/Code/EEPROMWriteAnything
#include <avr/eeprom.h>

/**
 * Pin notes by Suovula (see also http://hlt.media.mit.edu/?p=1229)
 *
// I2C
arduino pin 0 = not(OC1A) = PORTB <- _BV(0) = SOIC pin 5 (I2C SDA)
arduino pin 2 =           = PORTB <- _BV(2) = SOIC pin 7 (I2C SCL)
// Timer1 -> PWM
arduino pin 1 =     OC1A  = PORTB <- _BV(1) = SOIC pin 6
arduino pin 3 = not(OC1B) = PORTB <- _BV(3) = SOIC pin 2
arduino pin 4 =     OC1B  = PORTB <- _BV(4) = SOIC pin 3
 */

volatile uint8_t i2c_regs[] =
{ 
  0, // angle
  0, // offset (will be stored to EEPROM (on save command)
  I2C_DEFAULT_SLAVE_ADDRESS, // slave address to store to EEPROM, on next device start this will be the new address
  //TODO: make the PWM scaler configurable with I2C register ? 
  0xfc, // This last value is a magic number used to check that the data in EEPROM is ours (TODO: switch to some sort of simple checksum ?)
  // ALSO: writing 0x01 to this register triggers saving of data to EEPROM
};


volatile boolean write_eeprom = false;
volatile boolean demo_mode = true;

void regs_eeprom_read()
{
    eeprom_read_block((void*)&i2c_regs[REGS_EEPROM_OFFSET], (void*)0, sizeof(i2c_regs)-REGS_EEPROM_OFFSET);
    if (i2c_regs[sizeof(i2c_regs)-1] != 0xfc)
    {
        // Insane value, restore default I2C address...
        i2c_regs[REGS_ADDRESS_OFFSET] = I2C_DEFAULT_SLAVE_ADDRESS;
    }
}

void regs_eeprom_write()
{
    eeprom_write_block((const void*)&i2c_regs[REGS_EEPROM_OFFSET], (void*)0, sizeof(i2c_regs)-REGS_EEPROM_OFFSET);
}

void setup()
{
    // See the note about Arduino pin numbers above, these do *not* match the SOIC pins...
    pinMode(1, OUTPUT); // OC1A, also The only HW-PWM -pin supported by the tiny core analogWrite
    pinMode(4, OUTPUT); // OC1B

    // TODO: Tri-state this and wait for input voltage to stabilize before enabling the PWMs
    pinMode(3, OUTPUT); // OC1B-, Arduino pin 3, ADC
    digitalWrite(3, LOW);


    // Read the configuration registers from EEPROM
    regs_eeprom_read();

    // Iinitialize fast PWM
    cli();
      /** 
       * This does not actually work...
      // Initialize PLL clock as PWM source
      PLLCSR |= (1<<PLLE); // Enable PLL
      while(bit_is_clear(PLLCSR,PLOCK)) ; // Wait for PLL to lock (approx. 100ms)
      PLLCSR |= (1<<PCKE); // Set PLL as PWM clock source
      */
      // Initialize timer1 for PWM
      TCCR1 |= (1<<PWM1A); // Enable OCR1A as PWM 
      GTCCR |= (1<<PWM1B); // Enable OCR1B as PWM
      TCCR1 = (TCCR1 & B11110000) | B0100; // Timer1 prescaler bits
      // Set the PWM output pins and modes
      TCCR1 = (TCCR1 & B11001111) | B10 << 4; // OC1A (soic pin 6) as PWM output
      GTCCR = (GTCCR & B11001111) | B10 << 4; // OC1B (soic pin 1) as PWM output 
      // Disable Timer1 interrupts (we use only the HW PWM in this timer)
      TIMSK = (TIMSK & B10011011) | 0x0;
      // Set full PWM resolution
      OCR1C = 0xff;
      // And initialize the clock
      TCNT1 = 0x0;
    sei();
    
    // Enable I2C Slave
    TinyWireS.begin(i2c_regs[REGS_ADDRESS_OFFSET]);
    /**
     * Enabling internal pull-ups this way does not work (does ATTiny even have those ?)
     * Or is the new arduino env to blame ?
    digitalWrite(0, HIGH);
    digitalWrite(2, HIGH);
     */

    digitalWrite(3, HIGH);
}

void receiveEvent(uint8_t howMany)
{
    if (howMany < 2)
    {
        // We're only interested when we know we can suppose the first byte is register address
        return;
    }

    byte reg_addr = TinyWireS.receive();
    byte max_reg = reg_addr + howMany - 1;
    
    for (byte i = reg_addr; i < max_reg; i++)
    {
        i2c_regs[i] = TinyWireS.receive();
        switch (i)
        {
            case 0x0:
            case 0x1:
            {
                if (i == 0x0)
                {
                    demo_mode = false;
                }
                byte angle = i2c_regs[0] + i2c_regs[1];
                set_pwms(angle);
                break;
            }
        }
    }

    // Check for settings store
    if (i2c_regs[sizeof(i2c_regs)-1] != 0xfc)
    {
        if (i2c_regs[sizeof(i2c_regs)-1] == 0x01)
        {
            write_eeprom = true;
        }
        // Restore the magic number so it gets written correctly
        i2c_regs[sizeof(i2c_regs)-1] = 0xfc;
    }
}

void set_pwms(byte angle)
{
    byte sine = sine4096(angle<<4);
    byte cosine = sine4096((angle+64)<<4);
    cli();
      OCR1A = sine;
      OCR1B = cosine;
    sei();
}

void set_pwms4096(int angle)
{
    byte sine = sine4096(angle);
    byte cosine = sine4096(angle+1024);
    cli();
      OCR1A = sine;
      OCR1B = cosine;
    sei();
}

byte i;
int ii;
void loop()
{
    // Poor-mans event handling (tinywire lib does not yet trigger the event right away), though I still wonder if we can still get two triggers during one I2C transaction (which will mess things up)
    uint8_t i2c_available = TinyWireS.available();
    if (i2c_available > 1)
    {
        receiveEvent(i2c_available);
    }
    if (write_eeprom)
    {
        // Store the offset etc configuration registers to EEPROM
        write_eeprom = false;
        regs_eeprom_write();
    }

    if (demo_mode)
    {
        // Roll the pwm
        //set_pwms(i);
        set_pwms4096(ii);
        delay(50);
        i++;
        ii += 2;
        if (i > 4095)
        {
            0;
        }
    }
}

