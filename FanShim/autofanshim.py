#!/usr/bin/python3

import time, datetime
from fanshim import FanShim
from gpiozero import CPUTemperature


'''
Uses fanshim for cooling raspberry pi from Pimoroni.
When  the pi reaches 70 F, cools for 60 seconds and
LED on fanshim lights up a muted white while fan runs.
When 60 second fan runtime ends, fan and LED turn off.
Temp is checked every 5 seconds when fan not running.

Make file executable, and schedule to run at boot. 
'''

fanshim = FanShim()
cpu = CPUTemperature()

while True:
    if cpu.temperature >= 70:
        fanshim.set_fan(True)
        fanshim.set_light(50, 50, 50) # rgb 255
        time.sleep(60)
        fanshim.set_light(0, 0, 0) # rgb 255
    else:
        fanshim.set_fan(False)
        time.sleep(5)