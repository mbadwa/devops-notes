# Jenkins Deep Dive

This is a deep dive of Jenkins installed on Ubuntu 22.0.4 LTS in AWS, we will cover the following topics:

- Jenkins installation in AWS
  - Jenkins tools installations
  - Creating jobs using Freestyle
  - Creating jobs using Freestyle and Git code artifact
- Plugins, Versioning
- And more

NOTE: The Java Development Kit (JDK) versions used are 11 and 8 because they are dependencies for the sample project code we will use. Otherwise, they are deprecated versions for production environment. Let's get the show on the road.

## Spin up Jenkins EC2 in AWS
This section will cover how to install Jenkins server in AWS, configure it and run tests builds in Jenkins just to get the hang of it.

  **Steps**

### 1. Install Jenkins in AWS

1.  Create a key pair called "JenkinsKey"
      - Log into [AWS Account](https://signin.aws.amazon.com/)
      - Open EC2 console Dashboard
      - Go to Network & Security > Key Pairs
      - Go to EC2 > Network & Security > Key Pairs and hit Create key pair
      - Enter name "JenkinsKey".

        Under Private key file format select .pem for Linux

      - Hit Create key pair

      - Change the permissions of the downloaded, "JenkinsKey".

            chmod "400" JenkinsKey

2. Create an Instance called "JenkinsServer" and an SG called "jenkins-SG"
     - Launch an instance
       - Name and tags
         - Name: "JenkinsServer"
       - Application and OS Images (Amazon Machine Image)
         - Search for ubuntu 20.0.4 LTS/ 22.0.4 LTS
       - Instance type
         - t2.medium
       - Key pair(login)
         - Select "JenkinsKey"
       - Network Settings > Edit
         - Firewall(security group)
           - Create security group > Security group name - required
             - Name: "JenkinsSG"
         - Description
           - Enter "JenkinsSG"
         - Inbound Security Group Rules

         Rule 1

          - Type: "ssh", Protocol: "TCP", Port range: 22
          - Source type: "My IP", Name: YOUR IP, Description: optional

         Rule 2

          - Type: "Custom TCP", Protocol: "TCP", Port range: 8080 
          - Source type: "Anywhere", Source: "0.0.0.0/0", Description: "Jenkins Web Access"

   - Expand the **Advanced details** section, paste the script under the **User data** section or run the commands from the [script](jenkins-setup.sh) after installation.

   - Hit the Launch instance button

### 2. Log into Jenkins server & Perform Initial Setup

**Steps**

1. Login
   
   - ssh into the EC2 Instance by running

           ssh -i /location/of/your/jenkins/key ubuntu@public-ip

   - Check services and user jenkins by running
    
           systemctl status jenkins
           id jenkins

   - Log into the server by pasting the public IP into the browser appending port 8080; http://your-public-IP:8080
   - Follow the initial set up prompts and hit the **Save** and finish
   - To view the initial password run;

           cat /var/lib/jenkins/secrets/initialAdminPassword

2. Tools & Plugins Setup
   
   **Steps**

    1. To install a JDK version 11 on the frontend, SSH into your server and locate the install folder

            ls /usr/lib/jvm/installed-version-here

    2. Go to Dashboard > Manage Jenkins >  Tools 
    3. Install JDK version 11 tool
    
          - Go to JDK installations > Add JDK > JDK
           
            Name
              - OracleJDK11
              
            JAVA_HOME
              - /usr/lib/jvm/java-1.11.0-openjdk-amd64
    	
              - Hit the Add JDK button
        
    4. Install JDK version 8 tool
       
          - Go to JDK installations > Add JDK > JDK

            Name
              - OracleJDK8
        
	          JAVA_Home
              - /usr/lib/jvm/java-1.8.0-openjdk-amd64
  
    5. Install a Maven tool

          - Go to Maven installations > Add Maven > Maven > 
	        
            Name
              - MAVEN3
        	- Check the Install automatically box > Add Maven
  
            **Save** to finish


### 3. Creating jobs using Freestyle option

**Steps**

  1. Go to Dashboard > New Item or Create job
     - Enter an item name
       - "my-commands"

      - Click on Freestyle project to select it
      
      - Hit the OK

  2. Dashboard > "mycommands" > Configure > General
     - Description
       - Running some commands to test Jenkins jobs
     - Scroll down to:
     - Build Steps
       - Add build step
        - Execute shell > Command
          - Command
  
                id
                whoami
                pwd

      - Hit Save

  3. Go to Dashboard > "mycommands" > Build Now (to run the job)
      - Go to Under Build History

      - Click on Dashboard > "mycommands" > #1 > Console Output
  
        NOTE: Here there will be details of job that ran, i.e. who ran the job and its results. The "#1" in the example above is called a build ID. You run it again the build ID will increment to "#2", so on and so forth.

  4. Go to Dashboard > "mycommands" > Configure
     - Scroll down to:
     - Build Steps
       - Add build step
        - Execute shell
          - Command
  
                ehehjekksnjmns

        NOTE: This is second build step of a gibberish command, that'll fail. Just to demonstrate.

      - Hit Save

      - Hit Build Now
      - The job will fail by show a red cross mark

      - Click on Dashboard > "mycommands" > #2 > Console Output
     
        NOTE: You notice that the Console Output will show the first step has passed and the second step failed and giving the details with a "Finished: FAILURE" message.

  5. Go to Dashboard > "mycommands" > Workspace
     - You'll notice that there is nothing, this where all the job files are kept.
     - Dashboard > "mycommands" > Configure
     - Scroll down to Build Steps and remove the gibberish and replace it with these commands:
      
            echo "This is a test job ...." >> myfile.txt
            date
            ls -l 
            echo
            echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
            echo "Displaying contents of my file."
            cat myfile.txt
            echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"


      NOTE: This is to display how Jenkins jobs keeps files/artifacts and where they are stored.

      - Hit Save

      - Hit Build Now

  6. Click on Dashboard > "mycommands" > #1 > Console Output
  
      NOTE: All processes and all files are owned by jenkins user and jenkins group. This will be an important piece of info in production environment.

  7. The build was successful, now go back to Dashboard > mycommands > Workspace
     - You'll now see the file that was created displayed. You can read the contents if it's a text file like in our example or you can download a zip of all files.
     -  To delete the job, click on Dashboard > mycommands > Delete Project > Yes 
     - This was a bird's eye view of Jenkins setup and Freestyle project creation

### 4. First Freestyle Build Job using an artifact

**Steps**

**1. Build job**

   1. Go to Dashboard > New Item or Create job
        - Enter an item name
          - "Build"
        - Click on Freestyle project      
        - Hit the OK

   2. Dashboard > "Build" > Configure > General
      - Description
        - "Build artifact from a vprofile source code."
      - Under JDK > System > select OracleJDK11
      - Source Code Management > select Git > Repositories > Repository URL
      - Click on the "https://github.com/hkhcoder/vprofile-project"
        - On GitHub, go to Code menu > Clone > HTTPS and copy the URL, "https://github.com/hkhcoder/vprofile-project.git" and paste it in the field.
      - Skip Credentials field since it's a public repository
      - Branches to build > Branch Specifier (blank for 'any')
         - */main
      - Scroll down to Build Steps
         - Add build step
          - Invoke top-level Maven targets
            - Maven Version
              - Select "MAVEN3"
            - Goals
              - Type in "clean install"
      - Hit Save
      - Hit build Now
      - Go the URL link under Build History > Console Output to see build progress
      - If all good you should see BUILD SUCCESS at the very bottom, "Finished: SUCCESS"
      - Got to Dashboard > Build > Workspace you'll see the artifact there.

      NOTE: It's not recommended to store artifacts in Jenkins server. You need to store them outside for example using a tool like Nexus.
   3. Still under the same build job, go to Configure > Post-build Actions
       - Add post-build action
         - Archive the artifacts
      - Files to archive
        - **/*.war
      - Hit Save
      - Hit the Build Now button
      - Click on the new build's URL, you'll see the artifact.
      - Step back to Build > Workspace > Wipe Out Current Workspace

**2. Build-Test**

**Steps**

   1. Go to Dashboard > New Item or Create job
      - Enter an item name
        - "Build-Test"

      - Click on Freestyle project
      - Select Copy from 
        - Type in "Build"     
      - Hit the OK

   2. Dashboard > Build-Test > Configure > General
      - Change to JDK8
      - Scroll down  to "Build Steps"
      - Build Steps
         - Add build step > Invoke top-level Maven targets
          - Maven Version
            - Default
        
        NOTE: The Default option simply means that there is no Maven installation in this case.

      - Remove the Goals content
      - Add Post-build Actions step
      - Hit Save 
      - Hit the Build Now button
      - If the job fails basically, it's because Maven is not yet installed, the error message will read; 
      - "[Build-Test] $ mvn clean install
      - FATAL: command execution failed"
   3. SSH into your server and install maven
          
          sudo -i
          apt update && apt install maven -y
      After the installation completes run

            mvn -version
   4. Go to Build-Test again and hit Build Now

Up to this point, this was a warm up or to just get the hang of Jenkins. 

## Plugins, Versioning & more

### 1. Versioning

The Dashboard > *build-project-name* > Workspace holds the artifacts, every time you run a new build last contents of a workspace get replaced. This is a challenge, say, you changed your code and you run build the  build again that deploys your new artifact to your server but it breaks, meaning you have a new artifact that's broken and you can't roll back to anything that was working before because it's all replaced.

In this section we will learn how to do versioning so we can roll back in case it's needed.

**Steps**
   1.  Go to Dashboard > New Item or Create job
         - Enter an item name
           - "Versioning"

       - Click on Freestyle project
       - Select Copy from 
       - Type in "Build"    
       - Hit the OK
   2. Scroll down to "Post-build Actions", remove the artifact.
       - Hit Save
       - Run Build Now 
       - Go to Workspace and you should see the newly done job
       - Copy the name of the artifact, "vprofile-v2.war"
   3. Go to Configure > scroll down to Build Steps 
       - Build Steps
         - Add build step > Invoke top-level Maven targets
            - Maven Version
              - Select "MAVEN3"
            - Goals
            - Add build step
                -  Execute shell > Command

                  mkdir -p versions
                  cp target/vprofile-v2.war versions/vprofile-V$BUILD_ID.war
          NOTE: [Here](https://wiki.jenkins.io/JENKINS/Building-a-software-project.html) are other Jenkins environment variables to be used, when you want to call some in scripts.
      - Hit Save
      - Hit Build Now 4 times so we can compare build iteration versions.  
      - Go to Workspace > versions directory
      - The artifacts will listed there.
  
### 2. Plugins

Tools or extensions used to extend Jenkins functionality for CICD use cases. Other tools will be installed along the way at specific stages.

**Steps**

   1. Go to Dashboard > Manage Jenkins > Plugins > Available plugins
search for "Timestamp" plugin. Select "Zentimestamp" or any.
   2. Hit Install
   3. Go to Dashboard > Versioning > Configure
     - Check the "Change date pattern for the BUILD_TIMESTAMP (build timestamp) variable" box
       - Date and Time Pattern
         - YY-MM-DD_hh-mm-ss
   4. Scroll to Build Steps
       - Add build step
         - Invoke top-level Maven targets
           - Maven Version
             - Select "MAVEN3"
           - Goals
         - Add build step
           -  Execute shell > Command

                  mkdir -p versions
                  cp target/vprofile-v2.war versions/vprofile-V$BUILD_ID.war
                  cp target/vprofile-v2.war versions/vprofile-V$BUILD_ID-$BUILD_TIMESTAMP.war
           NOTE: The tagging is now with timestamp and build ID.
   5. Hit Save
   6. Hit Build Now 
   7. Go to Workspace > versions directory
        - The new artifact will be listed with its equivalent version and the timestamp in UTC standard respectively.

Versioning solves the challenge for roll back, however the artifacts are still being kept in Jenkins server which is not ideal because it's not meant to be a storage server. The solution is to ship the artifacts to external storage which we will do in the next section.

## Jenkins, Nexus & SonarQube Setup
This section will focus on deploying a CI pipeline using GitHub, Git, Jenkins, Maven, SonarQube and Nexus. This section will highlight the steps to build the CI pipeline, execution steps and resources setup, etc.

Workflow Diagram of the CI
![alt](Docker-CI%20Diagram.drawio.png)

### 1. Steps execution flow description of the CI diagram

1. Developer will pull the code locally, make the changes accordingly,  once satisfied with the changes, he will then push it to a remote repository like GitHub in this case.
2. As soon as there is code change, Jenkins will detect and fetch the code by using Git tool/plugin. 
3. Jenkins start a build job by running a Build using Maven.
4. Then Maven will run Unit test on the newly built artifact located within the source code to see if it works or not.
5. Compile reports in xml format then push it to code analysis.
6. SonarQube will do the Code Analysis, ie. does the code have vulnerabilities, are you following the best practices and does it have bugs? We will use SonarQube Scanner for scanning and Checkstyle. They will generate xml format reports within the SonarQube server. In SonarQube server you can have graphical presentation of the bugs, vulnerabilities, other states of your code. In this, you can set a quality gate where some parameters are checked against the code. If it fails to meet them checks, the pipeline stops and if it passes then an artifact gets created.
7. The artifact will be versioned and uploaded to NexusOSS Sonatype repository.
8. Build a Docker container.
9. Publish it to Amazon ECR.
10. It can now be deployed into a server.

### 2. Steps to set the Continuous Integration of the above pipeline

1. Jenkins Setup (skip this one because it's already done above)
2. Nexus Setup
3. SonarQube Setup
4. Security Group to allow connection among them (skip, it's done)
5. Plugins
6. Integrate with Jenkins
   1. Nexus
   2. SonarQube
7. Write a pipeline script
8. Code Analysis on SonarQube
9. Nexus Code Artifact Upload
10. Set notifications
### 3. Server Resources Setup

**1. Nexus Server Setup**

**Steps**

1. Go [here](/General-notes/Jenkins-notes/) to locate the installation scripts. You'll find all the scripts; for Sonarqube, Nexus and Jenkins. 
2. Create a key pair

   A key pair is used for ssh authentication when you want to access your resources remotely.

   - Go to EC2 > Network & Security > Key Pairs and hit Create key pair
     - Enter name "NexusKey"
     - Under Private key file format select .pem for Linux
     - Hit Create key pair
     - Change the key access permissions as per instructions indicated

3. EC2 Nexus VM instance setup

   1. In EC2 console click on Launch instance
        - Launch an instance
          - Name and tags
            - Name: "NexusServer"
          - Application and OS Images (Amazon Machine Image)
            - Search for Centos7/9
          - Instance type
            - t2.medium
          - Key pair(login)
            - Select "NexusKey"
          - Network Settings > Edit
            - Firewall(security group)
              - Create security group
                - Named, "NexusSG"
              - Description
                - Enter "NexusSG"
            - Inbound Security Group Rules
              Set notifications
              Rule 1
                - Type: "ssh", Protocol: "TCP", Port range: 22
                - Source type: "My IP", Name: YOUR IP, Description: *optional* 

              Rule 2
                - Type: "Custom TCP", Protocol: "TCP", Port range: 8081
                - Source type: "Anywhere", Source: "0.0.0.0/0", Description: "Nexus Web Access"

              Rule 3 is optional since rule 2 is open.
                - Type: "Custom TCP", Protocol: "TCP", Port range: 8081
                - Source type: "Anywhere", Source: "Jenkins-SG", Description: *Allow traffic from Jenkins*

        - Hit the Launch instance button

   2. SSH into the instance
  
          ssh -i "NexusKey.pem" centos@your-instance-public-IP
  
      **Note**: If the default user doesn't work, you may want to use "centos" as a user.

   3. Create a script as a root user
  
          vi nexus-setup.sh
      
      Copy, paste and save the [nexus-setup.sh](/General-notes/Jenkins-notes/Nexus-setup/nexus-setup.sh) content. 
    
   4. Change permissions and run the script to install Nexus onto it.
  
      chmod +x 'nexus-setup.sh' 
   5. Go to the browser

          http://nexus-server-public-IP:8081

   6. Copy the initial password path and run the command to reveal the password and update it accordingly. 

          cat /opt/nexus/sonatype-work/nexus3/admin.password

**2. SonarQube Server Setup**

**Steps**

1. In EC2 console click on Launch instance
     - Launch an instance
       - Name and tags
         - Name: "SonarServer"
       - Application and OS Images (Amazon Machine Image)
         - Search for ubuntu 22.0.4 LTS
       - Instance type
         - t2.medium
       - Key pair(login)
         - Select "SonarKey"
       - Network Settings > Edit
         - Firewall(security group)
           - Create security group
             - Named, "SonarSG"
           - Description
             - Enter "SonarSG"
         - Inbound Security Group Rules
           
           Rule 1
             - Type: "ssh", Protocol: "TCP", Port range: 22
             - Source type: "My IP", Name: YOUR IP, Description: *optional* 

           Rule 2 - Because of Nginx Service running in this VM as well
             - Type: "Custom TCP", Protocol: "TCP", Port range: 80
             - Source type: "Anywhere", Source: "0.0.0.0/0", Description: "Nginx Web Server Access"

           Rule 3 is optional since rule 2 is open.
             - Type: "Custom TCP", Protocol: "TCP", Port range: 80
             - Source type: "Anywhere", Source: "Jenkins-SG", Description: *Allow traffic from Jenkins*
     
     - Hit the Launch instance button

2. SSH into the instance
  
       ssh -i "SonarKey" ubuntu@instance-public-IP
3. Create a script as a root user
  
       vi sonar-setup.sh
   Copy, paste and save the [sonar-setup.sh](/General-notes/Jenkins-notes/Sonarqube-setup/sonar-setup.sh) content. 
   
4. Change script permissions and run the script

5. To check the browser

        http://sonar-server-public-IP

    Username and password

        admin
        admin

**3. List of Plugins to install**

1. Nexus
2. Sonarqube
3. Git
4. Pipeline Maven Integration Plugin
5. Build Timestamp
6. Pipeline Utility Steps

**Plugin installation**

**Steps**

1. Go to Dashboard > Manage Jenkins > Plugins > Available plugins

2. Search for Nexus and select the "Nexus Artifact Uploader" option.

    Search for Sonar and select the "SonarQube Scanner" option.

    Search for Build Timestamp and select the "Build Timestamp" option.
3. Set timestamp value to version artifacts
    - Go to Dashboard > Manage Jenkins > System > Pattern > Build 
      - Timezone
        - Your Org's
      - Timestamp
        - Pattern: "yy-MM-dd_HH-mm"

4. Search for Pipeline Maven and select the "Pipeline Maven Integration" option.

   Search for Pipeline Utility and select the "Pipeline Utility Steps" option.

5. Hit the Install button to continue

### 4. Write a pipeline script

Jenkins uses pipeline code using Pipeline DSL which written in Groovy.
There are two methods of writing this code, namely; Scripted method and Declarative method. Declarative method is the way to go.

Here is the [code](/General-notes/Jenkins-notes/pipeline), make sure the versions under Tools are spelt exactly the same as in the Jenkins Tools specifications. Otherwise it will throw an error when running the pipeline declarative file. Also, you need to copy a specific URL of the [branch](https://github.com/hkhcoder/vprofile-project.git) being declared in the code from the Code green dropdown button.

**Steps**

First option is running the pipeline by pasting code into the box

1. Go to Jenkins > Dashboard > New Item 
   - Enter an item name
     - "sample-paac"
  
2. Select the *pipeline* option
3. Hit the OK button
4. Next page scroll all the way down to *Pipeline > Definition* and make sure *Pipeline script* is selected and paste the [code](/General-notes/Jenkins-notes/pipeline) in the box.
5. Hit the Save button
6. Hit the Build Now to run the pipeline.

Second option is using a "Jenkinsfile" declarative file found in the source [code](https://github.com/hkhcoder/vprofile-project/).

1. Go to Jenkins > Dashboard > sample-paac > Configure
2. Scroll down to *Pipeline > Definition*
  
   - Select the *pipeline script from SCM* option
   - SCM
     - Select Git
        - Repositories
           - Repository URL
              - Paste the [code URL](https://github.com/hkhcoder/vprofile-project/)
           - Credentials
              - none
        - Branches to build
           - Branch Specifier (blank for 'any')
             - Enter "*/main"
     - Script Path
       - "Jenkinsfile"
3. Hit the Save button
4. Hit the Build Now to run the pipeline.
   
Note: Since we run using the first option, no need to run using the second one.

To locate the artifact

Go to Dashboard > sample-paac > your-build-# > Workspaces > click on the URL and open the /target folder to see the artifact.

### 5. Code Analysis on SonarQube
Why code analysis? and what is it? Code analysis will check ones' code against the best practices and flag the problems that get fixed by developers. Code analysis scans for vulnerabilities in the code, it also looks for bugs/functional errors in the code. All in all in it does improve code quality of an app.

**Examples of Tools Used**
1. Checkstyle
2. Cobertura
3. mstest
4. owasp
5. SonarQube Scanner, etc.

In this project we will use SonarQube Scanner and Checkstyle. Before anything, we need to install SonarQube tool to integrate the SonarQube Server into Jenkins.

**Steps**

1. You should have your SonarQube VM server up and running, log into it.
2. Boot up your Jenkins server to install SonarQube tool.
   Go to Dashboard > Manage Jenkins > Tools and scroll down to SonarQube Scanner installations
   - Hit the Add SonarQube Scanner
     - SonarQube Scanner
       - Name: "sonar4.7"
    - Leave the checkbox selected, expand the Install from Maven Central field and select SonarQube 4.7.x.x
3. Hit the Save button
4. To integrate with Jenkins;
   
   1. First and foremost fetch the token from SonarQube server and take note of it somewhere to be used later in Jenkins.
   
      To fetch the token;

        Click on your user account icon, select Administrator > My Account > Security

         - Generate Tokens: "jenkins"
         - Hit the Generate button
   2. Set up the private-IP-of-the-sonar-server since they are in the same network or the public one if it will be accessed from outside. I'll use the former since we are on AWS and not using an elastic IP(static).
   
      In Jenkins, go to Dashboard > Manage Jenkins > System

      - SonarQube Servers
       
        Leave the Environmental variables checked.

        SonarQube installations
        - Name: "sonar"
        - Server URL: http://your-private-IP
       
        Hit the Save button first and comeback to activate the add token section.
        - Server authentication token
          - Click on Add > Jenkins
            - Expand Kind field
              - Select the Secret text option.
                - Secret: Paste the token 
                - ID: "MySonarToken"
                - Description: "MySonarToken"
        - Hit the Add button and the Save button to finish

5. Create a Quality Gate in Sonar Server
   Go to Quality Gates > Create
    - Name: "vprofile-QG"
    - Add Conditions
      - Select On Overall Code option
      - Quality Gate fails when
        - Metric: Bugs 
        - Operator: is greater than 
        - Value: 60
6. Link the new quality gate to the project settings menu on top right section.
   
   1. Go to Projects > vprofile-repo > Project Settings >  Links > Quality Gate and select the "vprofile-QG" created earlier.
  
      Note: Jenkins is not going to fetch the quality gate information from SonarQube server, rather the SonarQube server will send the information to Jenkins server by using webhooks.

   2. Go to Project Settings > Webhooks > Create
    - Name: "jenkins-ci-webhook"
    - URL: http://jenkins-server-private-IP:8080/sonarqube-webhook
    - Hit on Create
  
      Note: The URL should be similar to above, of course replacing with your instances private IP, otherwise it will be in pending state and the job will end up failing. Also, the security group should allow SonarQube traffic in Jenkins.
### 6. Nexus Code Artifact Upload

Nexus is a storage location for software packages and retrieval, you can use Nexus as a package manager to also manage dependencies instead of letting the application update directory from the internet. You can have your own repos for softwares/packages to manage different dependencies.

Key Points

1. Runs on Java
2. Used to store artifacts
3. Used as a Package manager for dependencies
4. Opensource and Enterprise Versions
5. Supports Variety of repos like maven, apt, docker, Ruby gems, nuget for .NET, npm, apt, yum/dnf etc.

**Steps**

1. Create Nexus credentials in Jenkins
   
   a. Go to Dashboard > Manage Jenkins > Credentials > Stores scoped to Jenkins
    - Click on System > Global credentials (unrestricted) > Add Credentials
    - Username: admin
    - Password: admin123
    - ID: nexuslogin
    - Description: nexuslogin
    - Hit Create

2. Create a repository in Nexus server
   
   a. Log into Nexus server;

          URL: http://your-public-IP:8081
          Username: admin
          Password: admin123
   
   b.  Click on the Settings gear on top
    - Go to Repository > Create repository > maven2(hosted)
    - Name: vprofile-repo
    - Hit Create repository

    Note: The hosted option is for storing repos, the proxy is for managing dependencies and the group is to support both options.

3. Integrate with Jenkins, this is the last section of the [Jenkinsfile](/General-notes/Jenkins-notes/Jenkinsfile) section. Create a pipeline or run the previous one in Jenkins
   
4. Testing
  
    1. Log into into Nexus server

        URL: http://your-private-IP:8081
        username: admin
        password: admin123
    2. Go to Browse > vprofile-repo and you should see your artifact.

## Set automated notifications
Now that a pipeline is built and the artifact is being shipped to Nexus for storage, it's time to create a notification stage to get notified about the results of each build run.

**Steps**

1. Create Slack Account and setup
   1. Create a Slack Account or [log in](https://slack.com/signin#workspaces), if there is one already.
   2. Hit the Create a workspace button to continue, name it and hit Next and all the pertinent info.
   3. Create two channels namely; devopscicd and jenkinscicd or whatever makes sense.
   4. Go to [apps section](https://app.slack.com/apps) and search for Jenkins, and click on Jenkins CI, add it to Slack.
   5. Go to step 3 in instructions and copy the displayed token, paste it somewhere, scroll all the way down and hit the Save Settings button.
   
2. Integrate Slack in Jenkins

   1. In Jenkins go to Dashboard > Manage > Jenkins > Plugins > Available plugins
      - Search for Slack notification and install it.
   2. Go to Dashboard > Manage Jenkins > System, scroll all the way down to Slack section
      - Slack
        - Workspace: your workspace name
        - Credential: Hit add and select Jenkins
          - Kind: Secret text
          - Secret: Paste Slack token
          - ID: slack-token
          - Description: slack-token
          - Hit the Add button
        - Select your token
        - Default channel / member id: (#jenkinscicd) your Jenkins CICD channel
        - Hit Save
        - Hit the Test connection button.
        - Hit the Save button

   3. Hit the Save button

## Docker CI pipeline & Push to Amazon ECR

This section will focus on deploying the pipeline using AWS Amazon Container Registry service to store container images in AWS.After the artifact is built then it gets to be build into a container and be stored into Amazon ECR ready to be deployed. 

Workflow diagram
![alt](/General-notes/Jenkins-notes/Jenkins-CI.png)

**Steps**

Prerequisites
1. Install AWS cli
2. Install docker engine on Jenkins
    - Add jenkins user to docker group and reboot
3. Create IAM user with ecr permissions
4. Create ECR Repo on AWS to store Docker images
5. Plugins
   - Ecr, docker pipeline, aws sdk for credentials
6. Store AWS credentials in Jenkins
7. Run the pipeline

To begin, SSH into the Jenkins server

    ssh -i "jenkins-key.pem" ubuntu@jenkins-server-public-ip

**1. Install AWS cli & check installation**

    sudo apt update && sudo apt install awscli -y
    aws --version

**2. Installing Docker Engine**

Make sure to check latest [instructions](https://docs.docker.com/engine/install/ubuntu/) in case there are changes.

  1. Set up Docker's apt repository.

    # Add Docker's official GPG key:

    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    # Add the repository to Apt sources:

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

  2. Install the Docker packages.
  
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  
  3. Verify that the Docker Engine installation is successful by running the hello-world image.
   
    sudo docker run hello-world

  This command downloads a test image and runs it in a container. When the container runs, it prints a confirmation message and exits.

  4. Add Jenkins user to the Docker group since it's only root that has access
   
   Switch to root

    sudo -i
    usermod -a -G docker jenkins
    id jenkins
    reboot

**3. Create IAM user with ecr permissions**

1. Create user

   - Go to IAM > Users > Create user

     - Specify user details > Set permissions
       - User name: "jenkins"
     - Hit Next 
       - Set permissions > Permissions options
         - Attach policies directly
           - Add, "AmazonEC2ContainerRegistryFullAccess"
           - Add, "AmazonECS_FullAccess"
     - Hit Next
     - Hit Create user
  
2. Create access key for the user
   - Go to IAM > Users > jenkins > Security credentials
     - Create access key
       - Use case
         - Command Line Interface (CLI)
       - Confirmation
         - Check the box
   - Hit Next
   - Hit Create access key
3. Download.csv file
  
**4. Create ECR Repo on AWS to store Docker images**

1. Go to Elastic Container Registry > Create
   - Create repository 
     - General settings
       - Visibility settings
         - Private
       - Repository name
         - "vprofileappimg"
   - Hit Create repository

**5. Plugins**

1. Log into Jenkins

    http://jenkins-public-IP:8080

2. Go to Dashboard > Manage Jenkins > Plugins > Available plugins
   - Search for and check;
     -  Docker pipeline, Amazon ECR, Amazon Web Services SDK :: All, and CloudBees Docker Build and Publish.

    - Hit Install

**6. Store AWS credentials in Jenkins**

1. Go to Dashboard > Manage Jenkins > Credentials > Stores scoped to Jenkins
    - Select System > Global credentials (unrestricted) > Add Credentials
      - New credentials > Kind: AWS credentials
      - ID: awscreds
      - Description: awscreds
      - Access Key ID: from-your-downloaded-csv-file
      - Secrete key Access: from-your-downloaded-csv-file
    - Hit Create

**7. Run the pipeline**

1. Go to the [code](/General-notes/Jenkins-notes/paac_ci_Docker_ECR.groovy) and update the "environment" code block.

   - Update region, make sure to verify from the URL address on top under ECR, your appRegistry URL and the vprofileRegistry and append "https://" to it.

          environment {
              registryCredential = 'ecr:us-east-1:awscreds'
              appRegistry = "705676565906.dkr.ecr.us-east-1.amazonaws.com/vprofileappimg"
              vprofileRegistry = "https://705676565906.dkr.ecr.us-east-1.amazonaws.com/"
          }

  2. Go to Dashboard > New Item 
       - Name: "docker-ci-pipeline"
       - Select Pipeline
       - Hit OK
       - Paste your code under the Script box
       - Hit Save
       - Hit the Build Now
  3. Go to Elastic Container Registry to see your newly created container.

## Docker CICD pipeline using Elastic Container Service(ECS)

The pipeline will pickup where Elastic Container Registry left off, we will fetch the container stored in ECR and deploy get it deployed to ECS. ECS is a container orchestration application using Fargate as a serverless option or EC2 VMs for running clusters.

Workflow diagram

![CICD Diagram](/General-notes/Jenkins-notes/jenkin-cicd-pipeline.png)
  
 **Plugins**
 -  Pipeline:aws steps

 **Code Section Update** 

  The section of the pipeline code is setting global variables i.e. "cluster and service", and insert its stage code block.

    environment {
        registryCredential = 'ecr:us-east-2:awscreds'
        appRegistry = "951401132355.dkr.ecr.us-east-2.amazonaws.com/vprofileappimg"
        vprofileRegistry = "https://951401132355.dkr.ecr.us-east-2.amazonaws.com"
        cluster = "vprofile"
        service = "vprofileappsvc" 
    }


    stage('Deploy to ecs') {
          steps {
        withAWS(credentials: 'awscreds', region: 'us-east-2') {
          sh 'aws ecs update-service --cluster ${cluster} --service ${service} --force-new-deployment'
        }
      }
     }

**Steps**

1. Create a cluster
   - Go to ECS > clusters > Create cluster
     - Cluster configuration
       - Cluster name: "vprofile"
      - Default namespace - optional : "vprofile"
    - Infrastructure
      - Select AWS Fargate (serverless)
    - Monitory
      - Toggle the button on
    - Tags - optional > Add tag
      - Key: Name
      - Value - optional: "vprofile"
    - Hit Create
  
    Note: If you see a red error banner, all you need to do is create the cluster again.
    
    Resolution

    Amazon Q recommends the following steps to resolve your error

   1. Go to the AWS CloudFormation console
   2. Select the stack named "Infra-ECS-Cluster-vprofile-fb33b73c"
   3. From the stack actions, choose "Delete Stack"
   4. Confirm the stack deletion
   5. Once the stack is deleted, try creating the ECS cluster again from the ECS console
   
2. Create Task definitions (Contains details of your container, CPU, RAM, etc.)
   - Go to ECS > clusters > Task definitions
     - Create new task definition
       - Task definition configuration
         - Task definition family
           - Name it "vprofileapptask"
       - Infrastructure requirements
         - Launch type: AWS Fargate
         - OS, Architecture, Network mode: Leave default
         - Task size
           - CPU: 1
           - Memory: 2GB
         - Task roles - conditional
           - Task role: blank
           - Task execution role: Create new role
       - Container - 1  Info
         - Container details
           - Name: "vproapp"
           - Image URI: your-ECR-image
           - Essential container: Yes
           - Private registry Info
             - Container port: 8080
             - Port name: "vproapp-8080-tcp"
           - Logging - optional
             - Log collection Info
             - Check the Use log collection box
           - Tags - optional  Info
             - Key: Name
             - Value: "vprofileapptask"
    - Hit the Create button


3. Update the task role
   - Go to Task definitions > vprofileapptask > vprofileapptask:1 > Task execution role, click on the link.
   - Go to Add permissions > Attach policies
     - Search for Cloudwatch
     - Check the CloudWatchLogsFullAccess option.
     - Hit Add permissions
  
    Note: This step is mandatory, otherwise containers won't be created.

4. Create a service that will manage the container
   
   - Go to Amazon Elastic Container Service > Clusters > vprofile > Services
   - Hit Create
   - Leave the defaults of Create > Environment
   - Deployment configuration
     - Application type: Service
     - Task definition
       - Family: "vprofileapptask"
       - Revision: Latest
       - Service name: "vprofileappsvc"
       - Service type: Replica
       - Desired tasks: 1
     - Deployment options
       - Leave selected
     - Deployment failure detection
       - Uncheck
     - Networking
       - Security group
         - Create a new security group
         - Security group details 
           - Security group name: "vproappecselb-sg"
           - Security group description: "vproappecselb-sg"
           - Inbound rules for security groups
             - Type: HTTP, Protocol: TCP, Port range: 80, Source: Anywhere, Values: 0.0.0.0/0, ::/0
             - Type: HTTP, Protocol: TCP, Port range: 8080, Source: Anywhere, Values: 0.0.0.0/0, ::/0
     - Load balancing - optional
       - Load balancer type: Application Load Balancer
       - Load balancer name: "vproappelbecs" 
       - Target group
         - Target group name: "vproecstg"
         - Health check path: /login
     - Hit Create
     - Check if successful
       - Go to EC2 >Target groups > vproecstg > Details > Load balancer
         - Click on the link
         - DNS name Info
           - Copy the URL and paste it in a new tab
5. Run the pipeline
   
   Go to ECS > Clusters
   - Copy cluster name: "vprofile"
   Go to ECS > Clusters > vprofile > Services
   - Copy service name:  "vprofileappsvc"
   Update the [code](/General-notes/Jenkins-notes/paac_ci_Docker_ECR.groovy) accordingly

6. Clean up
   1. Go to EC2 > Check SonarServer > Instance state > Terminate instance
   2. Go to EC2 > Check NexusServer > Instance state > Terminate instance
   3. Go to ECS > Clusters > vprofile > Services
      - Select the Update button > Desired tasks:o
      - Update
      - Delete service
   4. Go to ECS > Clusters 
      - Select the cluster > Delete cluster
   5. Go to EC2 > Load balancers > Click on vproappelbecs > Actions > Delete load balancer
   
## Activating Build Triggers

Instead of initiating the build trigger manually like we have been doing sofar, you need to use build triggers extensions. This section will discuss each build trigger and how to set it up.

### Popular Build Triggers Examples

1. Git Webhook
   
   Git will send a JSON payload to a repository like, GitHub whenever there is a commit to the repository so the GitHub repository will trigger a Jenkins job.

2. Poll SCM
   
   This is the opposite of the Git Webhook, in Poll SCM, Jenkins will check for commits in GitHub repository in an interval that you specify, for example every 5 mins.

3. Scheduled jobs
   
   This is like a cron job format schedule, Jenkins will run at the interval or the specified time.

4. Remote Triggers

   Slightly complex but very useful for DevOps or Architects, Jenkins jobs can be triggered from anywhere, there are tokens, and you make your calls using an API, etc. secrets for example from Ansible playbooks. More details [here](). 

5. Build after other projects are built
   
   This is simple, all you do is to select a job to run after another job is built. A completion of a previous job triggers the build run.

### Build Triggers Implementation Process  
**Steps**

1. Create a Git repository on GitHub
2. SSH auth
3. Create a Jenkinsfile in Git repo and commit
4. Create Jenkins job to access Jenkinsfile from git repo
5. Test triggers


**1. Create a Git repository on GitHub**
1. Log into your [GitHub](https://github.com) account
2. Create a new repository and name it jenkins-triggers
3. Keep it Private and hit Create repository

**2. SSH Auth**
 1. [Create](https://docs.oracle.com/en/cloud/cloud-at-customer/occ-get-started/generate-ssh-key-pair.html) an SSH key on your computer
 2. Copy the public key
   
        ls .ssh/ && cd .ssh/
        cat id_rsa.pub
 3. Go to your GitHub Settings not the repo Settings > SSH & GPG Keys
   - Hit New ssh key button > Add new SSH Key > Title: "MyLaptop"
   - Key type: Authentication key
   - Key: Paste the Public Key content here.
   - Hit the Add SSH Key and enter your password if prompted

 4. Go to your the new repo in GitHub and copy the SSH link under Quick Setup not the HTTPS.

**3. Create a Jenkinsfile in Git repo and commit**

  1. Clone the repository
   
          mkdir /whatever/path/and/name
          cd into it
          git clone git@github.com:your-repo-name/jenkins-triggers.git
  2. Create a Jenkinsfile in the folder
    
    
          /* groovylint-disable-next-line CompileStatic */
          pipeline {
              agent {
                  stage {
                      steps {
                          sh 'echo "Build completed"'
                      }
                  }
              /* groovylint-disable-next-line FileEndsWithoutNewline */
              }
          }
  3. Commit the file
    
          git add .
          git commit -m "My first commit"
          git push origin main

**4. Setup Test triggers Initial Configs**

 1. Got to Manage Jenkins > Security > Security >  Git Host Key Verification Configuration
      - Accept first connection 
      - Hit Save'Build'
 2. Go to Dashboard > New item > Enter an item name:"Build" 
    - Select pipeline and hit Save
   
 3. Scroll down to Pipeline > Definition
    - Select Pipeline script from SCM
    - SCM 
      - Git
      - Repositories > Repository URL
        - Copy the SSH URL not the HTTPS i.e. "git@github.com:mbadwa/jenkins-triggers.git"
        - Credentials
          - Hit the Add
            - Kind
            - Select SSH Username with private key
              - ID: gitsshkey
              - Description: gitsshkey
              - Username: your-Git-HuB-account(mine is mbadwa)
              - Private Key
                - Enter directly > Add
  
      Fetch your private key from your machine and paste in the box

          cat ~/.ssh/id_rsa
        
        
      - Hit the Add button
      - Branches to build > Branch Specifier (blank for 'any')
        - Enter "main"
    - Script Path
      - Jenkinsfile (since it's in the root folder in GitHub)

     - Hit Save
 4. Build Now

### Varied Build Trigger Types Setup

**1. Setting up Git Webhook Trigger**

A job will get triggered based on events in GitHub repo
  1. Copy the Jenkins URL, "http://your-jenkins-server-ip:8080"
  2. Go to your GitHub repo ie. jenkins-triggers Settings > Webhooks > Add webhook
   - Payload URL
    - Paste your URL by appending GitHub settings to it like so;
      - http://your-jenkins-server-ip:8080/github-webhook/
   - Content type
    - application/json
   - Secret
     - Leave the field blank
   - SSL verification
     - Leave it checked
   - Which events would you like to trigger this webhook?
     - Just the push event. 
  3. Go to Dashboard > Select your Job > Configure
       - Build Triggers, select GitHub hook trigger for GITScm polling
       - Hit Save
  4. Do a commit in Git and push it to GitHub so see if the trigger gets triggered.

**2. Setting up Poll SCM Trigger**

   1. Go to Dashboard > Select your Job > Configure
       - Build Triggers, select Poll SCM deselect the Git option.
         - Schedule
  
                * * * * *
          Every minute, every hour, every date, every month, everyday i.e. meaning run every minute
       - Hit Save
  
    
                Note: The format follows cronjob like in Linux, for more details click on the ?
                MINUTE HOUR DOM MONTH DOW

                MINUTE  Minutes within the hour (0-59)
                HOUR    The hour of the day (0-23)
                DOM     The day of the month (1-31)
                MONTH   The month (1-12)
                DOW     The day of the week (0-7) where 0 and 7 are Sunday.


   2. Go to Dashboard > Select your Job > Git Polling log to see the logs
   

**3. Setting up Scheduled Jobs Trigger**

   1. Go to Dashboard > Select your Job > Configure
       - Build Triggers, select Build periodically
         - Schedule

                30 20 * * 1-5

        Every 30 minutes, @ 8 PM, every date, every month, Mon - Friday i.e. meaning run everyday at 8:30 PM, Mon through Friday.
      - Hit Save
  
  2. Verify after the scheduled time
    
**4. Setting up Remote Triggers trigger**

**Steps**

1. Generate JOB URL
    1. Job Configure => Build Triggers
    2. Check mark on “Trigger builds remotely”
    3. Give a token name
    4. Generate URL & save in a file
2. Generate Token for User
    1. Click your username drop down button (Top right corner of the page)
    2. configure => API Token => Generate
    3. Copy token name and save username:tokenname in a file
3. Generate CRUMB
    1. wget command is required for this, so download wget binary for git bash
    2. Extract content in c:/program files/Git/mingw64/bin
    3. Run below command in Git Bash, (replace username,password,Jenkins URL)
  
            wget -q --auth-no-challenge --user username --password password --output-document - 'http://JENNKINS_IP:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)'
    
    4. Save the token in a file

4. Build Job from URL

By now we should have below details

      1. JENKINS Job URL with token
         E:g http://52.15.216.180:8080/job/vprofile-Code-Analysis/build?token=testtoken
      2. API Token
         USERNAME:API_TOKEN
         E:g admin:116ce8f1ae914b477d0c74a68ffcc9777c
      3. Crumb
         E:g Jenkins-Crumb:8cb80f4f56d6d35c2121a1cf35b7b501
    
    Fill all the above details in below URL and Execute
    
    curl -I -X POST http://username:APItoken @Jenkins_IP:8080/job/JOB_NAME/build?token=TOKENNAME -H "Jenkins-Crumb:CRUMB"
    
    e:g curl -I -X POST http://admin:110305ffb46e298491ae082236301bde8e@52.15.216.180:8080/job/vprofile-Code-Analysis/build?token=testtoken -H "Jenkins-Crumb:8cb80f4f56d6d35c2121a1cf35b7b501"
Note: The original document is [here](/General-notes/Jenkins-notes/Build+Triggers+Remotely.pdf).


1. Go to Dashboard > Select your Job > Configure > Build Triggers
   - Select, Trigger builds remotely (e.g., from scripts)
     - Authentication Token
       - name it "mybuildtoken", you can chose any name
       - Copy the URL underneath like so;

             JENKINS_URL/job/Build/build?token=TOKEN_NAME 
   - Hit Save
2. Constructing the job URL
          
          #Job URL
          http://3.85.112.116:8080/job/Build/build?token=mybuildtoken
         
   1. Go to the user you logged in with > expand the down arrow > select Configure > API Token > Hit Add new token > Generate
          
   2. Copy Generated token append your username, in my case it's "admin"

          admin:113113a8ca6076f73fe8a86f4377eb733a

3. CRUMB generation

      Update user:"admin" and password: "your-Jenkins-password"

        wget -q --auth-no-challenge --user admin --password admin123 --output-document - 'http://3.85.112.116:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)'
    
  - Go to your terminal and paste the URL to create the CRUMB 
      
      It should look like this

        Jenkins-Crumb:992d9695fb06564e4ba74e1c990c5e3477c697b04638f7a8746c8ebae1ad67da

4. Curl Command construction
   
        curl -I -X POST http://username:APItoken @Jenkins_IP:8080/job/JOB_NAME/build?token=TOKENNAME -H "Jenkins-Crumb:CRUMB"

   Substitution with our information, replace username:token with **"admin:113113a8ca6076f73fe8a86f4377eb733a"** and replace **Jenkins_IP:8080/job/JOB_NAME/build?token=TOKENNAME** with **"3.85.112.116:8080/job/Build/build?token=mybuildtoken"** amd finally the Jenkins-Crumb:CRUMB with **"Jenkins-Crumb:992d9695fb06564e4ba74e1c990c5e3477c697b04638f7a8746c8ebae1ad67da"**

   Final result
      
        curl -I -X POST http://admin:113113a8ca6076f73fe8a86f4377eb733a@3.85.112.116:8080/job/Build/build?token=mybuildtoken -H "Jenkins-Crumb:992d9695fb06564e4ba74e1c990c5e3477c697b04638f7a8746c8ebae1ad67da"

  5. Go to Jenkins > Dashboard > "your-job-name"

      Copy the curl command and paste it in your terminal and wait  for the magic to happen.


**5. Build after other projects are built trigger**

The job run is dependent on the completion of another job. This one is pretty straight forward;

1. Go to Dashboard > New item > name it, "test-job"
     - Select Freestyle project option
     - Go to Build Steps > Execute shell and paste
  
            date
            echo 'Run after Build job is complete'
    - Hit Save and run the job to test it
2. Open the test-job > Configure > Build Triggers > check the Build after other projects are built > Projects to watch
   - Type in the name of the job it should run after
   - Hit Save
3. Go to Dashboard > "Build" > Hit Build Now
   - Click on the # and open Console Output at the very bottom you should see the result like so;
  
          Triggering a new build of test-job #2
          Finished: SUCCESS
    Note: You can click on the link of the second job to see the results as well.

## Jenkins Master/Slave

Up until now, all the jobs ran on the Master node. Normally in production you will have different teams wanting to run jobs/projects on Jenkins for their CICD pipelines. To relieve the server workload, you run jobs from other machines/nodes. They are called slave nodes for Jenkins. Next, we will see how to set them up.

### Use cases

1. Load Distribution/distributed builds - using Jenkins at an organization level and there many jobs triggered automatically and Jenkins doesn't have enough capacity to run those jobs. Then you can add a node as a Slave. Whenever Jenkins gets a job, it will decide whether to run it on the Slave or itself. Jenkins Master Executes Job on a Node if selected.
2. Cross Platforms Build - If you are running or executing a build for .NET platform(Windows), IOS(Mac OS) from Jenkins Master(Linux) you need to install a Windows node as a slave and specify to run all Windows job on the Windows node.
3. Software Testing - You want to execute Testers Test Automation Scripts from a node by adding the Software Testers' machines, most likely they would be running their tests on Windows machines. You need to work in corroboration with them.
4. If you would like to run your scripts, Python, Bash, Ansible etc, you can set up a node as a slave and do your testing.

### Prerequisites for Node Setup
1. Any OS
2. Network access from the Master
   
   Note: Check Firewall rules 
3. Java, JRE, JDK depending on the requirement
4. User
5. Directory with User ownership
6. Tools required by the Jenkins job e.g Maven, Ant, Git, etc.

#### 1. Slave Node Setup

**Steps**

1. Log into [AWS](https://aws.amazon.com/) and go to EC2 > Instances > Launch an instance
   - Launch an instance 
     - Name and tags 
       - Name: "Slave-Jenkins"
     - Application and OS Images (Amazon Machine Image)
       - Ubuntu 20.0.4 LTS
     - Instance type  
       - t2.micro
     - Key pair (login)
       - Create new key pair: "slave-jenkins-key"
     - Network settings > Create security group
       - Allow SSH traffic from My IP
       - Allow SSH traffic from "Jenkins-SG"
   - Launch instance
2. SSH into the node server and set it up for SSH
   
      1. Change permissions

        chmod "400" slave-jenkins-key.pem

      2. SSH into the vm
   
        ssh -i "slave-jenkins-key.pem" ubuntu@your-vm-public-IP
        sudo -i

      3. Install the requirements
        
        apt update && apt install openjdk-11-jdk -y

      4. Create a user
        
        adduser devops
        passwd devops

      5. Create a directory
        
        mkdir /opt/jenkins-silver-builds

      6. Change directory ownership
        
        chown devops.devops /opt/jenkins-silver-builds -R

      7. Switch to devops
        
        su devops

      8. Create .ssh folder in devops user
        
        mkdir ~/.ssh; cd ~/.ssh/ && ssh-keygen -t rsa -m PEM -C "Jenkins agent key" -f "jenkinsAgent_rsa"

      9.  Add the public SSH key to the list of authorized keys on the agent machine
        
        cat jenkinsAgent_rsa.pub >> ~/.ssh/authorized_keys

      10. Ensure that the permissions of the ~/.ssh directory is secure, as most ssh daemons will refuse to use keys that have file permissions that are considered insecure:
        
        chmod 700 ~/.ssh
        chmod 600 ~/.ssh/authorized_keys ~/.ssh/jenkinsAgent_rsa

      11. Copy the private SSH key (~/.ssh/jenkinsAgent_rsa) from the agent machine to your OS clipboard (eg: xclip, pbcopy, or ctrl-c).
        cat ~/.ssh/jenkinsAgent_rsa

        The output should be similar to this:
        -----BEGIN RSA PRIVATE KEY-----
        ...
        -----END RSA PRIVATE KEY-----

3. In Jenkins go to Dashboard > Manage Jenkins > Nodes > New node
   - Name: "silver-node"
   - Type: Permanent Agent
   - Hit Create
   - Number of executors (how many jobs you want to execute in parallel)
     - 2
   - Remote root directory
     - /opt/jenkins-silver-builds
   - Labels: SILVER
   - Usage: Use this node as much as possible
 
     Note: the above option is for load distribution, the other option is when you want a build to run when they are a specific build. For example, if it's a Windows load then it can run only on this node.
   
   - Launch method: Launch agents via SSH
     - Host: private-IP of the Slave
      - Credentials
       - Add Jenkins
       - Kind: SSH Username with private key
         - Username: devops
         - ID: silver-login-key
         - Private Key > Enter directly: Paste your private ssh key from your slave node
    
          Paste the SSH key you copied in point # 2:11 above

              cat cat ~/.ssh/jenkinsAgent_rsa
       - Hit Add
       - Hit Save

#### 2. Test Slave Node**

1. Go to Jenkins > Dashboard > New item > name-of-your-job, "test-build-on-slave" 
   - Freestyle
   - Hit OK
2. Scroll down to Build Steps > Add build step
   - Execute shell > Command
     - Paste your commands in the box
            
            date
            pwd
            whoami
            ls -ltr
            echo "This is so cool!"
     - Hit the Save button
3. Hit Build Now
   chances are it will build from the node because we selected the option of using node as much as possible

   Console Output

        Started by user Admin
        Running as SYSTEM
        Building remotely on silver-node (SILVER) in workspace /opt/jenkins-builds/workspace/test-build-on-slave
        [test-build-on-slave] $ /bin/sh -xe /tmp/jenkins12431849568063232698.sh
        + date
        Thu Jul 18 23:36:03 UTC 2024
        + pwd
        /opt/jenkins-builds/workspace/test-build-on-slave
        + whoami
        kendra
        + ls -ltr
        total 0
        + echo This is so cool!
        This is so cool!
        Finished: SUCCESS
    As you can see the job build ran in the silver-node and the message even says that the build was run remotely.

4. Go to the node and verify that the build files are there
   
        ls /opt/jenkins-builds/workspace/
5. To always build using a node, not letting it to chance
   - Go to Dashboard > your-build-name, "test-build-on-slave" > Configure > General > Restrict where this project can be run
     - Label Expression: SILVER
     - Hit Save
  
    Note: On a side note, you may choose a job and change the build label for example SILVER, and you need to make sure it has Git, it should have MAVEN, since MAVEN was installed globally in Jenkins server, it will be installed before running the build on Silver node.
## Securing Jenkins 
This section will tackle Authentication and Authorization, i.e. user, permissions, roles, job permissions, etc. As a devops you build a pipeline and then hand it over to developers, testers, Ops or non-Ops teams. This require segregation of duties and least privilege practice in place. Authentication is login, Authorization is the privilege.

### 1. Methods of Authentication

1. Create a User Login using Jenkins own database.
2. Sign up using LDAP Integration, can be logged in using AD.

### 2. Authorization/Permissions on Jenkins wide

1. Admin
2. Read
3. Jobs
4. Credentials
5. Plugins, etc

### 3. Permissions limited to particular Job(s)

1. View
2. Build
3. Delete
4. Configure
5. e.t.c

You can create different roles and add users to it or group, to facilitate access management in Jenkins.

### 4. Authentication and Authorization

1. Go to Dashboard > Manage Jenkins > Security
   Check the Disable “Keep me signed in”

   Security Realm

    - Delegate to serverlet container
    - Jenkins' own user database
      - You can check the "Allow users to sign up", this will be a landing page for users to sign themselves up.
    - LDAP - Good for large organization which manages central authorization, e.g. AD
    - Unix user/group database
    - None
  
    Note: Recommended options are Jenkins' DB and LDAP

2. Authorization
   - Anyone can do anything
   - Legacy mode - anonymous access
   - Logged in users can do anything
   - Matrix-based security
   - Project-based Matrix Authorization Strategy
  
  Note: Recommended options are Matrix-based security and Project-based Matrix Authorization Strategy
### 5. Different Authorization Types Setup

**Steps**

#### 1. Select Matrix-based security
  
  To create an admin user:
  
   1. Hit Add user or group > User or group name
      - admin
        - Check the Administer box
      - Hit Save

  2. Direct an ordinary user to go to http://your-jenkins-server-ip:8080 to sign up
      - Click on Register 
        - Username: John
        - Full name: Doe
        - Email: john.doe@devops.io
        - Password: password
      - Create account
  
      Note: When John Doe tries to login, access will be denied because; "John is missing the Overall/Read permission" 
      
  3. Grant access to John; 
    - Go to Dashboard > Security > Add user > User or group name
        - john
         - Under Overall check Read
         - Under Job check; Build, Cancel, Configure, Create, Read, and Workspace permissions.
      - Hit Save
  
      Note: As you can see it's not all that fine because John can now see other projects that he doesn't belong to, for that we will set the Project-based Matrix Authorization Strategy

#### 2. Project-based Matrix Authorization Strategy**

1. Go to Dashboard Manage Jenkins > Security > Project-based Matrix Authorization Strategy
     - Add a user
       - john
         - Under Overall check Read
         - Go to Dashboard and select a job
           - Configure > General 
             - Select Enable project-based security > Inheritance Strategy 
               - Add user
                 - john
                   - Select all permissions on the far right box.
                   - Deselect Delete under Credentials, Job and Run sections
                   - Deselect Configure under Job section
2. Hit Save
   
    Note that John has only access to this job/project and effectively can't delete nor configure it as well. This is following security best practices of least privilege permissions.

 ### 6. Creating a role
 For easy management of users, you can create roles and assign them to users to streamline user permissions.

 **Steps**

 1.  Go to Dashboard > Manage Jenkins > Plugins
       - Available plugins 
         - Search for Role-based Authorization Strategy Version 
       - Hit Install
 2. Go to Dashboard > Manage Jenkins > Security
      - Authorization
        - Select Role-Based Strategy
      - Hit Save
 3. Go to Dashboard > Manage Jenkins > Security > Manage and Assign Roles
      - Role to add: "devops" 
      - Hit Add
       - Under Overall
         - Read
        - Under Agent
          - Build, Configure, Create, Delete, Disconnect and Provision
        - Under Job
          - Discover, Move, Read, Workspace
    - Hit Save
    - Go to Assign Roles > Global roles
      - Hit Add User
        - john
          - Check the devops box against him
    - Hit Save
  
### 7. Add User from Jenkins

- Go to Dashboard > Manage Jenkins > Jenkins’ own user database > Create User
  - Username: jane
  - Password: password
  - Full name: Jane Doe
  - Email address: jane.doe@devops.io
- Create User

# References
1. [Jenkins Reference](https://www.jenkins.io/doc/book/pipeline/)
2. [Nexus Pipeline Example Code](https://github.com/jenkinsci/nexus-artifact-uploader-plugin)
3. [Install Docker Engine](https://docs.docker.com/engine/install/)
4. [Add an SSH-Enabled User](https://docs.oracle.com/en/cloud/cloud-at-customer/occ-get-started/add-ssh-enabled-user.html)
5. [How to Connect to Remote SSH Agents?](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/client-and-managed-controllers/how-to-connect-to-remote-ssh-agents)