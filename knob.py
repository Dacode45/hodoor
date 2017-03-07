#turn a servo, return locked or unlocked
import time
##import wiringpi
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

def main(argv):
    status = ''
    try:
        opts, args = getopt.getopt(argv, 'hlu',[])
    except getopt.GetoptError:
        print 'knob.py -l (lock) -u (unlock)'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'knob.py -l (lock) -u (unlock)'
            sys.exit()
        elif opt == '-l':
            print 'locking...'
            for pulse in range(250, 50, -1):
                wiringpi.pwmWrite(18, pulse)
                time.sleep(delay_period)
            print 'locked'
        elif opt == '-u':
            print 'unlocking...'
            for pulse in range(50, 250, 1):
                wiringpi.pwmWrite(18, pulse)
                time.sleep(delay_period)
            print 'unlocked!'

if __name__ == "__main__":
    main(sys.argv[1:])
            
