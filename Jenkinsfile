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
          def customImage
          customImage = docker.build("k8s-cli:${env.BUILD_ID}")
        }
      }
    }
    stage('Verify') {
      steps {
        script {
          customImage.inside {"version --client"}
        }
      }
    }
    stage('Push') {
      steps {
        script {
          withRegistry(url: "https://hub.docker.com", credentialsId: 'hub-jamesbowling')
          customImage.push(${env.BUILD_ID})
        }
      }
    }
  }
}