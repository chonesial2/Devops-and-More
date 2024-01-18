# Configuring Jenkins Pipeline with SonarQube and GitLab integration:

## SonarQube Configuration:

### Login into the SonarQube dashboard and go to the Administrator tab


- security
- user
- then  generate the access token


### GitLab Configuration:

Go to your GitLab dashboard and follow 
- Dashboard 
- Setting 
- Access Tokens
- then generate the gitlab access token too

 
### Integrating SonarQube and GitLabs in Jenkins:


We are going to integrate SonarQube. 
- Go Dashboard 
- Manage Jenkins 
- Manage Plugins and search for SonarQube-Scanner.
- Make sure you restart Jenkins once the plugin is successfully installed.


Once the restart is completed, you have to set up Sonar Scanner, which is a standalone tool used for scanning the source code and send the result to SonarQube Server.Here you are going to install it in the Jenkins container itself.
command:
``` sh 
docker exec -it  bash $ cd /var/jenkins_home $ wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip $ unzip sonar-scanner-cli-4.2.0.1873-linux.zip

```


Go back to the Manage Jenkins page and select Global Tool Configuration.In this page, find SonarQube Scanner and add complete the installation:



name:(example: sonarqube-scanner)
SONAR_RUNNER_HOME: here you must give the path



NOTE: Don't forget to uncheck Install automatically as you have to define the installation path of Sonar Scanner.


### As Jenkins and SonarQube are running in separate docker containers, we need to create a Webhook at SonarQube Server so that both can communicate with each other To do so
- Administrator 
-  Configuration 
-  Webhook
- Provide  your project name and jenkins url


Lastly, you have to add the access token you generated on your SonarQube server in Jenkins.
go to 
- Dashboard 
- Credentials 
- System
- add your token here.


 Now, add the SonarQube server to your Jenkins environment. Go to 
 - Dashboard 
 - Manage Jenkins  
 - Configure System Find SonarQube server on the page and add the required details
 - name : sonarqube-container
 - url : sonarqube url
 - add server authentication token



Now, you have to add Gitlab in Jenkins, visit Dashboard > Credentials > System. Here, you are going to add the access token you previously created to your Jenkins server.


The below-mentioned simple pipeline code which you add in your pipeline.
``` sh 
stage('Sonarqube') {
environment {
scannerHome = tool 'sonarqube-scanner'
}
steps {
withSonarQubeEnv('SonarQube') {
sh "${scannerHome}/bin/sonar-scanner 
-Dsonar.projectKey=<project_name>"
}
}
}
```

