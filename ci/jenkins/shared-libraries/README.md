Jenkins Global Shared Libraries
===

A shared library is a collection of independent Groovy scripts which you pull into your Jenkinsfile at runtime.

## References

- https://www.jenkins.io/doc/book/pipeline/shared-libraries/
- https://www.tutorialworks.com/jenkins-shared-library/


## Usage

### MS Teams Alert

- Include Library in your pipeline

```groovy

@Library('jenkins-shared-library') _
```

- Use method to send Teams Alert.

```groovy

// Syntax

...
script {
    ...
    teams.send_message("<Teams-webhook-url>", "<Your-message>", "<hex-color-code>")
    ...
}
...
```

> Note: Use hex color code as Teams theme color only support hex color code

- Example usage

```groovy

// Syntax

...
script {
    ...
    teams.send_message("https://example.webhook.office.com/webhookb2/AAAAAAAA/IncomingWebhook/BBBBBBB/CCCCCC", "This is a test message", "#B6158F")
    ...
}
...
```
