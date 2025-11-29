pipeline {
    agent any

    environment {
        IMAGE_NAME = "nodejs-app"               // image name — you can customize
        CONTAINER_PORT = "3000"                // port your node app listens to
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'jenkins-reference', url: 'https://github.com/devunoorivignan24/Devops_Projects.git'
            }
        }

        stage('Install & Test') {
            steps {
                sh 'npm install'
                // if you have tests uncomment next line
                // sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${BUILD_NUMBER}")
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    // stop existing container if any
                    sh "docker rm -f ${IMAGE_NAME} || true"
                    // run the new container
                    sh "docker run -d --name ${IMAGE_NAME} -p ${CONTAINER_PORT}:${CONTAINER_PORT} ${IMAGE_NAME}:${BUILD_NUMBER}"
                }
            }
        }
    }

    post {
        success {
            echo "✅ Build, Docker image & deployment succeeded."
        }
        failure {
            echo "❌ Pipeline failed."
        }
    }
}
