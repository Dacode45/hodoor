from AWSIoTPythonSDK.MQTTLib import AWSIoTMQTTClient
import os
import sys
import logging
import time
import json
from random import randint
import getopt

def customCallback(client, userdata, message):
	print("Received a new message from %s, %s: " % (client, userdata))
	print(message.payload)
	print("from topic: ")
	print(message.topic)
	print("--------------\n\n")

def main():
	# logger = logging.getLogger("AWSIoTPythonSDK.core")
	# logger.setLevel(logging.DEBUG)
	# streamHandler = logging.StreamHandler()
	# formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
	# streamHandler.setFormatter(formatter)
	# logger.addHandler(streamHandler)

	client = AWSIoTMQTTClient('button')
	client.configureEndpoint(os.environ['AWS_ENDPOINT'], 8883)
	client.configureCredentials(os.environ['AWS_ROOTCA'], os.environ['AWS_PRIVATE_KEY'], os.environ['AWS_CERTIFICATE'])

	client.configureAutoReconnectBackoffTime(1, 32, 20)
	client.configureOfflinePublishQueueing(-1)  # Infinite offline Publish queueing
	client.configureDrainingFrequency(2)  # Draining: 2 Hz
	client.configureConnectDisconnectTimeout(10)  # 10 sec
	client.configureMQTTOperationTimeout(5)  # 5 sec

	client.connect()
	client.subscribe('server', 1, customCallback)
	client.subscribe('lock', 1, customCallback)
	client.subscribe('unlock', 1, customCallback)
	time.sleep(2)

	loopCount = 0
	client.publish('button', str(randint(333, 999)), 1)
	while True:
		# if loopCount %3 == 0:
		# 	client.publish('button', loopCount, 1)#str(randint(333, 999)), 1)
		# elif loopCount %3 == 1:
		# 	client.publish('locked', str(time.time()), 1)
		# else:
		# 	client.publish('unlocked', str(time.time()), 1)
		loopCount += 1
		time.sleep(1);

if __name__=='__main__':
	main()
