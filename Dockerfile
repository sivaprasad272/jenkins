FROM ubuntu:latest

# Update the package lists and install Git
RUN apt-get update && \
    apt-get install -y git

# Install Java
RUN apt-get install -y openjdk-11-jdk

# Set the JAVA_HOME environment variable
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

# Clone a Git repository (replace <repository_url> with your repository URL)
#RUN git clone <repository_url>

# Change the working directory to the cloned repository
#WORKDIR /path/to/cloned/repository

# Add any additional commands you need here

# Define the command to be executed when the container starts
CMD ["/bin/bash"]
