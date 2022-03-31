import socket

TCP_IP = "192.168.1.103"
TCP_PORT = 1025
BUFFER_SIZE = 1024

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((TCP_IP, TCP_PORT))
print("connected: ", s)
data = s.recv(BUFFER_SIZE)
s.close()
print("received data: ", data)