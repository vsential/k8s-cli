pipeline {
  agent none
  stages {
    stage('Prep') {
      steps {
        script {
          if (! env.VERSION) {
            // calculate GIT lastest commit short-hash
            gitCommitHash = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
            shortCommitHash = gitCommitHash.take(7)
            // calculate a sample version tag
            VERSION = shortCommitHash
          }
        }

      }
    }
    stage('Build') {
      steps {
        script {
          customImage = docker.build("k8s-cli:${VERSION}")
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
          docker.withRegistry("${registryUrl}", "${credentialsId}") {
            customImage.push("${VERSION}")
          }
        }

      }
    }
  }
  environment {
    customImage = ''
    VERSION = ''
    registryUrl = 'https://hub.docker.com'
    credentialsId = 'hub-jamesbowling'
  }
}