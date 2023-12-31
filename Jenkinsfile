pipeline {
    agent any

    environment {
        DOCKER_REGISTRY_URL = 'https://hub.docker.com/repository/docker/sivaprasad272/privaterepo'
    }

    stages {
        stage('Load Docker Hub Credentials') {
            steps {
                // Load the secret file into the environment variable
                withCredentials([file(credentialsId: 'docker-hub-credentials', variable: 'DOCKER_HUB_CREDENTIALS')]) {
                    // Write the Docker Hub credentials to the config.json file
                    sh 'echo "$DOCKER_HUB_CREDENTIALS" > $HOME/.docker/config.json'
                }
            }
        }
        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Build and push the Docker image
                    sh "docker build -t ${DOCKER_REGISTRY_URL}:latest ."
                    sh "docker push ${DOCKER_REGISTRY_URL}:latest"
                }
            }
        }
        stage('Pull Docker Image from Private Repo') {
            steps {
                script {
                    // Authenticate Docker client to Docker Hub for pulling from the private repository
                    sh 'echo "$DOCKER_HUB_CREDENTIALS" > $HOME/.docker/config.json'

                    // Pull the Docker image from the private repository
                    sh "docker pull ${DOCKER_REGISTRY_URL}:latest"
                }
            }
        }
        // Add more stages as needed for your pipeline
    }
}
