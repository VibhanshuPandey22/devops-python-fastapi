pipeline {
    agent any

    stages {
        stage('Checkout'){
            steps {
                git branch: 'main', url:'https://github.com/VibhanshuPandey22/devops-python-fastapi.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'python3 -m pip install -r requirements.txt'
            }
        }

        stage('Run Tests') {
            steps {
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