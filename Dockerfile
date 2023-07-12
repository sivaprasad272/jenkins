FROM ubuntu:latest

# Update the package lists and install Git
RUN apt-get update && \
    apt-get install -y git

# Set the working directory
WORKDIR /app

# Clone a Git repository (replace <repository_url> with your repository URL)
#RUN git clone <repository_url>

# Add any additional commands you need here

# Define the command to be executed when the container starts
#CMD ["/bin/bash"]
