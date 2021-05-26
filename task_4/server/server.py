# import asyncio
import socket
import json
from statistics import mean


SERVER_ADDRESS = ('localhost', 43501)


def processing(incoming_array: list) -> list:
    output = [x for x in incoming_array if isinstance(x, int)]
    output.sort()
    output.append(mean(output))
    return output


def main() -> None:
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    sock.bind(SERVER_ADDRESS)
    sock.listen(1)
    conn, addr = sock.accept()
    while True:
        data = conn.recv(1024)
        if not data:
            break
        print('Recv: {}: {}'.format(len(data), data))
        array = json.loads(str(bytes.decode(data, encoding='UTF-8')))
        print(array)
        output = json.dumps(processing(array))
        print(output)
        conn.send(bytes(output, encoding='UTF-8'))
    conn.close()


if __name__ == '__main__':
    print('server is running, please, press ctrl+c to stop')
    while True:
        main()
