# OS Tasks Automation with Python


1. Add Users
2. Add Groups
3. Add Users to group
4. Create directory
5. Assign user & group ownership to directory
6. Test if user or dir exists, if not create
7. SSH in Python
8. Library Fabric
9. Provision web server by Using Fabric
10. Python Virtualenv
11. Python Modules and Libraries
 
 ## Tasks Automation with Scripts

#### 1. Install VMs from a Vagrantfile

1. Go to [vagrant-vms](./vagrant-vms/Vagrantfile) folder and run

		cd ~/vagrant-vms
 		vagrant up

2. Log into scriptbox

		vagrant ssh scriptbox

#### 2. Logging into scriptbox and creating a script

3. Create a directory to manage the web VMs

		sudo mkdir /opt/scripts && cd /opt/scripts

4. Create a directory named os-tasks

		sudo mkdir os-tasks

5. Create a script named check-file.py

  		sudo vim check-file.py
		
	- Check your default Python version

			ls -l /usr/bin/python3
	
	- Create this [script](./scripts/2.%20ostasks/check-file.py)
	
6. Make the script executable and run it

  		chmod +x check-file.py
		./check-file.py

	Note: To run Linux commands directly from Python3, in example below we are running 'ls' command. If successful it will run an 0 exit code, unsuccessful will display a non zero code.

		python3
		import os
		os.system("ls")

#### 4. Create a file and run the script again

1. Create a sample file

		sudo touch sample.txt

2. Run the script again

  		./check-file.py

#### 5. Create users and run the script

1. Create a list of [Users](./scripts/2.%20ostasks/ostasks.py)
2. Make make the list executable

		sudo chmod +x ostasks.py
3. Run the script

		sudo ./ostasks.py

4. When you run the script again it'll indicate that users are already added.

		sudo ./ostasks.py
5. Checking group and create if it doesn't exist

		sudo ./ostasks.py

6. Checking if users are added to group science

		sudo ./ostasks.py
		id alpha && id beta && id gamma

7. Adding directory

		sudo ./ostasks.py
		ls -ld /opt/science_dir


## Python Fabric

It is a command line module that needs to be installed by pip module. The pip module can be installed by this script [here](https://bootstrap.pypa.io/get-pip.py).

#### 1. Python Fabric Setup on SysOps Machine

1. Download the script

		sudo wget https://bootstrap.pypa.io/get-pip.py

2. Update ubuntu apps

		sudo apt update

3. Execute the script
 
		sudo python3 get-pip.py

4. Install Fabric 

		sudo pip install 'fabric<2.0'

5. Create a fabric directory

		mkdir fabric && cd fabric

6. Create a fabfile

		sudo vim fabfile.py

7. Write a simple function for [testing](./scripts/3.%20fabric/greeting.py)

8. List it using fab

		fab -l

9. Run the function using Fabric by *fab function-name:argument*

		fab greeting:Evening

10. Import fabric module into the [script](./scripts/3.%20fabric/greeting.py)

		from fabric.api import *

11. Run system_info fabric locally

		fab -l
 		fab system_info

#### 2. Setting up remote servers for Fabric

1. Create a users with sudo privilege in web01 and web02

		# Turn on the two web servers
		vagrant up web01
		vagrant up web02
		vagrant status

2. Log int web01 to create a user named "devops"
	
		vagrant ssh web01
		sudo useradd devops
		sudo passwd devops - Mbadwa2024
		sudo visudo

3. Locate Root user and add this line below it.
	
		devops	ALL=(ALL)		NOPASSWD: ALL

5. By default password login is disabled in Vagrant VMs, we need to enable it. Locate, "PasswordAuthentication no" and toggle it to "yes"

		sudo vi /etc/ssh/sshd_config
		PasswordAuthentication yes

6. Restart SSH service
	
		sudo systemctl restart sshd

7. Log int web01 to create a user named "devops"
	
		vagrant ssh web01
		sudo useradd devops
		sudo passwd devops - Mbadwa2024
		sudo visudo

8. Locate Root user and add this line below it.
	
		devops	ALL=(ALL)		NOPASSWD: ALL

9. By default password login is disabled in Vagrant VMs, we need to enable it. Locate, "PasswordAuthentication no" and toggle it to "yes"

		sudo vi /etc/ssh/sshd_config
		PasswordAuthentication yes

10. Restart SSH service
	
		sudo systemctl restart sshd
	
11. Log int web02 to create a user named "devops"
	
		vagrant ssh web02
		sudo useradd devops
		sudo passwd devops - Mbadwa2024
		sudo visudo

12. Locate Root user and add this line below it.
 	
		devops ALL=(ALL)  NOPASSWD: ALL

13. Enable password prompt. Locate, "PasswordAuthentication no" and toggle it to "yes"

		sudo vi /etc/ssh/sshd_config
		PasswordAuthentication yes

14. Restart SSH service
		
		sudo systemctl restart sshd

#### 3. Running Fabric on remote Servers

1. Run remote_exec fabric to query remote machines
	
		fab -l 
		remote_exec

2. SSH Key Generation

	In the scriptbox server generate ssh key and copy it to web01 and web02 respectively. Enter password of the remote server when prompted

		sudo -i
		ssh-keygen
		ssh-copy-id devops@remote-server-ip-address

3. Test key based login 

    	ssh devops@remote-server-ip-address

4. Login into web01 and web02 remotely

		sudo fab -l
		sudo fab -H remote-server-ip-address -u devops remote_exec

5. Go to tooplate.com to download a zip file

   - Open Brave and paste this URL and choose your sample website
     
       https://www.tooplate.com/
       https://www.tooplate.com/view/2137-barista-cafe

   - Press fn key + F12 to open the Network tab
   - Scroll all the way down and hit the Download button, save and note the directory name
   - In the Network tab, you should copy the zip URL

6. Go to the scriptbox and pass the URL copied and append the directory name above like so;

		fab -l
		sudo fab -H 192.168.56.3 -u devops web_setup:https://www.tooplate.com/zip-templates/2137_barista_cafe.zip,2137_barista_cafe

7. To install on the same website on multiple servers, you can input the target IPs separated by commas

    	sudo fab -H 192.168.56.3,192.168.56.4 -u devops web_setup:https://www.tooplate.com/zip-templates/2137_barista_cafe.zip,2137_barista_cafe

## Virtual Environment
 All these tasks were done installing everything in the system level, another way is to create a virtual environment for each project. This kind of creates a boundary to limit the system level changes

 1. Go to your terminal and run
    
    	sudo pip install virtualenv
 
 2. Create the environment and give it a named automation-env

    	sudo virtualenv automation-env

3. A directory will be created named virtualenv automation-env and it will have all python libraries, interpreter, etc.

		cd virtualenv automation-env
		ls

4. To activate it

    	source bin/activate

5. Now you can install apps within the virtual environment

    	pip install jenkins api

6. To deactivate
    
    	deactivate


# References

1. [Python Jenkins](https://python-jenkins.readthedocs.io/en/latest/examples.html#example-10-waiting-for-jenkins-to-be-ready)
2. [Python Boto](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)
3. [Python Basics Reference](https://visualpath.in/devopstutorials/devops)