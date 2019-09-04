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
          steps {
            def customImage = docker.build("k8s-cli:${env.BUILD_ID}")
          }
        }
        stage('Verify') {
          steps {
            customImage.inside {"version --client"}
            }
          }
        }
      }
      stage('Push') {
        steps {
          withRegistry(url: "https://hub.docker.com", credentialsId: 'hub-jamesbowling')
          customImage.push(${env.BUILD_ID})
        }
      }
    }
  }