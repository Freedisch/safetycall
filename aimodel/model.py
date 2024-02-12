from flask import Flask, render_template, Response
import cv2
import numpy as np
import time
import PoseModule as pm
import os
from supabase import create_client, Client

app = Flask(__name__)
cap1 = cv2.VideoCapture(0)


def generate_frames(cap):
    fall = False
    detector = pm.poseDetector()
    pTime = 0

    while True:
        success, img = cap.read()
        img = cv2.resize(img, (1280, 550))
        img = detector.findPose(img, False)
        lmList = detector.findPosition(img, False)

        if len(lmList) != 0:
            # Right Arm
            angle = detector.findAngle(img, 12, 24, 26)
            if angle < 80:
                fall = True
            elif angle > 280:
                fall = True
            else:
                fall = False
                
        cTime = time.time()
        fps = 1 / (cTime - pTime)
        pTime = cTime
        cv2.putText(img, str(int(fps)), (50, 100), cv2.FONT_HERSHEY_PLAIN, 5,
                    (255, 0, 0), 5)
        ret, buffer = cv2.imencode('.jpg', img)
        frame = buffer.tobytes()
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/video1')
def video1():
    return Response(generate_frames(cap1), mimetype='multipart/x-mixed-replace; boundary=frame')


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8000)
