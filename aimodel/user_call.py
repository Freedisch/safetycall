# works with both python 2 and 3
from __future__ import print_function

import africastalking

class VOICE:
    def __init__(self):
		# Set your app credentials
        self.username = "YOUR_USERNAME"
        self.api_key = "Token"
		# Initialize the SDK
        africastalking.initialize(self.username, self.api_key)
		# Get the voice service
        self.voice = africastalking.Voice

    def call(self):
        # Set your Africa's Talking phone number in international format
        callFrom = "+254711082XXX"
        # Set the numbers you want to call to in a comma-separated list
        callTo   = ["+254711XXXYYY"]
        try:
			# Make the call
            result = self.voice.call(callFrom, callTo)
            print (result)
        except Exception as e:
            print ("Encountered an error while making the call:%s" %str(e))

if __name__ == '__main__':
    VOICE().call()