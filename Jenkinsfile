pipeline {
    agent any

    stages {
        stage('Checkout'){
            steps {
                git branch: 'main', url: 'https://github.com/VibhanshuPandey22/devops-python-fastapi.git'
            }
        }

        stage('Install Dependencies') {
            agent { docker { image 'python:3.12-slim' } }
            steps {
                sh 'python3 -m pip install --upgrade pip'
                sh 'python3 -m pip install -r requirements.txt'
            }
        }

        stage('Run Tests') {
            agent { docker { image 'python:3.12-slim' } }
            steps {
                sh 'python3 -m pip install tox'
                sh 'tox'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t devops-python-fastapi .'
            }
        }
    }
}