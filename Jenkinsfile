pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE_NAME = 'sivaprasad272/privaterepo'
        DOCKER_IMAGE_TAG = "latest-${env.BUILD_NUMBER}"
        GIT_URL = 'https://github.com/sivaprasad272/jenkins.git'
        AWS_REGION = 'us-east-1'
        AWS_ACCOUNT_ID = 'your_aws_account_id'
        ECR_REPO_NAME = 'jenkins'
    }
    
    stages {
        stage('Cloning Git Code') {
            steps {
                git url: "${GIT_URL}"
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Load the Docker Hub credentials into the correct location
                    withCredentials([file(credentialsId: 'docker-hub-credentials', variable: 'DOCKER_HUB_CREDENTIALS')]) {
                        sh 'echo "$DOCKER_HUB_CREDENTIALS" > $HOME/.docker/config.json'
                    }

                    // Build the Docker image
                    sh "docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ."
                }
            }
        }
        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_HUB_CREDENTIALS) {
                        sh "docker push ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
                    }
                }
            }
        }
        //stage('Push Docker Image to AWS ECR') {
            steps { 
                script {
                    // Authenticate Docker client to AWS ECR
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

                    // Tag the Docker image with the ECR repository URI
                    def ecrImageUri = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}:${DOCKER_IMAGE_TAG}"
                    sh "docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${ecrImageUri}"

                    // Push the Docker image to AWS ECR
                    sh "docker push ${ecrImageUri}"
                }
            }
        } //
        stage('Clean Up Local Image') {
            steps {
                sh "docker rmi ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
            }
        }
        stage('Pull Docker Image from Docker Hub') {
            steps {
                sh "docker pull ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
            }
        }
        stage('Clean Up Local Container') {
            steps {
                sh "docker rm -f ${DOCKER_IMAGE_NAME}"
            }
        }
        stage('Run Docker Container') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_HUB_CREDENTIALS) {
                        sh "docker run -itd --name ${DOCKER_IMAGE_TAG} ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} /bin/bash"
                    }
                }
            }
        }
        stage('Remove Docker Container') {
            steps {
                sh "docker rm -f ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
            }
        }
    }
}