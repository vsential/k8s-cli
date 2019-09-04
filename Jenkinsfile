pipeline {
  agent {
    node {
      label 'docker-build'
    }

  }
  stages {
    stage('Prep') {
      steps {
        git(url: 'https://github.com/vsential/k8s-cli', branch: 'master', changelog: true, credentialsId: 'Github - James')
      }
    }
  }
  environment {
    registry = 'vsential/k8s-cli'
  }
}