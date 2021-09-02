import json
import typing
from . import cargo_diagnostic, test_result

def is_build_successful(input_json: dict) -> bool:
    '''
    Returns true if the cargo build was successful, false otherwise.
    '''
    assert input_json['reason'] == 'build-finished'
    return input_json['success']

def get_test_summary(input_json: dict) -> typing.Tuple[int, int]:
    '''
    Returns a tuple (x, y) where x is the number of tests that passed and y
    is the number of tests that failed
    '''
    assert input_json['type'] == 'suite'
    return input_json['passed'], input_json['failed']

def construct_output(score: int, passed: int, failed: int, 
    results: typing.List[test_result.TestResult],
    warnings: typing.List[cargo_diagnostic.CargoDiagnostic],
    build_successful) -> dict:
    output = {}
    output['gradeable'] = True
    if build_successful:
        if warnings:
            output['message'] = ('Build was successful, but there were warnings! '
                f'{passed} tests passed, {failed} tests failed.')
        else:
            output['message'] = ('Build was successful! '
                f'{passed} tests passed, {failed} tests failed.')
        output['score'] = score
    else:
        output['message'] = ('Build was unsuccessful! Tests did not run. '
            'Please fix the relevant errors and try to run your solution again.')
        output['score'] = 0
    
    warnings.sort(key=lambda x: x.level)
    output['output'] = '\n'.join([str(warning) for warning in warnings])
    output['tests'] = [test.to_dict() for test in results]
    return output

def convert_to_pl_json(input_json: str, test_values_json: str) -> dict:
    '''
    Takes a path to a cargo test json file and converts it to a PL readable json dict.
    
    Parameters
    ----------
    input_json (str) : the path to the json output of cargo test.
    test_values_json (str) : the path to the json file containing test point values.
    '''
    with open(test_values_json, 'r') as f:
        point_values = json.load(f)
    build_successful = False
    passed = 0
    failed = 0
    warnings = []
    results = []
    with open(input_json, 'r') as f:
        for line in f:
            j = json.loads(line)
            if 'reason' in j:
                if j['reason'] == 'compiler-mesage':
                    warnings.append(cargo_diagnostic.CargoDiagnostic(j))
                elif j['reason'] == 'build-finished':
                    build_successful = is_build_successful(j)
            elif 'type' in j:
                if j['event'] == 'started':
                    pass
                elif j['type'] == 'test':
                    results.append(test_result.TestResult(j, point_values[j['name']]))
                elif j['type'] == 'suite':
                    passed, failed = get_test_summary(j)
    score = sum((test.score() for test in results))
    return construct_output(score, passed, failed, results, warnings, build_successful)