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

        stage('Clone') {
            steps {
                git url: 'https://github.com/shettyspoorthy790-pixel/HelloJenkins', branch: 'main'
            }
        }

        stage('Build Maven') {
            steps {
                // Use the Maven installation 3.8.7 from Jenkins
                withMaven(maven: 'Maven-3.8.7') {
                    sh 'mvn clean package'
                }
            }
        }

        stage('Build Docker') {
            steps {
                sh 'docker build -t testproject .'
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION | \
                docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                '''
            }
        }

        stage('Tag Image') {
            steps {
                sh 'docker tag testproject:latest $IMAGE'
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push $IMAGE'
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
                kubectl apply -f deployment.yaml
                kubectl get pods -w
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully: Docker image pushed and deployed!"
        }
        failure {
            echo "Pipeline failed. Check the logs for errors."
        }
    }
}
