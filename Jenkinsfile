pipeline {
  agent {
    node {
      label 'docker-build'
    }

  }
  stages {
    stage('Prep') {
      steps {
        git(url: 'https://github.com/vsential/k8s-cli', branch: 'jenkins-dev', changelog: true)
      }
    }
    stage('Build') {
      parallel {
        stage('Build') {
          agent {
            dockerfile {
              filename 'Dockerfile'
            }
          }
          steps {
            
          }
        }
        stage('Verify') {
          steps {
            script {
              customImage.inside {"version --client"}
            }
          }
        }
      }
    }
      stage('Push') {
        steps {
          script {
            withRegistry(url: "https://hub.docker.com", credentialsId: 'hub-jamesbowling')
            customImage.push(${env.BUILD_ID})
          }
        }
      }
    }
  }