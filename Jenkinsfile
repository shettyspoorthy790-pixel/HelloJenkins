pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        AWS_ACCOUNT_ID = '840597584147'
        ECR_REPO = 'hello-jenkins'
        IMAGE = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest"
        CLUSTER_NAME = 'my-clusters'
        MAVEN_HOME = tool name: 'Maven3.8.7', type: 'maven'
        JAVA_HOME = tool name: 'openjdk 17.0.18', type: 'jdk'
        PATH = "${MAVEN_HOME}/bin:${JAVA_HOME}/bin:${env.PATH}"
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
                sh 'docker build -t hello-jenkins .'
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION | \
                docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                '''
            }
        }

        stage('Tag Docker Image') {
            steps {
                sh "docker tag hello-jenkins $IMAGE"
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "docker push $IMAGE"
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
                kubectl apply -f deployment.yaml
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully: Docker image pushed and deployed to EKS."
        }
        failure {
            echo "Pipeline failed. Check logs for errors."
        }
    }
}
