import enum
import json

class TestResultType(enum.Enum):
    IGNORED = 'ingored'
    SUCCESS = 'ok'
    FAILURE = 'failed'

class TestResult:
    def __init__(self, json_input: dict, point_value: int) -> None:
        self.name = json_input['name']
        self.result = TestResultType(json_input['event'])
        if self.result != TestResultType.IGNORED:
            self.point_value = point_value
        else:
            self.point_value = 0
        self.std_out = json_input['stdout'] if 'stdout' in json_input else None
    
    def score(self) -> int:
        return self.point_value if self.result == TestResultType.SUCCESS else 0
    
    def to_dict(self) -> dict:
        output = {}
        score = self.score()
        output['name'] = self.name
        output['points'] = score
        output['max_points'] = self.point_value
        if score == self.point_value:
            output['message'] = f'Success! Test [{self.name}] passed.'
        else:
            output['message'] = f'Test [{self.name}] failed. See output below.'
        if self.std_out:
            output['output'] = self.std_out
        return output