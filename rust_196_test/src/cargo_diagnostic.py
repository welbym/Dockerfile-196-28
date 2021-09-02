import enum

class CargoDiagnosticType(enum.Enum):
    ERROR = 'error'
    WARNING = 'warning'
    NOTE = 'note'
    HELP = 'help'
    FAILURE_NOTE = 'failure-note'

class CargoDiagnostic:
    '''
    Defines a single Cargo json output, corresponding to a single line (json string)
    in the cargo output.
    '''
    def __init__(self, json_input: dict) -> None:
        assert json_input['reason'] == self.reason
        self.name = json_input['name']
        self.level = CargoDiagnosticType(json_input['level'])
        self.message = json_input['rendered']
    
    def __str__(self) -> str:
        return self.message