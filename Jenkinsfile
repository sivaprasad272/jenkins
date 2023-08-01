pipeline {
    agent any

    environment {
        DOCKER_REGISTRY_URL = 'https://hub.docker.com/repository/docker/sivaprasad272/'
        DOCKER_HUB_CREDENTIALS = null
    }

    stages {
        stage('Load Docker Hub Credentials') {
            steps {
                // Load the secret file into the environment variable
                withCredentials([file(credentialsId: 'docker-hub-credentials', variable: 'DOCKER_HUB_CREDENTIALS')]) {
                    // The content of the secret file is now available in the 'DOCKER_HUB_CREDENTIALS' environment variable
                }
            }
        }
        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Authenticate Docker client to Docker Hub
                    sh "rm -rf $HOME/.docker/config.json"
                    sh "touch $HOME/.docker/config.json"
                    sh "echo '$DOCKER_HUB_CREDENTIALS' > $HOME/.docker/config.json"

                    // Build and push the Docker image
                    sh "docker build -t $DOCKER_REGISTRY_URL/my_image:latest ."
                    sh "docker push $DOCKER_REGISTRY_URL/my_image:latest"
                }
            }
        }
        stage('Pull Docker Image from Private Repo') {
            steps {
                script {
                    // Authenticate Docker client to Docker Hub for pulling from private repo
                    sh "echo '$DOCKER_HUB_CREDENTIALS' > $HOME/.docker/config.json"

                    // Pull the Docker image from the private repository
                    sh "docker pull $DOCKER_REGISTRY_URL/my_image:latest"
                }
            }
        }
        // Add more stages as needed for your pipeline
    }
}

