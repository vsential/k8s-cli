pipeline {
  agent {
    node {
      label 'docker-build'
    }
  }
  environment {
    def customImage = ''
    def VERSION = ''
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
          docker.withRegistry('https://hub.docker.com', 'hub-jamesbowling') {
            customImage.push("${VERSION}${env.BUILD_ID}")
          }
        }
      }
    }
  }
}