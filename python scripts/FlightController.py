import time
import socket
import json
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
    print("we flyin!")
