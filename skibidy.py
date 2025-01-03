from djitellopy import Tello

me = Tello()
me.connect()
print(me.get_battery())

try:
    me.takeoff()
except Exception as e:
    print(f"Takeoff failed: {e}")
finally:
    me.end()
e