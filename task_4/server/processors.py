import json
from statistics import StatisticsError, mean
import logging


def array_processing(incoming_array):
    output = [x for x in incoming_array if isinstance(x, int)]
    if len(output) == 0:
        return 'Array does not contain integers'
    try:
        output.sort()
        output.append(mean(output))
    except StatisticsError as e:
        logging.exception(e)
        return str(e)
    except Exception as e:
        logging.exception(e)
        return str(e)
    return output


def combine(byte_string):
    try:
        json_array = json.loads(byte_string)
        array = array_processing(json_array)
        output = json.dumps(array)
        return bytes(output + '\n', encoding='UTF-8')
    except Exception as e:
        logging.exception(e)
