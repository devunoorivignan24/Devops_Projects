pipeline {
    agent any

    environment {
        APP_NAME = "nodejs-app"
        PORT = "3000"
        HEALTHCHECK_URL = "http://localhost:3000"     // Update if your app uses another endpoint
    }

    stages {

        stage('Checkout Source') {
            steps {
                git branch: 'jenkins-reference', url: 'https://github.com/devunoorivignan24/Devops_Projects.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                echo "Running tests (if any)..."
                // Uncomment if your project has tests:
                // sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker Image..."
                    docker_image = docker.build("${APP_NAME}:${BUILD_NUMBER}")
                }
            }
        }

        stage('Deploy to GCP VM') {
            steps {
                script {
                    echo "Stopping old container if exists..."
                    sh """
                        docker ps -q --filter "name=${APP_NAME}" | grep -q . && docker stop ${APP_NAME} || true
                        docker rm -f ${APP_NAME} || true
                    """

                    echo "Starting new container..."
                    sh """
                        docker run -d \
                        --name ${APP_NAME} \
                        -p ${PORT}:${PORT} \
                        ${APP_NAME}:${BUILD_NUMBER}
                    """

                    echo "Waiting 5 seconds before health check..."
                    sleep 5
                }
            }
        }

        stage('Health Check') {
            steps {
                script {
                    echo "Performing health check..."

                    def status = sh(
                        script: "curl -s -o /dev/null -w '%{http_code}' ${HEALTHCHECK_URL}",
                        returnStdout: true
                    ).trim()

                    if (status != '200') {
                        echo "Health check failed. Rolling back..."
                        sh """
                            docker rm -f ${APP_NAME} || true
                            echo 'Rollback completed.'
                        """
                        error("Deployment failed. Rolled back.")
                    } else {
                        echo "Health check successful!"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "🚀 Deployment Successful! App running on port ${PORT}"
        }
        failure {
            echo "❌ Pipeline Failed!"
        }
    }
}
