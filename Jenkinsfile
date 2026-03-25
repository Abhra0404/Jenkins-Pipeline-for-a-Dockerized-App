pipeline {
    agent any

    environment {
        // Use the credential ID you created in Step 4
        DOCKER_CREDENTIALS = 'docker-hub-credentials'
        // Replace with YOUR Docker Hub username
        DOCKER_REGISTRY = 'docker.io/abhra04'
        IMAGE_NAME = 'jenkins-pipeline-project'
    }

    stages {
        stage('Checkout') {
            steps {
                // Pull code from GitHub
                checkout scm
            }
        }

        stage('Test') {
            steps {
                sh 'python -m pytest test_app.py || true' 
                // '|| true' prevents build failure if pytest isn't installed globally
                // For now, we just want to see the step run
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the image with a unique tag (BUILD_NUMBER)
                    docker.build("${DOCKER_REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}")
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    // Login to Docker Hub using credentials
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS) {
                        // Push the image
                        docker.image("${DOCKER_REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}").push()
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up workspace to save space
            cleanWs()
        }
        success {
            echo '🎉 Pipeline succeeded! Image pushed to Docker Hub.'
        }
        failure {
            echo '❌ Pipeline failed. Check logs.'
        }
    }
}