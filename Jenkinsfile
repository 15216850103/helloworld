pipeline {
    agent any

    environment {
        APP         = 'helloworld'
        GOPROXY     = 'https://goproxy.cn,direct'
        CGO_ENABLED = '0'
        IMAGE_NAME  = "${params.REGISTRY ?: 'harbor.xxx.com'}/${params.NAMESPACE ?: 'xxx'}/${APP}"
        IMAGE_TAG   = "${params.IMAGE_TAG ?: env.BUILD_NUMBER}"
    }
    // 定义构建参数
    parameters {
        string(name: 'REGISTRY', defaultValue: 'harbor.xxx.com', description: '容器镜像仓库地址')
        string(name: 'NAMESPACE', defaultValue: 'xxx', description: '镜像命名空间 / 项目')
        string(name: 'IMAGE_TAG', defaultValue: '', description: '镜像标签，留空则使用 BUILD_NUMBER')
        booleanParam(name: 'PUSH_IMAGE', defaultValue: true, description: '是否推送镜像到远端仓库')
    }

    options {
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '20'))
    }

    stages {
        stage('Checkout') {
            steps {
                echo '开始拉取 Git 代码'
                checkout scm
            }
        }

        stage('Test') {
            agent {
                docker {
                    image 'golang:1.26-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    go version
                    go mod download
                    go test ./...
                '''
            }
        }

        stage('Build') {
            agent {
                docker {
                    image 'golang:1.26-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    mkdir -p bin
                    go build -trimpath -ldflags="-s -w" -o "bin/${APP}" .
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh """
                    docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" -t "${IMAGE_NAME}:latest" .
                """
            }
        }

        stage('Docker Push') {
            when {
                expression { return params.PUSH_IMAGE }
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'harbor-credentials',
                    usernameVariable: 'REGISTRY_USER',
                    passwordVariable: 'REGISTRY_PASS'
                )]) {
                    sh """
                        echo "\$REGISTRY_PASS" | docker login "${params.REGISTRY}" -u "\$REGISTRY_USER" --password-stdin
                        docker push "${IMAGE_NAME}:${IMAGE_TAG}"
                        docker push "${IMAGE_NAME}:latest"
                    """
                }
            }
        }
    }

    // 构建结果处理
    post {
        always {
            echo 'Pipeline 执行结束'
            sh """
                docker logout "${params.REGISTRY}" || true
            """
            cleanWs()
        }
        success {
            echo "构建成功: ${IMAGE_NAME}:${IMAGE_TAG}"
        }
        failure {
            echo '构建失败'
        }
    }
}
