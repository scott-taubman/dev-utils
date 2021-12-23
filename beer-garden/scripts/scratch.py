import json
import os

import beer_garden.config
from beer_garden.db.mongo.api import to_brewtils
from beer_garden.db.mongo.models import (File, Garden, Job, RawFile, Request, Role,
                                         RoleAssignment, System, User, UserToken)
from brewtils.schemas import (RoleAssignmentSchema, RoleSchema, UserListSchema,
                              UserSchema)
from brewtils.rest.client import RestClient
from brewtils.rest.easy_client import EasyClient
from mongoengine import connect, disconnect

hostname = os.uname().nodename

connect(db=f"{hostname}", host="mongodb://mongodb")
beer_garden.config.load(
    ["-c", f"../conf/{hostname}.yaml", "-l", "../conf/app-logging.yaml"]
)

ec = EasyClient(bg_host="localhost", bg_port=2337, ssl_enabled=False)
rc = RestClient(bg_host="localhost", bg_port=2337, ssl_enabled=False)
