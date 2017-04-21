#turn a servo, return locked or unlocked
import time
import wiringpi
import sys
import getopt

# use 'GPIO naming'
wiringpi.wiringPiSetupGpio()

# set #18 to be a PWM output
wiringpi.pinMode(18, wiringpi.GPIO.PWM_OUTPUT)

# set the PWM mode to milliseconds stype
wiringpi.pwmSetMode(wiringpi.GPIO.PWM_MODE_MS)

# divide down clock
wiringpi.pwmSetClock(192)
wiringpi.pwmSetRange(2000)

delay_period = 0.01

while True:
    print 'locking...'
    for pulse in range(150, 50, -1):
        wiringpi.pwmWrite(18, pulse)
        time.sleep(delay_period)
    print 'locked'


            
