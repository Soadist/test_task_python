import socket
import json
import params as p
import generators as g


class Worker:
    def __init__(self, server, port):
        self.server = server
        self.port = port

    def send(self, array):
        self.sock.send(bytes(json.dumps(array) + '\n', encoding='UTF-8'))

    def connect(self):
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.connect((self.server, self.port))

    def disconnect(self):
        self.sock.close()

    def receive(self):
        self.data = b''
        while chunk := self.sock.recv(1024):
            self.data += chunk
            if b'\n' in self.data:
                break
        output_array = self.data.decode(encoding='UTF-8')
        print(json.loads(output_array))

    def round(self, array):
        try:
            self.connect()
            self.send(array)
            self.receive()
            self.disconnect()
        except Exception as e:
            print(e)


def interactive_mode(worker):
    try:
        while True:
            print('Input array, delimiter ", ", CTRL+C to exit')
            input_line = input()
            array = g.str_to_array(input_line)
            if isinstance(array, Exception):
                continue
            worker.round(array)
    except Exception as e:
        print(e)


def file_mode(file, worker):
    try:
        with open(file, 'r') as f:
            while string := f.readline():
                if string.isspace():
                    continue
                array = g.str_to_array(string.rstrip('\n'))
                if isinstance(array, Exception):
                    continue
                worker.round(array)
    except FileNotFoundError:
        print(str(file + ' NOT FOUND'))
    except IsADirectoryError:
        print(str(file + ' DIR NOT FILE'))
    except PermissionError:
        print(str(file + ' ACCESS DENIED'))
    except Exception as e:
        print(e)


if __name__ == '__main__':
    try:
        args = p.params.parse_args()
        worker = Worker(args.server, args.port)
        if args.file:
            file_mode(args.file, worker)
        if args.array:
            array = g.str_to_array(args.array)
            if isinstance(array, Exception):
                exit()
            worker.round(array)
        if args.interactive:
            interactive_mode(worker)
    except KeyboardInterrupt:
        exit()
