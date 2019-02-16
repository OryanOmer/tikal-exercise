pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE_TAG = "pydash:v1.4.6"
        registry = "roeizavida"
        registryCredential = "dockerhub"
    }
    
    stages {
        stage('Build') {
            steps {
                echo "Build docker image"
                script {
                    docker_image = docker.build(registry + "/${env.DOCKER_IMAGE_TAG}",  '-f ./Dockerfile .')
                    }
                }
            }

        stage('Run') {
            steps {
            echo "Run docker image"
            script {
                docker_image.run('--name pydash -p 8000:8000')
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    docker_image.inside() {
                        timeout(time: 1, unit: 'MINUTES') {
                            retry(5) {
                                sleep 5
                                sh "curl http://\$(/sbin/ip route|awk '/default/ { print \$3 }'):8000"
                            }
                        }
                    }
                }
            }
        }
        
        stage('Stop & Remove') {
            steps {
                script {
                    sh 'docker stop pydash'
                    sh 'docker rm pydash'
                }
            }
        }
        
        stage ('Tag image as latest and push to DockerHub') {
            steps {
                script {
                    docker.withRegistry( '', registryCredential ) {
                        docker_image.push()
                        docker_image.push('latest')
                    }
                }
            }
        }
    }
}
