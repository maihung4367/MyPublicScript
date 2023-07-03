
pipeline{
   agent any
    
    //enviroment
    environment {
        header = "🔁 <b>CI/CD PIPELINE PROCESS v1.1</b>\n🆔 <code>${env.JOB_NAME}</code>"
        separator = "➖➖➖➖➖➖➖➖➖➖"
        footer = "\u2139 Detail logs: ${env.BUILD_URL}"
        telegramBotToken = '1481210476:AAGOM-RnZM6zOJ5hNBzffqPKE1YY-n6wGDk'
        chatId = '-944433564'
    }


   //stage: Login to Server
   stages{
      stage('Login to Server'){
            steps {
                echo "Logging into the server..."
                sshagent(credentials: ['LOGIN_dev-pos-server']) {
                    sh 'ssh -o StrictHostKeyChecking=no root@103.168.51.238'
                }
                echo "Success login"
            }
        }
   
   //stage: Pull Code
    stage('Pull Code') {
            steps {
                sshagent(credentials: ['LOGIN_dev-pos-server']) {
                    sh 'ssh  -o StrictHostKeyChecking=no  root@103.168.51.238 cd /home/dev-fe-pos-v2/posapp-fe && ls'
                }
                echo "Code pulled successfully"
            }
        }
    

    //stage: Build Code
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
        // if success
        success {
            script {
                //def header = "🔁 <b>CI/CD PIPELINE PROCESS v1.1</b>\n🆔 <code>${env.JOB_NAME}</code>"
                //def separator = "➖➖➖➖➖➖➖➖➖➖"
                def status = "\u2705 Status: success"
                //def footer = "\u2139 Detail logs: ${env.BUILD_URL}"

                def message = "${header}\n${separator}\n${status}\n${separator}\n${footer}"
                //def telegramBotToken = '1481210476:AAGOM-RnZM6zOJ5hNBzffqPKE1YY-n6wGDk'
                //def chatId = '-944433564'

                sh "curl -X POST -H 'Content-Type: application/json' -d '{\"chat_id\":\"${chatId}\", \"text\":\"${message}\", \"parse_mode\":\"HTML\"}' https://api.telegram.org/bot${telegramBotToken}/sendMessage"
                }
            }
        
        //if failure
        failure {
            script {
                //def header = "🔁 <b>CI/CD PIPELINE PROCESS v1.1</b>\n🆔 <code>${env.JOB_NAME}</code>"
                //def separator = "➖➖➖➖➖➖➖➖➖➖"
                def status = "\u274c Status : failed"
                //def footer = "\u2139 Detail logs: ${env.BUILD_URL}"
                
                def message = "${header}\n${separator}\n${status}\n${separator}\n${footer}"
                //def telegramBotToken = '1481210476:AAGOM-RnZM6zOJ5hNBzffqPKE1YY-n6wGDk'
                //def chatId = '-944433564'
                
                sh "curl -X POST -H 'Content-Type: application/json' -d '{\"chat_id\":\"${chatId}\", \"text\":\"${message}\", \"parse_mode\":\"HTML\"}' https://api.telegram.org/bot${telegramBotToken}/sendMessage"
                
            }
        }
    }
}