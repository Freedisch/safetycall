import os
from twilio.rest import Client

account_sid = os.getenv("SID_NUMBER")
auth_token  = os.getenv("TOKEN_NUMBER")

client = Client(account_sid, auth_token)

message = client.calls.create(
        url=os.getenv("URL_NUMBER"),
        to="",
        from_=os.getenv("CALLING_NUMBER"),
        timeout=100
        #body='Tests'
)

print(message)