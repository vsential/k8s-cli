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
        credentialsId = 'hub-jamesbowling'
        registry = 'jamesbowling'
        image = 'k8s-cli'
      }
      steps {
        script {
          docker.withRegistry('', env.credentialsId) {
            customImage.tag("${registry}/${env.image}:${VERSION}")
            customImage.push()
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