import cv2 as cv
import time
from PoseDetector.PoseModule import PoseDetector

capture = cv.VideoCapture(0)
pTime = 0
pose = PoseDetector()

while True:
    sucess, img = capture.read()
    img = pose.findPose(img)
    lmlist = pose.getPosition(img)
    print(lmlist)


    cTime = time.time()

    fps = 1 / (cTime - pTime)

    pTime = cTime



    cv.putText(img, str(int(fps)), (50, 50), cv.FONT_HERSHEY_SIMPLEX, 1, (255, 0, 0), 3)

    cv.imshow("Image", img)

    cv.waitKey(1)
