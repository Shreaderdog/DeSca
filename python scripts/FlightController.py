import time
import socket
import json
import RPi.GPIO as GPIO
import time
from sensorToBlockchain import BUFFER_SIZE
from web3 import Web3

with open("abis/DAO.json") as f:
    info_json = json.load(f)
abi = info_json["abi"]

with open(".conf") as j:
    config = json.load(j)

host = 'http://' + config["provider_address"] + ":8545"
w3 = Web3(Web3.HTTPProvider(host))

contractaddress = Web3.toChecksumAddress(config["contract_bc_address"])

my_address = config["local_bc_address"]

contract = w3.eth.contract(address=contractaddress, abi=abi)
while (true):
    time.sleep(10)
    flight = contract.functions.flightflag().call({'from': my_address})
    
    if flight:
        fly()


def fly():

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
