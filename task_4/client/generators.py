def str_to_array(string):
    array = []
    try:
        for x in string.lstrip('[').rstrip(']').split(','):
            if '"' in x or "'" in x or '.' in x or x == ' ':
                array.append(x)
            elif x == '':
                array.append(None)
            else:
                array.append(int(x))
        return array
    except ValueError as e:
        print('Invalid array')
        return e
    except Exception as e:
        print(e)
        return e
