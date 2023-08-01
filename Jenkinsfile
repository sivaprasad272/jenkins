pipeline {
    agent any
    
    environment {
        DOCKER_HUB_CREDENTIALS = 'docker-hub-credentials'
        DOCKER_IMAGE_NAME = 'sivaprasad272/privaterepo'
        DOCKER_IMAGE_TAG = "latest-${env.BUILD_NUMBER}"
        GIT_URL = 'https://github.com/sivaprasad272/jenkins.git'
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
                     steps {
                    // Load the config.json file into the correct location
                    withCredentials([file(credentialsId: 'docker-config', variable: 'DOCKER_CONFIG_JSON')]) {
                    sh 'echo "$DOCKER_CONFIG_JSON" > $HOME/.docker/config.json'
                }
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_HUB_CREDENTIALS) {
                        sh "docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ."
                    }
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_HUB_CREDENTIALS) {
                        sh "docker push ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
                    }
                }
            }
        }
        //
        stage('Push Docker Image to aws ecr') {
            steps { 
                script {
                    def awsRegion = 'us-east-1'
                    def awsAccountId = '845075699558'
                    def ecrRepoName = 'jenkins'
                
                // Authenticate Docker client to AWS ECR
                    sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 845075699558.dkr.ecr.us-east-1.amazonaws.com"
                
                // Tag the Docker image with the ECR repository URI
                    def ecrImageUri = "${awsAccountId}.dkr.ecr.${awsRegion}.amazonaws.com/${ecrRepoName}:${DOCKER_IMAGE_TAG}"
                    sh "docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${ecrImageUri}"
                
                // Push the Docker image to AWS ECR
                    sh "docker push ${ecrImageUri}" //
                }
            }
        } //
        stage('Clean Up Local Image') {
            steps {
                script {
                    sh "docker rmi ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
                }
            }
        }
        stage('Prepare Environment') {
            steps {
                // Copy the config.json file to the Jenkins workspace
                stash(name: 'config', includes: '.docker/config.json')
            }
        }
        stage('Build and Push Docker Image') {
            steps {
                // Unstash the config.json file in the Docker container
                unstash('config')
                sh 'docker push https://hub.docker.com/repository/docker/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG'
            }
        }
        stage('Clean Up Local container') {
            steps {
                script {
                    sh "docker rm -f ${DOCKER_IMAGE_NAME}"
                }
            }
        }
        stage('run docker container') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/',) {
                        sh "docker run -itd --name ${DOCKER_IMAGE_TAG}  ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} /bin/bash"
                    }
                }
            }
        }   
         stage('remove docker container') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/',) {
                        sh "docker rm -f ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
                    }
                }
            }
        }    
    }   
}
