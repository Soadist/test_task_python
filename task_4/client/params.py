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
exclusive = params.add_mutually_exclusive_group()
exclusive.add_argument(
    '-f',
    '--file=',
    dest='file',
    type=str,
    default=None,
    help='input file'
)
exclusive.add_argument(
    '-i',
    '--input',
    type=str,
    default=None,
    dest='array',
    help='"array" in args for input'
)
exclusive.add_argument(
    '-I',
    '--interactive',
    dest='interactive',
    action='store_true',
    default=False,
    help='interactive input'
)
