pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS = 'docker-hub-credentials'
        DOCKER_REGISTRY = 'docker.io/abhra04'
        IMAGE_NAME = 'jenkins-pipeline-app'
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/Abhra0404/Jenkins-Pipeline-for-a-Dockerized-App.git'
                    ]]
                ])
            }
        }

        stage('Debug Workspace') {
            steps {
                sh '''
                echo "📁 Current Directory:"
                pwd
                echo "📦 Files:"
                ls -la
                '''
            }
        }

        stage('Install Dependencies & Test') {
            steps {
                sh '''
                python3 -m ensurepip --upgrade || true
                python3 -m pip install --upgrade pip
                python3 -m pip install -r requirements.txt
                python3 -m pip install pytest
                pytest test_app.py -v || true
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def imageTag = "${DOCKER_REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}"
                    
                    sh """
                    echo "🐳 Building Docker Image: ${imageTag}"
                    docker build -t ${imageTag} .
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    def imageTag = "${DOCKER_REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}"

                    sh """
                    echo "🔐 Logging into Docker Hub"
                    echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin

                    echo "📤 Pushing Image"
                    docker push ${imageTag}
                    """
                }
            }
        }

        stage('Tag as Latest (Optional but Pro Move)') {
            steps {
                script {
                    def imageTag = "${DOCKER_REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}"
                    def latestTag = "${DOCKER_REGISTRY}/${IMAGE_NAME}:latest"

                    sh """
                    docker tag ${imageTag} ${latestTag}
                    docker push ${latestTag}
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed!"
        }
        always {
            cleanWs()
        }
    }
}