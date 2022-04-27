import time
import socket
import json
from web3 import Web3

TCP_PORT = 1025
BUFFER_SIZE = 1024


with open("abis/DeSCA.json") as f:
    info_json = json.load(f)
abi = info_json["abi"]

with open(".conf") as j:
    config = json.load(j)

host = 'http://' + config["provider_address"] + ":8545"
w3 = Web3(Web3.HTTPProvider(host))

contractaddress = Web3.toChecksumAddress(config["contract_bc_address"])

sensordata = config["sensor_addresses"]

contract = w3.eth.contract(address=contractaddress, abi=abi)

while (true):
    time.sleep(10)
    for x in range(len(config["sensor_addresses"])):
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.connect((address, TCP_PORT))
            data = s.recv(BUFFER_SIZE) * 100
            sensordata[x] = data
            s.close()
        except:
            sensordata[x] = -10000
    for x in range(len(config["sensor_bc_addresses"])):
        contract.functions.reportData(sensordata[x]).transact({'from': config["sensor_bc_addresses"][x]})
