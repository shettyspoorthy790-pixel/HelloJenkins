pipeline {
    agent any

    tools {
        jdk 'openjdk 17.0.18'
        maven 'Maven3.8.7'
    }

    environment {
        AWS_REGION = 'ap-south-1'
        ACCOUNT_ID = '840597584147'
        ECR_REPO = 'testproject'
        IMAGE = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest"
        CLUSTER_NAME = 'my-clusters'
    }

    stages {

        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/shettyspoorthy790-pixel/HelloJenkins', branch: 'main'
            }
        }

        stage('Build Maven') {
            steps {
                echo "Building Java application using Maven 3.8.7..."
                sh 'mvn clean package'
            }
        }

        stage('Verify JAR') {
            steps {
                script {
                    def jarExists = fileExists 'target/hello-jenkins-1.0-SNAPSHOT.jar'
                    if (!jarExists) {
                        error "JAR file not found! Maven build failed or wrong name."
                    } else {
                        echo "JAR file exists, proceeding..."
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t ${ECR_REPO} ."
            }
        }

        stage('Login to ECR') {
            steps {
                sh """
                aws ecr get-login-password --region $AWS_REGION | \
                docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                """
            }
        }

        stage('Tag Docker Image') {
            steps {
                sh "docker tag ${ECR_REPO}:latest ${IMAGE}"
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "docker push ${IMAGE}"
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh """
                aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
                kubectl apply -f deployment.yaml
                """
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully! Docker image pushed and deployed."
        }
        failure {
            echo "Pipeline failed. Check logs for errors."
        }
    }
}
