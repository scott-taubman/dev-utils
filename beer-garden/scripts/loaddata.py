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

p1_operator = User(username="p1-operator")
p1_operator.set_password("password")
p1_operator.role_assignments = [p1_operator_ra1]
try:
    p1_operator.save()
except NotUniqueError:
    print("p1-operator already exists")

p1_read_only = User(username="p1-read")
p1_read_only.set_password("password")
p1_read_only.role_assignments = [p1_read_only_ra1]
try:
    p1_read_only.save()
except NotUniqueError:
    print("p1-read already exists")

p1c1_read_only = User(username="p1c1-read")
p1c1_read_only.set_password("password")
p1c1_read_only.role_assignments = [p1_read_only_ra1, c1_read_only_ra1]
try:
    p1c1_read_only.save()
except NotUniqueError:
    print("p1c1-read already exists")

echo_operator = User(username="echo-operator")
echo_operator.set_password("password")
echo_operator.role_assignments = [echo_operator_ra1]
try:
    echo_operator.save()
except NotUniqueError:
    print("echo-operator already exists")

global_read_only = User(username="global-read")
global_read_only.set_password("password")
global_read_only.role_assignments = [global_read_only_ra1]
try:
    global_read_only.save()
except NotUniqueError:
    print("global-read already exists")

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
except Garden.DoesNotExist:
    print("No garden named child1 found")

try:
    child2 = Garden.objects.get(name="child2")
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
except Garden.DoesNotExist:
    print("No garden named child2 found")
