pipeline {
  agent {
    node {
      label 'docker-build'
    }

  }
  stages {
    stage('Prep') {
      steps {
        script {
          if (! env.VERSION) {
            gitCommitHash = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
            shortCommitHash = gitCommitHash.take(7)
            VERSION = shortCommitHash
          }
        }

      }
    }
    stage('Build') {
      steps {
        script {
          customImage = docker.build("${registry}/${image}:${VERSION}")
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
      environment {
        credentialsId = 'hub-jamesbowling'
      }
      steps {
        script {
          docker.withRegistry('', env.credentialsId) {
            customImage.push()
          }
        }

      }
    }
  }
  environment {
    customImage = ''
    VERSION = ''
    registry = 'jamesbowling'
    image = 'k8s-cli'
  }
}