pipeline {
    agent any

    environment {
        IMAGE = "node_app:1.1"
        TAG   = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps { checkout scm }
        }

        stage('Build Image') {
            steps {
                sh 'docker build -t $IMAGE:$TAG -t $IMAGE:latest .'
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    docker rm -f demo || true
                    docker run -d --name demo -p 8081:3000 $IMAGE:$TAG
                '''
            }
        }

        stage('Smoke Test') {
            steps {
                sh '''
                    sleep 5
                    curl -f http://localhost:8081/health
                '''
            }
        }
    }

    post {
        success { echo "Deployed build ${env.BUILD_NUMBER}" }
        failure { echo "Build failed, check the console output" }
    }
}