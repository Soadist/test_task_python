import argparse


params = argparse.ArgumentParser()
params.add_argument(
    '-s',
    '--server',
    default='localhost',
    help='server address'
)
params.add_argument(
    '-p',
    '--port',
    default=43501,
    help='server port'
)
