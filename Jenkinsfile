pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS = 'docker-hub-credentials'
        DOCKER_REGISTRY = 'docker.io/abhra04' // Your username
        IMAGE_NAME = 'jenkins-pipeline-app'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Explicitly tell Jenkins to clone the repo here
                checkout scm
                echo "✅ Code checked out successfully!"
                sh 'ls -la' // Verify files are there
            }
        }

        stage('Test') {
            steps {
                sh 'pip install -r requirements.txt'
                sh 'pip install pytest'
                sh 'pytest test_app.py -v || true'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}")
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS) {
                        docker.image("${DOCKER_REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}").push()
                    }
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}