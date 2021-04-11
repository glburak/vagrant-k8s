pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'ls -l'
                sh 'docker build -t cyberburak1/getting-started:2.0 ci-cd/'
            }
        }
       stage('Push image') {
       docker.withRegistry('https://registry.hub.docker.com/cyberburak1/getting-started', 'dockerhub') {            
       app.push("${env.BUILD_NUMBER}")            
       app.push("latest")        
              }    
           }
    }
}
