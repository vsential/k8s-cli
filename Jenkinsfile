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
          if (! env.version) {
            gitCommitHash = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
            shortCommitHash = gitCommitHash.take(7)
            version = shortCommitHash
          }
        }

      }
    }
    stage('Build') {
      steps {
        script {
          customImage = docker.build("${registry}/${image}:${version}")
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
      parallel {
        stage('Push') {
          steps {
            script {
              docker.withRegistry('', env.credentialsId) {
                customImage.push()
              }
            }

          }
        }
        stage('Notify') {
          steps {
            script {
              slackSend "Build Completed - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
            }

          }
        }
      }
    }
  }
  environment {
    customImage = ''
    version = ''
    credentialsId = 'hub-jamesbowling'
    registry = 'jamesbowling'
    image = 'k8s-cli'
  }
}