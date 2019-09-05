pipeline {
  agent {
    node {
      label 'docker-build'
    }
  }
  environment {
    def customImage = ''
    def VERSION = ''
    def registryUrl = 'https://hub.docker.com'
    def credentialsId = 'hub-jamesbowling'
  }
  stages {
    stage('Prep') {
      steps {
        script {
          if (! env.VERSION) {
            VERSION = sh(script: "date +%Y%j%H", returnStdout: true).trim()
          }
        }
      }
    }
    stage('Build') {
      steps {
        git(url: 'https://github.com/vsential/k8s-cli', branch: 'jenkins-dev', changelog: true)
        script {
          customImage = docker.build("k8s-cli:${VERSION}${env.BUILD_ID}")
        }
      }
    }
    stage('Verify') {
      steps {
        script {
          customImage.run("", "version --client")
        }
      }
    }
    stage('Push') {
      steps {
        script {
          docker.withRegistry([url: "${registryUrl}", credentialsId: "${credentialsId}"]) {
            customImage.push("${VERSION}${env.BUILD_ID}")
          }
        }
      }
    }
  }
}