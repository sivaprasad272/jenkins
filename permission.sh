#!/bin/bash

# Get the current username
username=$(whoami)

# Grant sudoers permission to the current user
echo "$username ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers
