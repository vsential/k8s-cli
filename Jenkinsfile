pipeline {
  agent {
    node {
      label 'docker-build'
    }

  }
  stages {
    stage('Prep') {
      steps {
        git(url: 'https://github.com/vsential/k8s-cli', branch: 'jenkins-dev', changelog: true)
      }
    }
    stage('Build') {
      parallel {
        stage('Build') {
          steps {
            sh 'def customImage = docker.build("k8s-cli:${env.BUILD_ID}")'
          }
        }
        stage('Verify') {
          steps {
            sh '''customImage.inside {
    version --client
}'''
            }
          }
        }
      }
      stage('Push') {
        steps {
          sh 'customImage.push(${env.BUILD_ID})'
        }
      }
    }
  }