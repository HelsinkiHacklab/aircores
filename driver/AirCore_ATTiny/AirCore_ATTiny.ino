//TinyWire uses variable named I2C_SLAVE_ADDR, so we use the longer writing form here
#define I2C_DEFAULT_SLAVE_ADDRESS 0x4 // the 7-bit address (remember to change this)
// Get this from http://www.arduino.cc/playground/Code/USIi2c
#include <TinyWireS.h>

/**
 * Pin notes by Suovula
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
  128, // angle
  0, // offset (will be stored to EEPROM after wards)
  I2C_DEFAULT_SLAVE_ADDRESS, // slave address to store to EEPROM on next device start this will be the new address
  //TODO: make the PWM scaler configurable with I2C register ? 
};


volatile boolean write_eeprom = false;

void setup()
{
    // Note that pin number are as per http://hlt.media.mit.edu/?p=1229
    pinMode(1, OUTPUT); // OC1A, also The only HW-PWM -pin supported by the tiny core analogWrite
    pinMode(3, OUTPUT); // OC1B-
    pinMode(4, OUTPUT); // OC1B

     // TODO: Read the configuration registers from EEPROM


    // Enable I2C Slave
    TinyWireS.begin(i2c_regs[2]);
    /**
     * Enabling internal pull-ups this way does not work (does ATTiny even have those ?)
    digitalWrite(0, HIGH);
    digitalWrite(2, HIGH);
     */
     
    // This is here just to test bit-banging
    digitalWrite(3, HIGH);
    
    // Init to default angle
    set_pwms(i2c_regs[0]);
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
                // TODO: Set the PWM values from the angle
                byte angle = i2c_regs[0] + i2c_regs[1];
                set_pwms(angle);
                if (i == 0x1)
                {
                    write_eeprom = true;
                }
                break;
            }
            case 0x2:
            {
                write_eeprom = true;
                break;
            }
        }
    }
}

void set_pwms(byte angle)
{
    // TODO: use the OC registers so we get the complements etc
    analogWrite(1, angle);
}

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
        // TODO: Store the offset etc configuration registers to EEPROM
        write_eeprom = false;
    }

    // Dummy for now just to test the I2C receiver
    digitalWrite(4, !digitalRead(4));
    digitalWrite(3, !digitalRead(3));
}

