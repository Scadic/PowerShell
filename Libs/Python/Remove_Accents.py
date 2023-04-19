from sys import exit, argv
from Remove_Accents import remove_accents

def __process_args__(args=[]):
    if len(args) >= 2:
        return args[1:]
    else:
        print("Not enough arguments passed!")
        exit(0)

if __name__ == "__main__":
    strings = __process_args__(argv)
    for s in strings:
        print(remove_accents(s))