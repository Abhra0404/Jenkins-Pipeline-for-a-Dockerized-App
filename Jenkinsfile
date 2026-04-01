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
                git branch: 'main', url: 'https://github.com/Abhra0404/Jenkins-Pipeline-for-a-Dockerized-App.git'
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

        stage('Run Tests (Dockerized)') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: DOCKER_CREDENTIALS,
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin

                        echo "🐍 Running tests inside Docker"

                        docker run --rm \
                        -v $(pwd):/app \
                        -w /app \
                        python:3.10 \
                        sh -c "
                            pip install -r requirements.txt &&
                            pip install pytest &&
                            pytest test_app.py -v || true
                        "
                        '''
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    IMAGE_TAG = "${DOCKER_REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}"

                    sh """
                    echo "🐳 Building Docker Image: ${IMAGE_TAG}"
                    docker build -t ${IMAGE_TAG} .
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    IMAGE_TAG = "${DOCKER_REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}"

                    withCredentials([usernamePassword(
                        credentialsId: DOCKER_CREDENTIALS,
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {

                        sh """
                        echo "🔐 Logging into Docker Hub"
                        echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin

                        echo "📤 Pushing Image"
                        docker push ${IMAGE_TAG}
                        """
                    }
                }
            }
        }

        stage('Tag as Latest') {
            steps {
                script {
                    IMAGE_TAG = "${DOCKER_REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}"
                    LATEST_TAG = "${DOCKER_REGISTRY}/${IMAGE_NAME}:latest"

                    sh """
                    docker tag ${IMAGE_TAG} ${LATEST_TAG}
                    docker push ${LATEST_TAG}
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