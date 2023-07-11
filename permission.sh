#!/bin/bash

# Grant sudoers permission to the current user without password prompt
echo "$USER ALL=(ALL:ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USER
sudo chmod 0440 /etc/sudoers.d/$USER

# Run the rest of your commands that require sudo
# ...
