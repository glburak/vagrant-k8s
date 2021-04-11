pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'ls -l'
                sh 'docker build -t cyberburak1/getting-started:2.0 ci-cd/'
            }
        }
        stage('publish') {
            steps {
               
                sh 'docker push cyberburak1/getting-started:2.0'
            }
        }
        stage('kubernetes-deploy') {
            steps {

                sh 'kubectl create -f manifests/deployment.yaml'
                sh 'kubectl create -f manifests/service.yaml'
            }
        }
    }
}
