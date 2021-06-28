import argparse
import json
import pathlib
from src import parse_cargo_test_json

def check_json_path(path_str: str) -> str:
    '''
    Checks that the input path string is a valid file path to a .json file.
    If not, raises an argparse.ArgumentTypeError.

    Parameters
    ----------
    path_str (str) : a string representing a file path.
    '''
    path = pathlib.Path(path_str)
    if path.is_file():
        if path.suffix.lower() != '.json':
            raise argparse.ArgumentTypeError(f'Expected .json file, found {path.suffix}.')
    else:
        raise argparse.ArgumentTypeError(f'{path} is not a valid file path.')
    return path

# create an argument parser
parser = argparse.ArgumentParser(description='''Converts the .json output of `cargo test` to a PL-readable .json file.''')


# argument for the file path of the input cargo test .json file
parser.add_argument('input_json', metavar='I', type=check_json_path)

# argument for the file path of the test point values .json file
parser.add_argument('test_point_json', metavar='T', type=check_json_path)

# argument for the file path of the output results.json file
parser.add_argument('output_json', metavar='O', type=str)

# parse the command line arguments
args = parser.parse_args()

# convert the cargo json to a PL readable json file and write it to the output file.
with open(args.output_json, 'w') as output_file:
    json.dump(parse_cargo_test_json.convert_to_pl_json(args.input_json,
        args.test_point_json), output_file)