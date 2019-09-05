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
      environment {
        registryUrl = 'https://cloud.docker.com'
        credentialsId = 'hub-jamesbowling'
      }
      steps {
        script {
          docker.withRegistry(env.registryUrl, env.credentialsId) {
            customImage.push("${VERSION}")
          }
        }

      }
    }
  }
  environment {
    customImage = ''
    VERSION = ''
  }
}