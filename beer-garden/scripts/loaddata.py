import os

from beer_garden.db.mongo.models import Garden, Role, RoleAssignment, User
from mongoengine import connect, NotUniqueError

hostname = os.uname().nodename
connect(db=f"{hostname}", host="mongodb://mongodb")

############################
# User setup
############################
read_only = Role.objects.get(name="read_only")
operator = Role.objects.get(name="operator")
superuser = Role.objects.get(name="superuser")

p1_read_only_ra1 = RoleAssignment(
    role=read_only, domain={"scope": "Garden", "identifiers": {"name": "parent1"}}
)
p1_operator_ra1 = RoleAssignment(
    role=operator, domain={"scope": "Garden", "identifiers": {"name": "parent1"}}
)
c1_read_only_ra1 = RoleAssignment(
    role=read_only, domain={"scope": "Garden", "identifiers": {"name": "child1"}}
)
echo_operator_ra1 = RoleAssignment(
    role=operator, domain={"scope": "System", "identifiers": {"name": "echo"}}
)
global_read_only_ra1 = RoleAssignment(role=read_only, domain={"scope": "Global"})
admin_ra1 = RoleAssignment(role=superuser, domain={"scope": "Global"})

p1pluginrunner = User(username="p1pluginrunner")
p1pluginrunner.set_password("password")
p1pluginrunner.role_assignments = [p1_operator_ra1, global_read_only_ra1]
try:
    p1pluginrunner.save()
except NotUniqueError:
    print("p1pluginrunner already exists")

p1reader = User(username="p1reader")
p1reader.set_password("password")
p1reader.role_assignments = [p1_read_only_ra1]
try:
    p1reader.save()
except NotUniqueError:
    print("p1reader already exists")

p1c1reader = User(username="p1c1reader")
p1c1reader.set_password("password")
p1c1reader.role_assignments = [p1_read_only_ra1, c1_read_only_ra1]
try:
    p1c1reader.save()
except NotUniqueError:
    print("p1c1reader already exists")

echooperator = User(username="echooperator")
echooperator.set_password("password")
echooperator.role_assignments = [echo_operator_ra1]
try:
    echooperator.save()
except NotUniqueError:
    print("echooperator already exists")

admin = User(username="admin")
admin.set_password("password")
admin.role_assignments = [admin_ra1]
try:
    admin.save()
except NotUniqueError:
    print("admin already exists")

############################
# Garden setup
############################
try:
    child1 = Garden.objects.get(name="child1")
except Garden.DoesNotExist:
    child1 = Garden(name="child1")

child1.connection_type = "HTTP"
child1.connection_params = {
    "http": {
        "port": 2447,
        "ssl": False,
        "url_prefix": "/",
        "ca_verify": False,
        "host": "bg-child1",
    },
}
child1.save()
print("child1 connection configured")

try:
    child2 = Garden.objects.get(name="child2")
except Garden.DoesNotExist:
    child2 = Garden(name="child2")

child2.connection_type = "STOMP"
child2.connection_params = {
    "stomp": {
        "headers": [{}],
        "host": "activemq",
        "port": 61613,
        "send_destination": "bg-child2-sub",
        "subscribe_destination": "bg-child2-send",
        "username": "beer_garden",
        "password": "password",
    },
}
child2.save()
print("child2 connection configured")
