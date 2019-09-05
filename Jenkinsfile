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
        sh '''TOKEN = `curl -i -X POST -H "Content-Type: application/json" -H "Accept: application/json" -d \'{"username":"${registry},"password":"${registryPass}"}\' https://hub.docker.com/v2/users/login/`
'''
        sh '''curl -i -X DELETE -H "Accept: application/json" -H "Authorization: JWT ${TOKEN}" \\
  https://hub.docker.com/v2/repositories/${registry}/${image}/tags/${version}/'''
      }
    }
  }
  environment {
    customImage = ''
    version = ''
    credentialsId = 'hub-jamesbowling'
    registry = 'jamesbowling'
    registryPass = '8es&ENav'
    image = 'k8s-cli'
  }
}