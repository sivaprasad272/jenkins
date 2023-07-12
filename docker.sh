

# Add current user to the docker group
sudo -S usermod -a -G docker $jenkins

#sudo -S systemctl restart docker
