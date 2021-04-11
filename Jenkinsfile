pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'cd ci-cd'
                sh 'docker build -t deneme .'
            }
        }
    }
}
