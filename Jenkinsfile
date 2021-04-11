pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'ls -l'
                sh 'docker build -t cyberburak1/getting-started:2.0 ci-cd/'
            }
        }
        stage('push regisrty') {
            steps {
                
                sh 'docker push cyberburak1/getting-started:2.0'
            }
        }
    }
}
