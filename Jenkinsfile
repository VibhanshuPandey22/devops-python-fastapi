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
// pipeline {
//     agent any

//     stages {

//         stage('Checkout') {
//             steps {
//                 git branch: 'main', url: 'https://github.com/VibhanshuPandey22/devops-python-fastapi.git'
//             }
//         }

//         stage('Install Dependencies') {
//             steps {
//                 // creating venv is not necessary here as we have only one project and we are installing dependencies in a container, but it is a good practice to use venv for python projects, so I am using it here
//                 sh '''
//                     python3 -m venv venv
//                     . venv/bin/activate
//                     pip install --upgrade pip
//                     pip install -r requirements.txt
//                 '''
//             }
//         }

//         stage('Run Tests') {
//             steps {
//                 sh '''
//                     . venv/bin/activate
//                     tox
//                 '''
//             }
//         }

//         stage('Build Docker Image') { // this happens only because we attaced the socket to the container, otherwise it would have failed with permission error
//             steps {
//                 sh 'docker build -t fastapi-devops .'
//             }
//         }
//     }
// }

// AUTOMATION - COMPLETE CI/CD WITH JENKINS
pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        ECR_REPO = '767289848364.dkr.ecr.ap-south-1.amazonaws.com/devops-fastapi'
        ECR_URI = '767289848364.dkr.ecr.ap-south-1.amazonaws.com'
        IMAGE_TAG = 'latest'
        EC2_PUBLIC_IP = '13.126.35.40' // REPLACE WITH YOUR EC2 PUBLIC IP
    }

    stages {

        stage('Checkout'){
            steps {
                git branch: 'main', url: 'https://github.com/VibhanshuPandey22/devops-python-fastapi.git'
            }
        }

       stage('Install Dependencies') {
    steps {
        sh '''
            python3 -m venv venv
            . venv/bin/activate
            pip install --upgrade pip
            pip install -r requirements.txt
            pip install tox
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

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t fastapi-devops .'
            }
        }

        stage('Tag Docker Image') {
            steps {
                sh 'docker tag fastapi-devops:latest $ECR_REPO:$IMAGE_TAG'
            }
        }

        stage('Push To ECR') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'accesskeysforjenkins'
                ]]) {

                    sh '''
                    aws ecr get-login-password --region $AWS_REGION | \
                    docker login --username AWS --password-stdin $ECR_REPO
                    '''

                    sh 'docker push $ECR_REPO:$IMAGE_TAG'
                }
            }
        }
        

        stage('Deploy To EC2') {
            steps {

                sshagent(credentials: ['ec2-ssh-key']) {

                    sh '''
                    ssh -o StrictHostKeyChecking=no ubuntu@$EC2_PUBLIC_IP << EOF

                    aws ecr get-login-password --region ap-south-1 | \
                    docker login --username AWS --password-stdin $ECR_URI

                    docker stop fastapi-app || true
                    docker rm fastapi-app || true

                    docker pull $ECR_REPO:$IMAGE_TAG

                    docker run -d -p 8000:8000 \
                    --name fastapi-app \
                    $ECR_REPO:$IMAGE_TAG

                    EOF
                    '''
                }
            }
        }
    }
}