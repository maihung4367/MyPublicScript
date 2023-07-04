/*  
Author: Your Name
Date: 2023-07-04
Project: dev-fe-pos-v2
Description: This Jenkinsfile automates the CI/CD process for the project.
*/

pipeline {
    agent any

    parameters {
        string(name: 'TELEGRAM_BOT_TOKEN', defaultValue: '', description: 'The API token for the Telegram bot')
    }
    
    // Environment
    environment {
        // API Telegram Token
        // telegramBotToken = '1481210476:AAGOM-RnZM6zOJ5hNBzffqPKE1YY-n6wGDk'
        telegramBotToken = credentials('TOKEN-Telegram-PVS_BOT') ?: params.TELEGRAM_BOT_TOKEN ?: ""
        chatId = '-944433564'

        // Template Telegram message
        header = "\ud83d\udd01 <b>CI/CD PIPELINE PROCESS v1.1</b>\n\ud83c\udd94 <code>${env.JOB_NAME}</code>"
        separator = "\u2796\u2796\u2796\u2796\u2796\u2796\u2796\u2796\u2796\u2796"
        footer = "\u2139 Detail logs: ${env.BUILD_URL}"

        // Server credentials
        serverIP = '103.168.51.238'
        serverUser = 'root'

        // Code directory and Docker Compose settings
        codeDirectory = '/home/dev-fe-pos-v2/posapp-fe'
        composeFilePath = '/home/dev-fe-pos-v2/docker-compose.yml'
        dockerServiceName = 'dev-fe-pos-v2'
    }

    // Simple CI/CD Stages
    stages {
        // stage 'Get Latest Git Commit Logs'
        stage('Get Latest Git Commit Logs') {
            steps {
                script {
                    def repositoryLink = sh(returnStdout: true, script: 'git config --get remote.origin.url')
                    env.GIT_repositoryLink = repositoryLink.trim()
                    def commitPerson = sh(returnStdout: true, script: 'git log -1 --pretty=format:"%an"')
                    env.GIT_commitPerson = commitPerson.trim()
                    def commitTime = sh(returnStdout: true, script: 'git log -1 --pretty=format:"%ci"')
                    env.GIT_commitTime = commitTime.trim()
                    def commitMessage = sh(returnStdout: true, script: 'git log -1 --pretty=format:"%s"')
                    env.GIT_commitMessage = commitMessage.trim()
                }
            }
        }

        // stage 'Send Git Logs to Telegram'
        stage('Send Git Logs to Telegram') {
            steps {
                script {
                    def status = "\u2705 Status: success"

                    def message =   "\ud83d\udd09 <code>Some new updating code on github...</code>\n\n" +
                                    "${separator}\n" +
                                    "\ud83c\udd94 <code>${env.JOB_NAME}</code>\n" +
                                    "${separator}\n" +
                                    "\ud83d\udd17 <code>${env.GIT_repositoryLink}</code>\n" +
                                    "\ud83e\uddd1 <code>${env.GIT_commitPerson}</code>\n" +
                                    "\ud83d\udcc5 <code>${env.GIT_commitTime}</code>\n" +
                                    "\ud83c\udd95 <code>${env.GIT_commitMessage}</code>\n" +
                                    "${separator}\n" +
                                    "\ud83d\udd01 These updating code will be automatically build by CI/CD pipeline afterwards..."

                    sh "curl -X POST -H 'Content-Type: application/json' -d '{\"chat_id\":\"${chatId}\", \"text\":\"${message}\", \"parse_mode\":\"HTML\"}' https://api.telegram.org/bot${telegramBotToken}/sendMessage"
                }
            }
        }    

        // stage 'Login to Server'
        stage('Login to Server') {
            steps {
                echo "Logging into the server..."
                sshagent(credentials: ['LOGIN_dev-pos-server']) {
                    sh 'ssh -o StrictHostKeyChecking=no ${serverUser}@${serverIP}'
                }
                echo "Success login"
            }
        }

        // stage: 'Pull code'
        stage('Pull Code') {
            steps {
                sshagent(credentials: ['LOGIN_dev-pos-server']) {
                    sh 'ssh  -o StrictHostKeyChecking=no  ${serverUser}@${serverIP} ls ${codeDirectory}'
                }
                echo "Code pulled successfully"
            }
        }

        // stage: 'Build Code'
        stage('Build Code') {
            steps {
                sshagent(credentials: ['LOGIN_dev-pos-server']) {
                    sh 'ssh  -o StrictHostKeyChecking=no  ${serverUser}@${serverIP} docker-compose -f ${composeFilePath} up -d --build ${dockerServiceName}'
                }
                echo "Code build successfully"
            }
        }
    }

    // Notification to Telegram
    post {
        // if success
        success {
            script {
                def status = "\u2705 Status: success"
                def message = "${header}\n${separator}\n${status}\n${separator}\n${footer}"
                sh "curl -X POST -H 'Content-Type: application/json' -d '{\"chat_id\":\"${chatId}\", \"text\":\"${message}\", \"parse_mode\":\"HTML\"}' https://api.telegram.org/bot${telegramBotToken}/sendMessage"
            }
        }
        // if failure
        failure {
            script {
                def status = "\u274c Status : failed"               
                def message = "${header}\n${separator}\n${status}\n${separator}\n${footer}"               
                sh "curl -X POST -H 'Content-Type: application/json' -d '{\"chat_id\":\"${chatId}\", \"text\":\"${message}\", \"parse_mode\":\"HTML\"}' https://api.telegram.org/bot${telegramBotToken}/sendMessage"   
            }
        }
    }
}
