# Ansible

Ansible is simple and easy to use and doesn't need any server setups like other tools to run as agents. In Linux it uses SSH and in Windows it uses Windows winrm and API based methods as well. No databases or sophisticated configurations involved, it uses YAML,INI and Texts config files. No complex setup, it's just a Python Library, you can just use pip to install it. You write a playbook and run it against the target and give you back the report, no residuals left on the target nor the host machine. Ansible has API integration that can be used to talk to cloud  URL/Restful Calls, it can use Shell commands and scripts as well.

## Use Cases

1. Automation

    Ansible has so many use cases for example any system automation, ie. Windows automation, Linux automation, web services automation, database services automation, Start/stop services, etc.

2. Change Management

   Managing changes of production servers using playbooks as documentation

3. Provisioning
   
   You can provision servers from scratch/Cloud provisioning as well.

4. Orchestration
   
   Large scale automation framework, combining multiple automation tools and scripts together and execute them in an orderly fashion. You can combine Ansible with other tools like Jenkins, cloud services, etc.

### How Does Ansible Connect to remote computers/servers

1. From the control machine, it uses an API to connect to a Cloud 
2. To connect to a Windows server or remote host, it uses WINRM by enabling remote connection.
3. To connect to Linux it uses SSH
4. You can also manage network devices; switches, routers, etc, through Ansible.
5. Manage databases using its own Python Libraries, for example, MySQL would have its own particular one.

### Ansible Architecture

#### 1. Inventory File

You create an Inventory that will have target machine information for example, username, IP address, password etc.
 
#### 2. Playbooks

It will have information of the host and also the module/modules you would like to execute on the host. That gets recorded as a task that was fed from Inventory and Modules.

#### 3. Modules

There are already baked in modules of different tasks one can execute on a host. No need to reinvent the wheel.

#### 4. Ansible Config

The result is a script called Ansible config as a Python script/package that gets push to remote targets. If the target is the cloud the package would be executed locally but if it is a remote server/switch/database the package will be executed on the remote host. All of the execution will give a report.

Ansible is very simple but at the same time very powerful, it has a lot of features but only use them as the need arise. also make the code as simple as possible. It can replace almost every or any automation tool in DevOps or Ops work.

### Setup Ansible & Infra

**Steps**

1. EC2 Instance where Ansible is installed on it.
2. 3 EC2 instances running CentOS, two web servers and one DB server.
3. All setup on the web servers and the db server will be done by Ansible.
4. Later we will launch an Ubuntu web server EC2 Instance using Ansible as well.

**Infra Deployment**

1. Launch Ansible EC2 Control server and Set it up

   This EC2 was launched through [Terraform script](./Terraform%20EC2%20Nodes/Ansible%20Control%20Server/).
   
   Note: to clean /.ssh/known_hosts folder your host machine.

         cat  ~/.ssh/known_hosts
         cat  /dev/null > ~/.ssh/known_hosts

2. Remote into the Ansible control instance and install Ansible
   
         $ sudo apt update
         $ sudo apt install software-properties-common
         $ sudo add-apt-repository --yes --update ppa:ansible/ansible
         $ sudo apt install ansible

3. Launch 3 EC2 target instances 

   The EC2 target Instances were launched through [Terraform](./Terraform%20EC2%20Nodes/clients%20EC2%20Nodes/).

4. Create a repository in Ansible control node under ubuntu user and paste the [inventory](invintory.yaml) content and save.
   
         mkdir vprofile && cd vprofile
         mkdir inventory && cd inventory
         sudo vim inventory

5. Copy the content of the private key named "client-key" and paste it on the new pem file.
   
   Go to your local machine, locate it and create a new pem file 

         cat ~/Downloads/client-key.pem
         sudo vim clientkey.pem
         sudo chmod "400" clientkey.pem

6. Tweak Ansible config file to not ask ssh host verification. We need to update this file; /etc/ansible/ansible.cfg at the moment it doesn't contain much. We need cat the file and copy the "ansible-config init --disabled > ansible.cfg" command and run it within the ansible folder.
   
         sudo -i
         ls /etc/ansible/ansible.cfg
         mv /etc/ansible/ansible.cfg /etc/ansible/ansible.cfg-backup
         cd /etc/ansible
         ansible-config init --disabled -t all > ansible.cfg
         vim ansible.cfg
7. Search for the line; "host_key_checking=True" in the "ansible.cfg" and remove the semi-colon to remove the comment, "host_key_checking=True"

         vim ansible.cfg
         /host_key_checking=True
      
   Hit enter then i to remove the semi-colon and change the line to False

         host_key_checking=False
         esc
         :wq!
         exit
8. Enter into the inventory folder under ubuntu user and ssh into web01

         cd ~/vprofile/inventory
         ansible web01 -m ping -i inventory

   If successful, that's the message you'll see

         web01 | SUCCESS => {
            "ansible_facts": {
               "discovered_interpreter_python": "/usr/bin/python3"
            },
            "changed": false,
            "ping": "pong"
         }


   If you get permission denied error, chances are that the copying of the private key wasn't done correctly. There maybe a space within the key.
9. To create an inventory with multiple targets copy the inventory folder and add the info of the other two folders

         cd ../
         sudo cp -r inventory inventory_multi_user
         cd inventory_multi_user
         sudo vim inventory
         chmod "400" clientkey.pem
   
   Add web02 and db01 using this [yaml file](inventory-multi-targets.yaml)

10. SSH into web02 and db01
    
         ansible web02 -m ping -i inventory
         ansible db01 -m ping -i inventory

11. To handle hundreds of hosts you need to add them to grouping


         # SSH into a webservers group
         ansible webservers -m ping -i inventory
         ansible 'web*' -m ping -i inventory

         # SSH into a dbservers group
         ansible dbservers -m ping -i inventory
         ansible 'db*' -m ping -i inventory

         # SSH into all servers, there are several options
         ansible dc_virginia -m ping -i inventory
         ansible all -m ping -i inventory
         ansible '*' -m ping -i inventory

Note: When creating the yaml files, make sure you use space key not a tab key for the key:value pairs, otherwise you'll get an error.

### Adhoc Commands
Why use ad hoc commands?

ad hoc commands are great for tasks you repeat rarely. For example, if you want to power off all the machines in your lab for Christmas vacation, you could execute a quick one-liner in Ansible without writing a playbook. 

An ad hoc command looks like this:

      $ ansible [pattern] -m [module] -a "[module options]"

The ping module is an example of adhoc commands, this section will explore more commands

      sudo cp -r inventory_multi_user inventory_adhoc_cmd
      cd inventory_adhoc_cmd
      sudo vim inventory
      chmod "400" clientkey.pem


Install Apache server on Web01 and Web02

      ansible web01 -m ansible.builtin.yum -a "name=httpd state=present" -i inventory --become

      ansible webservers -m ansible.builtin.yum -a "name=httpd state=present" -i inventory --become

Uninstall Apache server on Web01 and Web02 if present

      ansible web01 -m ansible.builtin.yum -a "name=httpd state=absent" -i inventory --become

      ansible webservers -m ansible.builtin.yum -a "name=httpd state=absent" -i inventory --become

Start and enable httpd service

      ansible webservers -m ansible.builtin.service -a "name=httpd state=started enabled=yes" -i inventory --become

Create copy a file to webservers

      # Create a file locally, enter any text and save
      vim index.html

      ansible webservers -m ansible.builtin.copy -a "src=index.html dest=/var/www/html/index.html" -i inventory --become

### Ansible Playbook & Modules

Ansible Playbooks are lists of tasks that automatically execute for your specified inventory or groups of hosts. One or more Ansible tasks can be combined to make a play—an ordered grouping of tasks mapped to specific hosts—and tasks are executed in the order in which they are written.

Create a playbook named "web-db.yaml" copy from [here](/General-notes/Ansible/web-db.yaml). The folder will now have 3 files; inventory file, the playbook file and the ssh key file.

      sudo cp -r inventory_adhoc_cmd inventory_playbook
      cd inventory_playbook
      sudo vim  web-db.yaml
      chmod "400" clientkey.pem 

Note: In any folder you have secrets or ssh keys, you need to use gitignore so that you avoid publishing it in GitHub for example.

Before continuing we need to remove httpd services installed in webservers

      ansible webservers -m yum -a "name=httpd state=absent" -i inventory --become

Run the playbook

      # normal execution

      ansible-playbook -i inventory name-of-playbook
      ansible-playbook -i inventory web-db.yaml

      # verbose execution
      
      ansible-playbook -i inventory web-db.yaml -v
      ansible-playbook -i inventory web-db.yaml -vv
      ansible-playbook -i inventory web-db.yaml -vvv
      ansible-playbook -i inventory web-db.yaml -vvvv
       
To check syntax of a playbook, if it finds an error it'll spit a message, otherwise it'll just display the name of the playbook

      ansible-playbook -i inventory web-db.yaml --syntax-check

Dry run 

      ansible-playbook -i inventory web-db.yaml -C

Note: Once the playbook is created, you run a syntax check, the dry run and then execute it. On another note, you don't need to reinvent the wheel you can search for modules, scroll down to an example copy and edit it accordingly. For example; here is the [yum module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/yum_repository_module.html#ansible-collections-ansible-builtin-yum-repository-module).


## YAML & JSON Refresher
A Python dictionary is like JSON in another format and a stripped dictionary in YAML.

Dictionary example with three key:value pairs a bit complex to read

      {"DevOps": ["AWS", "Jenkins", "Python", "Ansible], "Development": ["Java", "NodeJS", ".NET"], "ansible_facts": {"python": "/usr/bin/python"}}

Making it more readable is turning it into vertical outlook, and tah daa! You have JSON

      {
         "DevOps": 
         [
            "AWS", 
            "Jenkins", 
            "Python", 
            "Ansible
         ], 
         "Development": 
         [
            "Java", 
            "NodeJS", 
            ".NET"
         ], 
         "ansible_facts": 
         {
            "python": "/usr/bin/python"
         }
      }

Converting a JSON into YAML by removing curly brackets and square brackets


         DevOps: 
         - AWS 
         - Jenkins
         - Python 
         - Ansible
  
         Development: 
         - Java
         - NodeJS 
         - .NET
         
         ansible_facts: 
           python: /usr/bin/python
           version: 3.10

Note: Ansible format is YAML but the results are returned in JSON.

# References
1. [Ansible main Documentation](https://docs.ansible.com/ansible/latest/)
2. [Ansible Ubuntu section](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu)
3. [Ansible YAML syntax](https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html)
4. [Adhoc commands](https://docs.ansible.com/ansible/latest/command_guide/intro_adhoc.html)
5. [Ansible Playbook Syntax](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_intro.html#playbook-syntax)
6. [Ansible Modules](https://docs.ansible.com/ansible/latest/collections/index_module.html)