#lock a servo connected to the door knob

import RPi.GPIO as GPIO ## Import GPIO library
import time ## Import 'time' library. Allows us to use 'sleep'

GPIO.setmode(GPIO.BOARD) ## Use board pin numbering
GPIO.setup(21, GPIO.OUT) ## Setup GPIO Pin 21 to OUT

GPIO.output(21,True)## Switch on pin 21
time.sleep(0.1)## Wait
GPIO.output(21,False)## Switch off pin 21

GPIO.cleanup()
