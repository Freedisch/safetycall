from flask import Flask, render_template, Response
import cv2
import mediapipe as mp
import time

app = Flask(__name__)

mpDraw = mp.solutions.drawing_utils
mpPose = mp.solutions.pose
pose = mpPose.Pose()
cap1 = cv2.VideoCapture(1)
pTime = 0

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
                # Use putText() method for
                # inserting text on video
                cv2.putText(img,
                            'NO FALL DETECTED',
                            (100, 100),
                            font, 1,
                            (0, 255, 0),
                            2,
                            cv2.LINE_4)
                print("No fall detected")
            else:
                cv2.putText(img,
                            'FALL DETECTED',
                            (50, 50),
                            font, 1,
                            (255, 0, 0),
                            2,
                            cv2.LINE_4)
                print("Fall detected")
        cTime = time.time()
        fps = 1 / (cTime - pTime)
        pTime = cTime
        cv2.putText(img, str(int(fps)), (70, 50),
                    cv2.FONT_HERSHEY_PLAIN, 3, (255, 0, 0), 3)
        cv2.imshow("Image", img)
        if cv2.waitKey(1) == 27:  # press 'esc' to exit the loop
            break
        ret, buffer = cv2.imencode('.jpg', img)
        frame = buffer.tobytes()
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')

    cap.release()
    cv2.destroyAllWindows()


@app.route('/video2')
def video2():
    return Response(detect_fall(cap1), mimetype='multipart/x-mixed-replace; boundary=frame')


@app.route('/')
def index():
    return render_template('index.html')


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8000)
