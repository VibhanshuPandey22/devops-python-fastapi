//ASK SIR WHY THIS DID NOT WORK
// pipeline {
//     agent any

//     stages {
        // stage('Checkout'){
        //     steps {
        //         git branch: 'main', url: 'https://github.com/VibhanshuPandey22/devops-python-fastapi.git'
        //     }
        // }

//         stage('Install Dependencies') {
//             agent { docker { image 'python:3.12-slim' } }
//             steps {
//                 sh 'python3 -m pip install --upgrade pip'
//                 sh 'python3 -m pip install -r requirements.txt'
//             }
//         }

//         stage('Run Tests') {
//             agent { docker { image 'python:3.12-slim' } }
//             steps {
//                 sh 'python3 -m pip install tox'
//                 sh 'tox'
//             }
//         }

//         stage('Build Docker Image') {
//             steps {
//                 sh 'docker build -t devops-python-fastapi .'
//             }
//         }
//     }
// }

// WORKING VERSION - PRE INSTALLED DOCKER AND FULL PYTHON IN THE JENKINS CONTAINER
pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/VibhanshuPandey22/devops-python-fastapi.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                // creating venv is not necessary here as we have only one project and we are installing dependencies in a container, but it is a good practice to use venv for python projects, so I am using it here
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    . venv/bin/activate
                    tox
                '''
            }
        }

        stage('Build Docker Image') { // this happens only because we attaced the socket to the container, otherwise it would have failed with permission error
            steps {
                sh 'docker build -t fastapi-devops .'
            }
        }
    }
}