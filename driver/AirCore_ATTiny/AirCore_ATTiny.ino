//TinyWire uses variable named I2C_SLAVE_ADDR, so we use the longer writing form here
#define I2C_DEFAULT_SLAVE_ADDRESS 0x4 // the 7-bit address (remember to change this)
#define REGS_EEPROM_OFFSET 1 // From which value onwards to write the regs to EEPROM
#define REGS_ADDRESS_OFFSET 2 // In which register is our I2C slave address
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
    cli();
    eeprom_write_block((const void*)&i2c_regs[REGS_EEPROM_OFFSET], (void*)0, sizeof(i2c_regs)-REGS_EEPROM_OFFSET);
    sei();
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
      TCCR1 = (TCCR1 & B11110000) | B0101; // Timer1 prescaler bits
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
    /**
     * Reminder: taking care of pull-ups is the masters job
     */
    TinyWireS.begin(i2c_regs[REGS_ADDRESS_OFFSET]);
    TinyWireS.onReceive(receiveEvent);
    TinyWireS.onRequest(requestEvent);

    digitalWrite(3, HIGH);
}

volatile byte reg_position;
void requestEvent()
{  
    TinyWireS.send(i2c_regs[reg_position]);
    // Increment the reg position on each read, and loop back to zero
    reg_position = (reg_position+1) % sizeof(i2c_regs);
}

void receiveEvent(uint8_t howMany)
{
    if (howMany < 1)
    {
        // Sanity-check
        return;
    }

    reg_position = TinyWireS.receive();
    howMany--;
    if (!howMany)
    {
        // This write was only to set the buffer for next read
        return;
    }
    while(howMany--)
    {
        i2c_regs[reg_position] = TinyWireS.receive();
        switch (reg_position)
        {
            case 0x0:
            case 0x1:
            {
                if (reg_position == 0x0)
                {
                    demo_mode = false;
                }
                byte angle = i2c_regs[0] + i2c_regs[1];
                set_pwms(angle);
                break;
            }
        }
        reg_position = (reg_position+1) % sizeof(i2c_regs);
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
    /**
     * This is the only way we can detect stop condition (http://www.avrfreaks.net/index.php?name=PNphpBB2&file=viewtopic&p=984716&sid=82e9dc7299a8243b86cf7969dd41b5b5#984716)
     * it needs to be called in a very tight loop in order not to miss any.
     * It will call the function registered via TinyWireS.onReceive(); if there is data in the buffer on stop.
     */
    TinyWireS_stop_check();

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

