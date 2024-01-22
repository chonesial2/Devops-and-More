def send_message(String URL_WEBHOOK, String MESSAGE, String COLOR_CODE) {

    def JENKINS_AVATAR = "https://www.jenkins.io/images/logos/jenkins/jenkins.png"

    def STATUS = currentBuild.result
    if (STATUS == null ){
        STATUS = "STARTED"
    }

    if ( COLOR_CODE.charAt(0) == '#' )
    {
        // Remove '#' from theme color
        COLOR_CODE = COLOR_CODE.substring(1)
    }

    def conn = new URL("${URL_WEBHOOK}").openConnection()
    conn.requestMethod = 'POST'

    attachment_text = "Pipeline     : *<${env.BUILD_URL}/console|${env.JOB_NAME}>*  \n" +
                      "Git Branch   : `${env.GIT_BRANCH}` \n" +
                      "Build Number : *${env.BUILD_DISPLAY_NAME}* \n" +
                      "Build Status : *${STATUS}* \n"

    // Define Payload
    def msg = """{
                    "text": "${MESSAGE}",
                    "attachments": [{
                        "text" : "${attachment_text}",
                        "color":"#${COLOR_CODE}",
                        "attachment_type":"default",
                        "actions": [
                            {
                                "name": "build_url",
                                "text": "View Build",
                                "type": "button",
                                "url": "${env.BUILD_URL}"
                            }
                        ]
                    }]
            }""".stripMargin().stripIndent()

    conn.setDoOutput(true)
    conn.setRequestProperty("Content-Type", "application/json")
    conn.getOutputStream().write(msg.getBytes("UTF-8"))

    // Send request
    resp = conn.getResponseCode()
    println("Response Code : ${resp}")

    if (resp.equals(200)) {
        println("Message has been sent successfully")
    } else {
        println("Error: Message not sent")
    }
    println(conn.getInputStream().getText())

}
