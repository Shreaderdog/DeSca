import RPi.GPIO as GPIO
import time
GPIO.setmode(GPIO.BOARD)
GPIO.setwarnings(False)
ledPin = 12
GPIO.setup(ledPin, GPIO.OUT)
for i in range(5):
 print("drone is going east")
 GPIO.output(ledPin, GPIO.HIGH)
 time.sleep(0.5)
 print("LED turning off.")
 GPIO.output(ledPin, GPIO.LOW)
 time.sleep(0.5)
 for i in range(7):
  print("drone is going west")
  GPIO.output(ledPin, GPIO.HIGH)
  time.sleep(0.5)
  print("LED turning off.")
  GPIO.output(ledPin, GPIO.LOW)
  time.sleep(0.5)
 for i in range(2):
  print("drone is going north")
  GPIO.output(ledPin, GPIO.HIGH)
  time.sleep(0.5)
  print("LED turning off.")
  GPIO.output(ledPin, GPIO.LOW)
  time.sleep(0.5)
 for i in range(7):
  print("drone is going south")
  GPIO.output(ledPin, GPIO.HIGH)
  time.sleep(0.5)
  print("LED turning off.")
  GPIO.output(ledPin, GPIO.LOW)
  time.sleep(0.5)