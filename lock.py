
#lock a servo connected to the door knob

import RPi.GPIO as GPIO ## Import GPIO library
import time ## Import 'time' library. Allows us to use 'sleep'

GPIO.setmode(GPIO.BCM) ## Use board pin numbering
GPIO.setup(21, GPIO.OUT) ## Setup GPIO Pin 21 to OUT

GPIO.output(21,1)## Switch on pin 21
time.sleep(0.2)## Wait
GPIO.output(21,0)## Switch off pin 21

GPIO.cleanup()
