import json
import os

import beer_garden.config
from beer_garden.db.mongo.api import to_brewtils
from beer_garden.db.mongo.models import (Garden, Job, Request, Role,
                                         RoleAssignment, System, User,
                                         UserToken)
from brewtils.schemas import (RoleAssignmentSchema, RoleSchema, UserListSchema,
                              UserSchema)
from mongoengine import connect, disconnect

hostname = os.uname().nodename

connect(db=f"{hostname}", host="mongodb://mongodb")
beer_garden.config.load(
    ["-c", f"../conf/{hostname}.yaml", "-l", "../conf/app-logging.yaml"]
)
