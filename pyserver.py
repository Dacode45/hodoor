from flask import Flask, request
import random
import subprocess
import os
import time
import lock
from AWSIoTPythonSDK.MQTTLib import AWSIoTMQTTClient

AWS_CLIENT_ID = os.environ['AWS_CLIENT_ID']
AWS_ENDPOINT = os.environ['AWS_ENDPOINT']
AWS_ROOTCA = os.environ['AWS_ROOTCA']
AWS_PRIVATE_KEY = os.environ['AWS_PRIVATE_KEY']
AWS_CERTIFICATE = os.environ['AWS_CERTIFICATE']


def lock_door(a,b,c):
	client.publish("locked", "locked", 1)
	lock.main()
	print 'door locked'

def unlock_door(a,b,c):
	client.publish("unlocked","unlocked",1)
	lock.main()
	print 'door unlocked'

client = AWSIoTMQTTClient(AWS_CLIENT_ID)
client.configureEndpoint(AWS_ENDPOINT, 8883)
client.configureCredentials(AWS_ROOTCA, AWS_PRIVATE_KEY, AWS_CERTIFICATE)

client.connect()
client.subscribe("lock",1,lock_door)
client.subscribe("unlock",1,unlock_door)
global last_time
app = Flask(__name__)
@app.route('/')
def index():
	return 'Hello world'

@app.route('/motion', methods=['POST'])
def motion_detected():
	pw = random.randint(1000,9999)
	global last_time
	now = time.time()
	if now-last_time>10:
		print 'motion detected'
		client.publish("motion",pw,0)
		last_time = now
	return ''






if __name__ == '__main__':
	last_time = time.time()
	app.run(debug=True, host='localhost')


