//TinyWire uses variable named I2C_SLAVE_ADDR, so we use the longer writing form here
#define I2C_SLAVE_ADDRESS 0x4 // the 7-bit address (remember to change this)
#include <TinyWireS.h>

byte angle = 128;

void setup()
{
    // Note that pin number are as per http://hlt.media.mit.edu/?p=1229
    pinMode(1, OUTPUT); // The HW-PWM -pin supported by the tiny core
    pinMode(3, OUTPUT); // OC1B-
    pinMode(4, OUTPUT); // OC1B

    // Enable I2C Slave
    TinyWireS.begin(I2C_SLAVE_ADDRESS);
    /**
     * Enabling internal pull-ups this way does not work    
    digitalWrite(0, HIGH);
    digitalWrite(2, HIGH);
     */

    digitalWrite(3, HIGH);
}

void loop()
{
    // If we have a new incoming value read it as the angle to use
    if (TinyWireS.available())
    {
        angle = TinyWireS.receive();
    }
    
    // Dummy for now just to test the I2C receiver
    analogWrite(1, angle);
    // Pulse the pin to see activity
    digitalWrite(4, !digitalRead(4));
    digitalWrite(3, !digitalRead(3));
}

