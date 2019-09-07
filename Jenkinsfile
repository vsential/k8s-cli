pipeline {
  agent {
    node {
      label 'docker-build'
    }

  }
  stages {
    stage('Build') {
      steps {
        script {
          if (! env.version) {
            gitCommitHash = sh(returnStdout: true, script: 'git rev-parse --short HEAD')
            version = gitCommitHash          
            c = docker.build("${registry}/${image}", "--build-arg buildTime=`date -Iseconds`")
          }
        }

      }
    }
    stage('Verify') {
      steps {
        script {
          c.run("", "version --client")
        }

      }
    }
    stage('Push') {
      steps {
        script {
          docker.withRegistry('', env.credentialsId) {
            c.push("${version}")
            c.push("${env.BRANCH_NAME}")
            if (env.BRANCH_NAME == 'master') {
              c.push('latest')
            }
          }
        }

      }
    }
  }
  environment {
    version = ''
    credentialsId = 'hub-jamesbowling'
    registry = 'jamesbowling'
    image = 'k8s-cli'
  }
}