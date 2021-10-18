import sys
LOCAL_REQUIREMENTS_FILE = "/opt/requirements.local.txt"

try:
    local_dependencies = open(LOCAL_REQUIREMENTS_FILE, 'r')
    for local_dependency in local_dependencies:
        sys.path.insert(2, f'/opt/libraries/{local_dependency.rstrip()}')
except FileNotFoundError:
    pass
