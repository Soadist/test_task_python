import socketserver
import logging
import processors as p
import params as par


class MyTCPHandler(socketserver.StreamRequestHandler):
    def handle(self):
        self.data = b''
        while True:
            chunk = self.request.recv(1024)
            if not chunk:
                break
            self.data += chunk
            if b'\n' in self.data:
                break
        logging.info(
            'Received {} bytes from {}'.format(
                len(self.data),
                self.client_address
            )
        )
        response = p.combine(self.data)
        self.request.send(response)
        logging.info(
            'Sent {} bytes to {}'.format(
                len(response),
                self.client_address
            )
        )


if __name__ == "__main__":
    logging.basicConfig(
        filename='last.log',
        format='%(asctime)s %(levelname)s %(message)s',
        datefmt='%Y/%m/%d %H:%M:%S',
        level=logging.INFO
    )
    logging.info('Started')
    args = par.params.parse_args()
    server = socketserver.TCPServer((args.server, args.port), MyTCPHandler)
    print('starting server... for exit press Ctrl+C')
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        logging.info('CTRL+C exit')
        exit()
    except Exception as e:
        logging.exception(e)
        print(e)
