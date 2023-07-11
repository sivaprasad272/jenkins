#!/bin/bash

# Grant sudoers permission to the current user without password prompt
echo "$jenkins ALL=(ALL:ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$jenkins
sudo chmod 0440 /etc/sudoers.d/$jenkins

# Run the rest of your commands that require sudo
# ...
