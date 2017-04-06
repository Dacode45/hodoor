#lock a servo connected to the door knob

import RPi.GPIO as GPIO ## Import GPIO library
import time ## Import 'time' library. Allows us to use 'sleep'

GPIO.setmode(GPIO.BOARD) ## Use board pin numbering
GPIO.setup(21, GPIO.OUT) ## Setup GPIO Pin 7 to OUT

GPIO.output(21,True)## Switch on pin 7
time.sleep(100)## Wait
GPIO.output(21,False)## Switch off pin 7
