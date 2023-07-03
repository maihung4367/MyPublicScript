
pipeline{
   agent any
    
    //enviroment
    environment {

        //API Telegram Token
        telegramBotToken = '1481210476:AAGOM-RnZM6zOJ5hNBzffqPKE1YY-n6wGDk'
        chatId = '-944433564'

        //Template Telegram message
        header = "🔁 <b>CI/CD PIPELINE PROCESS v1.1</b>\n🆔 <code>${env.JOB_NAME}</code>"
        separator = "➖➖➖➖➖➖➖➖➖➖"
        footer = "\u2139 Detail logs: ${env.BUILD_URL}"
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

    //stage: Notification the updated code
    
    //stage('Notification the updated code') {
    //        steps {
    //            sshagent(credentials: ['LOGIN_dev-pos-server']) {
    //                sh 'ssh  -o StrictHostKeyChecking=no  root@103.168.51.238 cd /home/dev-fe-pos-v2/posapp-fe && git log -1 '
    //            }
    //            echo "Send Telegram notification successfully"
    //        }
    //    }
    
    stage('Notification the updated code') {
        steps {
            script {
                def gitLog = sshagent(credentials: ['LOGIN_dev-pos-server']) {
                    return sh(script: 'ssh -o StrictHostKeyChecking=no root@103.168.51.238 "git --git-dir /home/dev-fe-pos-v2/posapp-fe log -1 --pretty=format:\'%h - %an%n%s%n%ci\'"', returnStdout: true).trim()
                }

                // Extract the commit hash, author name, commit message, and commit date from the gitLog
                def (commitHash, authorName, commitMessage, commitDate) = gitLog.split('\n', 4)

                // Format the message to be sent via Telegram
                def message = "${header}\n${separator}\n"
                message += "<b>Latest Commit:</b>\n"
                message += "<b>Commit Hash:</b> ${commitHash}\n"
                message += "<b>Author:</b> ${authorName}\n"
                message += "<b>Commit Message:</b>\n${commitMessage}\n"
                message += "<b>Commit Date:</b> ${commitDate}\n"
                message += "${separator}\n${footer}"

                // Send the message to Telegram
                sh "curl -X POST -H 'Content-Type: application/json' -d '{\"chat_id\":\"${chatId}\", \"text\":\"${message}\", \"parse_mode\":\"HTML\"}' https://api.telegram.org/bot${telegramBotToken}/sendMessage"

                echo "Send Telegram notification successfully"
            }
        }
    }


    // stage: Build Code
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