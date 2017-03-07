import os
import sys
import logging
import time
import json
import getopt
# Import SDK packages
from AWSIoTPythonSDK.MQTTLib import AWSIoTMQTTShadowClient


# Custom Shadow callback
def customShadowCallback_Update(payload, responseStatus, token):
	# payload is a JSON string ready to be parsed using json.loads(...)
	# in both Py2.x and Py3.x
	if responseStatus == "timeout":
		print("Update request " + token + " time out!")
	if responseStatus == "accepted":
		payloadDict = json.loads(payload)
		print("~~~~~~~~~~~~~~~~~~~~~~~")
		print("Update request with token: " + token + " accepted!")
		print("property: " + str(payloadDict["state"]["desired"]["property"]))
		print("~~~~~~~~~~~~~~~~~~~~~~~\n\n")
	if responseStatus == "rejected":
		print("Update request " + token + " rejected!")

def customShadowCallback_Delete(payload, responseStatus, token):
	if responseStatus == "timeout":
		print("Delete request " + token + " time out!")
	if responseStatus == "accepted":
		print("~~~~~~~~~~~~~~~~~~~~~~~")
		print("Delete request with token: " + token + " accepted!")
		print("~~~~~~~~~~~~~~~~~~~~~~~\n\n")
	if responseStatus == "rejected":
		print("Delete request " + token + " rejected!")

def main():
    # For certificate based connection
    myShadowClient = AWSIoTMQTTShadowClient(os.environ['AWS_CLIENT_ID'])
    # For Websocket connection
    # myShadowClient = AWSIoTMQTTClient("myClientID", useWebsocket=True)
    # Configurations
    # For TLS mutual authentication
    myShadowClient.configureEndpoint(os.environ['AWS_ENDPOINT'], 8883)
    # For Websocket
    # myShadowClient.configureEndpoint("YOUR.ENDPOINT", 443)
    myShadowClient.configureCredentials(os.environ['AWS_ROOTCA'], os.environ['AWS_PRIVATE_KEY'], os.environ['AWS_CERTIFICATE'])
    # For Websocket, we only need to configure the root CA
    # myShadowClient.configureCredentials("YOUR/ROOT/CA/PATH")
    myShadowClient.configureConnectDisconnectTimeout(10)  # 10 sec
    myShadowClient.configureMQTTOperationTimeout(5)  # 5 sec

    myShadowClient.connect()
    # Create a device shadow instance using persistent subscription
    Bot = myShadowClient.createShadowHandlerWithName("Bot", True)

    # Delete shadow JSON doc
    Bot.shadowDelete(customShadowCallback_Delete, 5)

    # Update shadow in a loop
    loopCount = 0
    # PUT ALL your code for handling buttons and such in here.
    while True:
    	JSONPayload = '{"state":{"desired":{"link":' + str(loopCount) + '}}}'
    	Bot.shadowUpdate(JSONPayload, customShadowCallback_Update, 5)
    	loopCount += 1
    	time.sleep(1)


if __name__ == '__main__':
    main()
