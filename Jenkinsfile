pipeline {
    agent any

    tools {
        maven 'Maven3.8.7'    // Your Jenkins Maven tool name
        jdk 'openjdk 17.0.18' // Your Jenkins JDK tool name
    }

    environment {
        DOCKER_IMAGE = "hello-jenkins"
        ECR_REPO = "840597584147.dkr.ecr.ap-south-1.amazonaws.com/testproject"
        AWS_REGION = "ap-south-1"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out code from GitHub..."
                git url: 'https://github.com/shettyspoorthy790-pixel/HelloJenkins', branch: 'main'
            }
        }

        stage('Build Maven') {
            steps {
                echo "Building Java application using Maven 3.8.7..."
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Login to ECR') {
            steps {
                echo "Logging in to AWS ECR..."
                sh """
                    aws ecr get-login-password --region ${AWS_REGION} | \
                    docker login --username AWS --password-stdin ${ECR_REPO}
                """
            }
        }

        stage('Tag Docker Image') {
            steps {
                echo "Tagging Docker image for ECR..."
                sh "docker tag ${DOCKER_IMAGE}:latest ${ECR_REPO}:latest"
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "Pushing Docker image to ECR..."
                sh "docker push ${ECR_REPO}:latest"
            }
        }

        stage('Deploy to EKS') {
            steps {
                echo "Deploy stage — add kubectl commands here if needed"
                // Example: sh "kubectl apply -f k8s/deployment.yaml"
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Check logs for errors."
        }
    }
}
