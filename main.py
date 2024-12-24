from djitellopy import Tello
import cv2

tello = Tello()

tello.connect()

tello.takeoff()

print(tello.get_battery())

