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
      steps {
        script {
          docker.withRegistry('', env.credentialsId) {
            customImage.push()
          }
        }

      }
    }
    stage('Cleanup') {
      steps {
        script {
          TOKEN = `curl -i -X POST -H "Content-Type: application/json" -H "Accept: application/json" -d '{"username":"${hubCredentials_USR}","password":"${hubCredentials_PSW}"}' https://hub.docker.com/v2/users/login/ | grep \"token\" | jq -r .token`
          curl -i -X "DELETE" -H "Accept: application/json" -H "Authorization: JWT ${TOKEN}" https://hub.docker.com/v2/repositories/${registry}/${image}/tags/${version}/
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
    hubCredentials = credentials('hub-jamesbowling')
  }
}