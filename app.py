import os
# Import SDK packages
from AWSIoTPythonSDK.MQTTLib import AWSIoTMQTTShadowClient


def customCallback(*arg):
    print("CustomCallback called with %d arguments: %s"%(len(arg),arg))

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
    myDeviceShadow = myShadowClient.createShadowHandlerWithName("Pi", True)
    # Shadow operations
    myDeviceShadow.shadowGet(customCallback, 5)
    myDeviceShadow.shadowUpdate('{"test":true}', customCallback, 5)
    myDeviceShadow.shadowDelete(customCallback, 5)
    myDeviceShadow.shadowRegisterDeltaCallback(customCallback)
    myDeviceShadow.shadowUnregisterDeltaCallback()


if __name__ == '__main__':
    main()
