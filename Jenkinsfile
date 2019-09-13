pipeline {
    agent {
        label 'swarm-instance'
    }
    environment {
        IMAGE_NAME = "registry.gitlab.com/bozzlab/spring-petclinic"
    }
    stages {
        stage('build image') {
            steps {
                sh "docker build -t ${env.IMAGE_NAME}:${env.BUILD_NUMBER} ."
                sh "docker tag ${env.IMAGE_NAME}:${env.BUILD_NUMBER} ${env.IMAGE_NAME}:latest"
            }
        }
        stage('push image') {
            steps {
                withCredentials(
                [usernamePassword(
                    credentialsId: 'GITLAB',
                    passwordVariable: 'gitPassword',
                    usernameVariable: 'gitUser'
                )]
                 ){
                    sh "docker login -u ${env.gitUser} -p ${env.gitPassword} registry.gitlab.com"
                    sh "docker push ${env.IMAGE_NAME}"

                }
            }
        }
        stage('deploy') {
            steps {
                try {
                      sh "docker service update spring-petclinic --image ${env.IMAGE_NAME}"
                    }
                    catch ( e ) {
                      sh "docker service create --with-registry-auth --replicas 1 --name spring-petclinic --constraint 'node.role != manager' --publish 8080:8080 ${env.IMAGE_NAME}"
                    }
            }
        }
    }
}