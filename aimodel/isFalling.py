import os
from flask import Flask, render_template, Response
import cv2
import mediapipe as mp
import time
from twilio.rest import Client as Client_twilio
import os
from supabase import create_client, Client
import json
import xml.etree.ElementTree as ET
from dotenv import load_dotenv

load_dotenv() 

app = Flask(__name__)

mpDraw = mp.solutions.drawing_utils
mpPose = mp.solutions.pose
pose = mpPose.Pose()
cap1 = cv2.VideoCapture(0)


MIN_HEIGHT = 0.5  # adjust this value to change the threshold for detecting fall


def is_falling(pose_landmarks):
    # Check if the height of the hip is lower than the threshold
    hip_height = pose_landmarks.landmark[8].y
    if hip_height < MIN_HEIGHT:
        return True
    return False


def detect_fall(cap):
    """
    Detects if user has fallen or not"""
    pTime = 0
    fall_detected = False
    start_time = 0 
    while True:
        success, img = cap.read()
        if not success:
            break
        imgRGB = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        results = pose.process(imgRGB)
        if results.pose_landmarks:
            mpDraw.draw_landmarks(img, results.pose_landmarks,
                                  mpPose.POSE_CONNECTIONS)
            if is_falling(results.pose_landmarks):
                font = cv2.FONT_HERSHEY_SIMPLEX
                cv2.putText(img, 'NO FALL DETECTED', (100, 100), font, 1, (0, 255, 0), 2, cv2.LINE_4)
                print("No fall detected")
                fall_detected = False 
                
                    
            else:
                font = cv2.FONT_HERSHEY_SIMPLEX
                cv2.putText(img, 'FALL DETECTED', (50, 50), font, 1, (255, 0, 0), 2, cv2.LINE_4)
                print("Fall detected")
                
                if not fall_detected:
                    # Set the fall_detected flag to True and record the current time
                    fall_detected = True
                    start_time = time.time()
                # Check if 60 seconds have passed since fall detection
                if time.time() - start_time >= 60:
                    fall_detected = False
                    #safe_call() # Reset the flag if no fall is detected
                

        cTime = time.time()
        fps = 1 / (cTime - pTime)
        pTime = cTime
        cv2.putText(img, str(int(fps)), (50, 100),
                    cv2.FONT_HERSHEY_PLAIN, 3, (255, 0, 0), 3)
        if cv2.waitKey(1) == 27:  # press 'esc' to exit the loop
            break
        ret, buffer = cv2.imencode('.jpg', img)
        frame = buffer.tobytes()
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')

    cap.release()
    cv2.destroyAllWindows()


@app.route('/')
def index():
    return render_template('index.html')
    
@app.route('/video2')
def video2():
    return Response(detect_fall(cap1), mimetype='multipart/x-mixed-replace; boundary=frame')




def safe_call(num, name):
    account_sid = os.getenv("SID_NUMBER")
    auth_token  = os.getenv("TOKEN_NUMBER")
    trum = str(num)
    client = Client_twilio(account_sid, auth_token)

    message = client.calls.create(
        url=os.getenv("URL_NUMBER"),
        to=trum,
        from_=os.getenv("CALLING_NUMBER"),
        timeout=100
        #body='Tests'
    )

    print(message)

def db_contact():
    response = supabase.table('contacts').select("*").execute()
    print(response)
    return response


root = ET.Element("data")

def json_to_xml(json_data, parent):
    if isinstance(json_data, dict):
        for key, value in json_data.items():
            element = ET.SubElement(parent, key)
            json_to_xml(value, element)
        
    else:
        parent.text = str(json_data)

#HEAVY REVERSE ENGINEERING SOLUTION TO READ DATA AND FORMAT DATA FROM XML FILES #PROUD_of_THAT
def reverst_data():
    with open('output.xml', 'r') as file:
        data_xml = file.read()

    # Extract the name from the data XML
    data = json.loads(ET.fromstring(data_xml).text)[0]
    name = data['name']
    print(data, name)

    with open('response.xml', 'r') as file:
        response_xml = file.read()

    # Replace the placeholder with the extracted name
    response_tree = ET.fromstring(response_xml)
    say_element = response_tree.find('.//Say')
    if say_element is not None:
        say_element.text = say_element.text.replace('Friend', name)

    # Save the modified XML
    # with open('response.xml', 'w') as file:
    #     file.write(ET.tostring(response_tree).decode('utf-8'))
    output_xml = ET.tostring(response_tree, encoding='utf-8').decode('utf-8')
    output_xml = '<?xml version="1.0" encoding="UTF-8"?>\n' + output_xml

    with open('response.xml', 'w') as file:
        file.write(output_xml)



@app.route('/call')
def call():
    data = db_contact()
    json_data = json.dumps(data.data)
    with open('output.json', 'w') as outfile:
        json.dump(data.data, outfile)
    json_to_xml(json_data, root)
    tree = ET.ElementTree(root)
    
    # Save the XML to a file or print it
    tree.write("output.xml")
    reverst_data()
    data = json.loads(json_data)
    phone = data[2]['phone_number']
    name = data[2]['name']
    print("Test", phone)
    safe_call(phone, name)
    return Response(json_data)

if __name__ == '__main__':
    url: str = os.getenv("SUPABASE_URL")
    key: str = os.getenv("SUPABASE_KEY")
    supabase: Client = create_client(url, key)
    app.run(debug=True, host='0.0.0.0', port=8000)
