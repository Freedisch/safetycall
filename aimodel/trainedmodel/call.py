import os
from twilio.rest import Client

account_sid = "SID"
auth_token  = "Toekn"

client = Client(account_sid, auth_token)

message = client.calls.create(
    url='http://demo.twilio.com/docs/voice.xml',
    to='+254708379775',
    from_='+15108086846',
    timeout=100
    #body='Tests'
)

print(message)