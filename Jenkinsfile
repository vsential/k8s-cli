def customImage

pipeline {
  agent {
    node {
      label 'docker-build'
    }
  }
  stages {
    stage('Build') {
      steps {
        git(url: 'https://github.com/vsential/k8s-cli', branch: 'jenkins-dev', changelog: true)
        script {
          customImage = docker.build("k8s-cli:${env.BUILD_ID}")
          customImage.inside {"version --client"}
        }
      }
    }
    stage('Push') {
      steps {
        withRegistry(url: "https://hub.docker.com", credentialsId: 'hub-jamesbowling')
        script {
          ${customImage}.push(${env.BUILD_ID})
        }
      }
    }
  }
}