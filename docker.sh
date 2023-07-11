

# Add current user to the docker group
sudo usermod -a -G docker $jenkins

sudo systemctl restart docker
