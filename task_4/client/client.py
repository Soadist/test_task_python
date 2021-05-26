import socket
import json

array = [1, '4', 5, 6, 'a', 'azaza', 12, 34, 0]
print('original array ' + str(array))
input_array = json.dumps(array)
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.connect(('localhost', 43501))
sock.send(bytes(input_array, encoding='UTF-8'))

data = sock.recv(1024)
sock.close()
output_array = data.decode(encoding='UTF-8')
print(json.loads(data))
