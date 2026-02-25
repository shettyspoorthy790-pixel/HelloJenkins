pipeline {
    agent any

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

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t testproject ."
            }
        }

        stage('Login to ECR') {
            steps {
                echo "Logging into AWS ECR..."
                sh '''
                aws ecr get-login-password --region $AWS_REGION | \
                docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                '''
            }
        }

        stage('Tag Docker Image') {
            steps {
                echo "Tagging Docker image..."
                sh "docker tag testproject:latest $IMAGE"
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "Pushing Docker image to ECR..."
                sh "docker push $IMAGE"
            }
        }

        stage('Deploy to EKS') {
            steps {
                echo "Deploying to EKS..."
                sh '''
                aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
                kubectl apply -f deployment.yaml
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully! Docker image pushed and deployed to EKS."
        }
        failure {
            echo "Pipeline failed. Check logs for errors."
        }
    }
}
