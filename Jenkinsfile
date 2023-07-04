pipeline {
    agent any
    
    // Environment
    environment {
        // API Telegram Token
        telegramBotToken = '1481210476:AAGOM-RnZM6zOJ5hNBzffqPKE1YY-n6wGDk'
        chatId = '-944433564'

        // Template Telegram message
        header = "🔁 <b>CI/CD PIPELINE PROCESS v1.1</b>\n🆔 <code>${env.JOB_NAME}</code>"
        separator = "➖➖➖➖➖➖➖➖➖➖"
        footer = "\u2139 Detail logs: ${env.BUILD_URL}"
    }

    stages {
        
        stage('Get Latest Git Commit Logs') {
            steps {
                script {
                    def commitPerson = sh(returnStdout: true, script: 'git log -1 --pretty=format:"%an"')
                    env.GIT_commitPerson = commitPerson.trim()
                }
            }
        }

        stage('Send Git Logs to Telegram') {
            steps {
                script {
                    def status = "\u2705 Status: success"

                    def message = "🔉Some new updating code on github...\n\n" +
                                       "${separator}\n" +
                                       "🆔 ${env.JOB_NAME}\n" +
                                       "${separator}\n" +
                                       "🔗 \n" +
                                       "${env.GIT_commitPerson}\n" +
                                       "${separator}\n" +
                                       "🔁 These updating code will be automatically build by CI/CD pipeline afterwards..."

                    sh "curl -X POST -H 'Content-Type: application/json' -d '{\"chat_id\":\"${chatId}\", \"text\":\"${message}\", \"parse_mode\":\"HTML\"}' https://api.telegram.org/bot${telegramBotToken}/sendMessage"
                }
            }
        }    

        // stage 'Login to Server'
        stage('Login to Server') {
            steps {
                echo "Logging into the server..."
                sshagent(credentials: ['LOGIN_dev-pos-server']) {
                    sh 'ssh -o StrictHostKeyChecking=no root@103.168.51.238'
                }
                echo "Success login"
            }
        }

        // stage: 'Pull code'
        stage('Pull Code') {
            steps {
                sshagent(credentials: ['LOGIN_dev-pos-server']) {
                    sh 'ssh  -o StrictHostKeyChecking=no  root@103.168.51.238 ls /home/dev-fe-pos-v2/posapp-fe'
                }
                echo "Code pulled successfully"
            }
        }

        // stage: 'Build Code'
        stage('Build Code') {
            steps {
                sshagent(credentials: ['LOGIN_dev-pos-server']) {
                    sh 'ssh  -o StrictHostKeyChecking=no  root@103.168.51.238 docker-compose -f /home/dev-fe-pos-v2/docker-compose.yml up -d --build dev-fe-pos-v2'
                }
                echo "Code build successfully"
            }
        }
    }

    // Notification to Telegram
    post {
        success {
            script {
                def status = "\u2705 Status: success"
                def message = "${header}\n${separator}\n${status}\n${separator}\n${footer}"
                sh "curl -X POST -H 'Content-Type: application/json' -d '{\"chat_id\":\"${chatId}\", \"text\":\"${message}\", \"parse_mode\":\"HTML\"}' https://api.telegram.org/bot${telegramBotToken}/sendMessage"
            }
        }

        failure {
            script {
                def status = "\u274c Status : failed"               
                def message = "${header}\n${separator}\n${status}\n${separator}\n${footer}"               
                sh "curl -X POST -H 'Content-Type: application/json' -d '{\"chat_id\":\"${chatId}\", \"text\":\"${message}\", \"parse_mode\":\"HTML\"}' https://api.telegram.org/bot${telegramBotToken}/sendMessage"   
            }
        }
    }
}
