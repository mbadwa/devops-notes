#!/usr/bin/python3

import os

# Condition to check if users exist, if they don't create
user_list = ["alpha", "beta", "gamma"]

print("Adding users to system")
print("............................................................")

for user in user_list:
    exitcode = os.system(f"id {user}")
    if exitcode != 0:
        print(f"User {user} does not exist.")
        print("............................................................")
        print()
        os.system(f"sudo useradd {user}")
    else:
        print("User already exist, skipping...")
        print("............................................................")
        print()

# Condition to check if group exist and if not add it
exitcode = os.system("grep science /etc/group")
if exitcode != 0:
    print("Group science doesn't exist. Adding it.")
    print("............................................................")
    print()
    os.system("groupadd science")
else:
    print("Group science already exists. Skipping it.")
    print("............................................................")
    print()

# Condition to check if users are added to pertinent groups
for user in user_list:
    print(f"Attempting to add user {user} to science group")
    print("............................................................")
    print()
    os.system(f"usermod -G science {user}")
    if exitcode != 0:
        print(f"User {user} not in group science.")
        print("Adding user {user} to group science")
        print("............................................................")
        print()
    else:
        print(f"User {user} already added to science group. Skipping it.")
        print("............................................................")
        print()
# Creating directory
if os.path.isdir("/opt/science_dir"):
    print("Directory already exists, skipping it.")
    print("............................................................")
    print()
else:
    print("Creating directory")
    print("............................................................")
    print()
    os.mkdir("/opt/science_dir")
    print()

# Granting ownership and permissions
print("Assigining ownership to a directory")
print("............................................................")
print()
os.system("chown :science /opt/science_dir")
os.system("chmod 770 /opt/science_dir")
print()
