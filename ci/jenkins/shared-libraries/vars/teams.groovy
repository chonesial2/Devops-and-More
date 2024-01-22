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

    // Define Payload
    def msg = """{
                    "@type": "MessageCard",
                    "@context": "http://schema.org/extensions",
                    "themeColor": "${COLOR_CODE}",
                    "summary": "${MESSAGE}",
                    "sections": [{
                        "activityTitle": "${MESSAGE}",
                        "activitySubtitle": "<span style=\'color: #${COLOR_CODE};\'>Latest status of build #${env.BUILD_NUMBER}</span>",
                        "activityImage": "${JENKINS_AVATAR}",
                        "facts": [
                            {
                                "name": "Pipeline",
                                "value": "[${env.JOB_NAME}](${env.BUILD_URL}/console)"
                            },
                            {
                                "name": "Git Branch",
                                "value": "`${env.GIT_BRANCH}`"
                            },
                            {
                                "name": "Build Number",
                                "value": "${env.BUILD_DISPLAY_NAME}"
                            },
                            {
                                "name": "Build Status",
                                "value": "${STATUS}"
                            }],
                        "markdown": true
                        }],
                        "potentialAction": [{
                            "@type": "OpenUri",
                            "name": "View Build",
                            "targets": [{
                            "os": "default",
                            "uri": "${env.BUILD_URL}"
                        }]
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
        println("Error: Message not sent");
        println(conn.getInputStream().getText())
    }

}
