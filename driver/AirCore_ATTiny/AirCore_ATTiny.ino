//TinyWire uses variable named I2C_SLAVE_ADDR, so we use the longer writing form here
#define I2C_SLAVE_ADDRESS 0x4 // the 7-bit address (remember to change this)
#include <TinyWireS.h>

byte angle;

void setup()
{
    TinyWireS.begin(I2C_SLAVE_ADDRESS);
    
    pinMode(1, OUTPUT); // The HW-PWM -pin supported by the tiny core
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
}

