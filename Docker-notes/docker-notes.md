# Docker

In a normal infrastructure setup we have VM instances to run different services, for example a Tomcat server, Nginx Server, DB Server for isolation purposes. This is due to the fact that binaries of each service should not get bungled up when running on one physical server. This facilitates smooth running and management of the individual services. This necessary for HA, Security and performance, etc.

### Services Isolation

1. To host our apps we need infrastructure
2. We use VMs/Cloud Computing Infrastructure
3. We isolate our services in OS of VM
4. Because of isolation we end up setting multiple VMs/Instances
5. VMs/Instances will be over provisioned

### Challenges

1. VMS are expensive to have each VM with its OS
2. OS needs nurturing 
3. OS needs licensing
4. OS takes time to boot, for example in auto scaling the OS has to boot up and then the service starts.
5. VMs are portable but Bulky.
6. Isolating services is important but need OS
7. High availability is achieved by multiple instances/VMs
8. Portability matters or Ease of deployment
9. Raises CapEx and OpEx

### Solution 

Running on one OS but the services are isolated, allocated RAM, CPU, Storage quotas. Every process running its own binaries but they are self contained not affecting the other services nor using more resources than other services.

### Containers

Processes running in a Directory, the processes will be running in the same OS but they will be isolated.

- A process[isolated]
- A Directory[Namespace, cgroup]
- Necessary bin/lib in the Directory
- A directory with IP address to connect to other services

### Container

- Containers share the machine's OS system kernel and therefore don't require an OS per application.
- A container is a standard unit of software that packages up
  - Code
  - Dependencies

### Container vs VM

- Containers offers isolation not Virtualization
- For understanding, containers are OS virtualization but not technically correct
- VMs are Hardware virtualization, virtual RAM, CPU, Disks, IO, etc

### Docker

Docker manages your containers by providing a run time environment using Docker engine.

![Docker Engine](/Docker-notes/Docker%20Engine.png)

Docker Engine is a daemon service running in the OS, you connect to it through REST API or through the docker CLI. The main staple of Docker is images, you don't need to create containers from scratch. You can download images, customize etc. You can connect data volumes to save or preserve your data, you create your own networks for the the containers. 

### Docker Containers

Docker containers that run in Docker Engine:

- **Standard**: Docker created the industry standard for containers, so they could be portable anywhere. For example the same container can be in test environment, dev environment and production environment.
    
- **Lightweight**: Containers share the machines's OS system kernel and therefore don't require an OS per application, driving higher server efficiencies and reducing server and licensing costs.

- **Secure**: Applications are safer in containers and Docker provides the strongest default isolation capabilities in the industry

### Docker Installation

- Linux or Windows
- Windows Containers runs on Windows OS
- Linux Containers runs on Linux OS

### Installation Steps

1. Install a VM in AWS or a [Vagrant VM](/Docker-notes/Vagrantfile)
2. Install [Docker Engine](https://docs.docker.com/engine/install/ubuntu/)
3. Add a user to docker group, log out and log back in.
     
        sudo usermod -aG docker vagrant
        id vagrant
4. Test Docker Engine
   
        sudo docker run hello-world
        docker images
        docker ps
        docker ps -a
### Docker Commands & Concepts

Docker images are fetched from [docker hub](https://hub.docker.com/) registry. 

- Docker image is a stopped container which is archived just like a vm image
- Docker image consists of multiple layers. Each layer will be some data. For example when installing a package; *apt install git* will create a layer, after that you create a directory that creates another layer, etc. All layers are in read only mode.
- An app will be bundled in an Image
- Containers runs from the images, they are connected to them. You can't remove an image if a container is running. Unlike vms, when you create a VM from a CentOS image, the VM will be a clone of the image, completely separate from the image.
- Images are called Repositories in Registries e.g. Tomcat would be a repo in Docker registry.

In summary, docker images becomes containers when they run on Docker Engine

### Docker Registries

There are several other Docker images registries other than Docker registry.
- Registries Stores Docker images
- Dockerhub is default registry
- Cloud based Registries
  - Dockerhub
  - GCR (Google Container Registry)
  - Amazon ECR
- Inhouse or Local Registries
  - Nexus 3+
  - Jfrog Artifactory
  - DTR (Docker trusted Registry)
  
### Containers Runs from Images

For example you can spin up several containers from ubuntu:18.04 Image. Each container will have a Thin R/W layer all the data you see will be from the image. All image layers are readonly. For example there could be a directory named */opt/data*, that's a layer. Container referring to that path and you access the data of the directory, you are actually accessing image data. Containers don't replicate the entire image content, that's how it saves a lot of space, it uses some UFS file system, there is a lot of technicalities in the process. In summation, container is just a thin R/W layer. All the data seen is from the image.

### Docker Commands

- To create a new container

      docker run image-name

- To list commands locally

      docker images

- To list running containers

      docker ps

- To list all the containers

      docker ps -a

- To execute commands on containers 

      docker exec

- To start/stop/restart

      docker start
      docker stop
      docker restart
      docker rm
- To remove images

      docker rmi
- To see details of container and image
  
      docker inspect
For more exhaustive command reference check [here](https://docs.docker.com/reference/).

### Deploying a Docker Container in Docker Engine

1. Go to [docker hub](https://hub.docker.com/~~~~) registry and download Nginx repository.
2. Read the documentation, copy the command then run 
      
       docker pull nginx
3. List images

       docker images

       REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
       nginx         latest    5ef79149e0ec   4 days ago      188MB
       hello-world   latest    d2c94e258dcb   15 months ago   13.3kB
      **Note**: Image is called a repository, above we have two repositories, nginx and hello-word, then each image will have a tag for versioning i.e. latest, latest can be just a name of a tag but for official images it represents the latest version of the image/repository. Created/Size are self explanatory.
4. To run the container, you can put *--name* to name your container *-d* option to make it run in the foreground/detached mode. It doesn't capture the shell and it'll continuously run
   
       docker run --name myweb -p 7090:80 -d nginx

      Note: *-p* flag represents a port mapping/port forwarding to expose external port. Host Port:Container Port (1790:80). A request from outside will be routed to port 80 on the container.  

5. Check the running containers

       docker ps

       CONTAINER ID   IMAGE     COMMAND                  CREATED              STATUS              PORTS                        NAMES
       187779d11ef4   nginx     "/docker-entrypoint.…"   About a minute ago   Up About a minute   0.0.0.0:7090->80/tcp, :::7090->80/tcp   myweb

      **Note**: The command shown is a script that runs nginx process. The container can be reached from anywhere from port 7090 that forwards the requests to port 80.

6. Verify if the nginx is running
   
       # Go to your host and check for your network IP range
       ip add show

       # My home LAN
       192.168.100.x

       # In the Vagrant box look for same network IP range
       ip add show

       # It should be the same network shared through Bridged network
       192.168.100.x

       # Access container from the web browser
       http://192.168.100.65:7090/

7. To stop the container

       # You can use CONTAINER ID/NAMES
       docker ps
       docker stop myweb
       docker ps
       docker ps -a
8. To start the container again

       docker start myweb
       docker ps
9. A container is just a service running in the host machine

       # On your host machine run
       ps -ef

       # You'll see your container running a service similar to this
       root        2322    2298  0 16:03 ?        00:00:00 nginx: master process nginx -g daemon off;

       # Switch to root user
       sudo -i
       cd /var/lib/docker
       ls
       
       # You'll see list of containers
       cd containers/
       ls

       # You'll see the ls result matching the docker ps container ID 
       docker ps
       6cd27a03f239

       # The long series of the alpha numeric is a container directory
       cd 6cd27a03f239b4f26f2d28845be6930ce43bee82bf9d8f25bdf88579fd7ff6f3
       ls

10. Container runs from an image and doesn't keep any data
    
        # To check the size
        du -sh 6cd27a03f239b4f26f2d28845be6930ce43bee82bf9d8f25bdf88579fd7ff6f3
        
        # You'll notice that the size is just tiny
        44K	6cd27a03f239b4f26f2d28845be6930ce43bee82bf9d8f25bdf88579fd7ff6f3

11. Check container data

        du -sh image
        cd ../ && cd image
        ls
12.  Running commands without attaching

         docker exec myweb ls /

14. Attaching to the container, run the /bin/bash interactively using tty

        docker exec -it myweb /bin/bash
        ls
        exit

15. Removing image

        # You can't remove an image whose container is deployed
        docker images
        docker rmi nginx

        # Error
        Error response from daemon: conflict: unable to remove repository reference "myweb" (must force) - container 8ba33586ade1 is using its referenced image d2c94e258dcb

        # Remove a container
        docker ps -a
        docker rm myweb
        
        #Error
        Error response from daemon: cannot remove container "/myweb": container is running: stop the container before removing or force remove

        docker stop myweb
        docker rm myweb
        docker rmi nginx

### Docker Container Logs

How to fetch docker container logs and understand them.

1. Download nginx image

       docker pull nginx

2. To see detailed info/metadata of an image 

       docker images
       docker inspect nginx

       # Entrypoint fetches the script and CMD runs the commands
       "Cmd": [
                "nginx",
                "-g",
                "daemon off;"
            ],
            "ArgsEscaped": true,
            "Image": "",
            "Volumes": null,
            "WorkingDir": "",
            "Entrypoint": [
                "/docker-entrypoint.sh"
             ]

3. Run the container in detached mode and auto port mapping

       docker run -d -P nginx
       docker ps 

4. To see output of *docker run* command

       # docker logs CONTAINER ID/NAME
       docker logs blissful_brahmagupta


5. When you run without *-d* flag, the container will run in foreground and takeover the shell and when you exit the shell you kill the service.

       docker run -P nginx
       ctrl + c
       docker ps -a     

6. Docker logs is for troubleshooting

       docker run -d -P mysql:5.7
       docker ps
       docker ps -a
       docker logs container-name/CONTAINER ID

       # Log command Output

        2024-08-20 11:37:19+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 5.7.44-1.el7 started.
        2024-08-20 11:37:19+00:00 [Note] [Entrypoint]: Switching to dedicated user 'mysql'
        2024-08-20 11:37:19+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 5.7.44-1.el7 started.
        2024-08-20 11:37:19+00:00 [ERROR] [Entrypoint]: Database is uninitialized and password option is not specified
            You need to specify one of the following as an environment variable:
            - MYSQL_ROOT_PASSWORD
            - MYSQL_ALLOW_EMPTY_PASSWORD
            - MYSQL_RANDOM_ROOT_PASSWORD
    Note: In this case running *docker-ps* returns nothing and running *docker ps -a* returns exited container. At this point we don't know what went wrong. To find this out we need to check the container logs by running *docker logs container-name/ID*. This returns the logs above showing the error message contained therein. When we build our own custom containers we may make mistakes, for us to troubleshoot we need to deep dive into the logs and ransack everything to find the causation of the error.

7. Exporting an environmental variable for MySQL container 

       docker run -d -P -e MYSQL_ROOT_PASSWORD=your-pass-here mysql:5.7
       docker ps

      Note: After export the password variable it ran with no qualms. This was only possible through gleaning the logs.

8. Clean up

       docker ps
       docker stop container name/ID
       docker ps
       docker ps -a
       docker images 
       docker rmi REPOSITORY/IMAGE ID

### Docker Volumes

Containers are deposable in nature, normally all changes are done to the image not by going into the container itself. We delete them and create a new container from an updated image. For that reason they are volatile by nature. For example in Kubernetes the rolling upgrade will remove a container and create a new one. If it persisted data for some reason that data will be lost. As for stateful containers like MySQL DB container, it will have data. This challenge is sorted by using container volumes.

#### Container Data

- The data in the container doesn't persist when the container no longer exists. It can be difficult to get the data out if another process needs that particular data as well.
- Container's writable layer is tightly coupled to the host machine where the container is running. You can't easily move the data somewhere else.

Docker presents us with two options to store files in the host machine.

- Volumes
  
  - It's a wrapper where in the docker volumes directory it'll create a directory where you can attach it to your container. All data from the container will be stored in the volumes on your host machine. Volumes by Docker (/var/lib/docker/volumes/) on Linux.
  
  - This is ideal for data preservation or data persistence purposes.

- Bind Mounts
  
  - This is same as Vagrant sync directory where you can map any directory of your host machine and map it to a container directory. If you want to make changes to a synced container directory, they are done in the host machine directory.
  
  - Bind Mount is mostly used for  injecting data into the container, for example, the code developers are writing. They can do code changes in the host machine while the the container is running and the changes will be reflected in the container.

#### Creating a Bind Mount

1. Download [MySQL image](https://hub.docker.com/_/mysql)

       docker pull mysql:5.7
       docker images

2. Check volume directory to be mapped and the port number the process runs

       # docker inspect image-name
       docker inspect mysql:5.7

      Note: From the inspect command, you'll glean information like; *ID, Created, Container, Hostname, ExposedPorts, Env, Cmd, Image, Volumes, etc*. In this case the service runs on two ports namely; 3306/tcp and 33060/tcp and the volume path is /var/lib/mysql. When there is Entrypoint and Cmd entries in the metadata, the Entrypoint takes precedence. The Entrypoint script will run first then the Cmd commands follows, the command in Cmd is an argument that the script pass.

3. Create a directory in the host machine

        # mkdir db-name
        mkdir vprodbdata
        pwd

5. Now we can run the Create a directory in the host machine

        # mkdir db-name
        mkdir vprodbdata
        pwd

       docker run --name db-name -d -e MYSQL_ROOT_PASSWORD=your-pass-here -p host-port:3306 -v /home/vagrant/vprodbdata:/var/lib/mysql mysql:5.7 
       
       docker ps

       ls vprodbdata

6. You can verify from the container as well
   
       docker exec -it vprodb /bin/bash
       cd /var/lib/mysql
       ls
       exit

      You'll notice the data is exactly identical
7. Stop and delete the container to test

       docker stop vprodb
       docker rm vprodb
       ls vprodbdata

#### Creating a volume

1. Run Docker volume command to see the options

       docker volume

2. Create a volume

       # docker volume create volume-name
       docker volume create mydbdata
       docker volume ls

4. Docker container creation with a volume attached

       # docker run --name db-name -d -e MYSQL_ROOT_PASSWORD=password -p 3030:3306 -v volume-name:/var/lib/mysql mysql:5.7
        
        docker run --name mynewdb -d -e MYSQL_ROOT_PASSWORD=password -p 3030:3306 -v mydbdata:/var/lib/mysql mysql:5.7

        docker ps

        # Check the volumes directory for the data on the host
        sudo ls /var/lib/docker/volumes
        sudo ls /var/lib/docker/volumes/mydbdata/_data

5. Docker inspect command on a container

        docker inspect mynewdb
        docker logs mynewdb
      
      The command will give metadata info for the container as opposed to image info when it is run against the image. 

6. Install MySQL agent

       sudo apt-get install mysql-client -y

7. Fetch the IP and Run MySQL command to log into the container

       docket inspect mynewdb
       mysql -h 172.17.0.2 -u root -ppassword 
 
8. Run a few db commands

       show databases;
       exit;

9. Clean up

       docker ps -a
       docker stop mynewdb
       docker rm mynewdb
       docker rmi image-id

### Building Images

This is how you build customized images according to specific requirements. Dockerfile contains information to build Images, the Dockerfile contains instructions of the image to be built, information such as how to build the image, what it should contain, what packages to install, what volume to export. After that we then run a build command to create an image from the file. The images is just like Amazon AMI as an example.

#### Contents of Dockerfile

   ##### Dockerfile Instructions

   - Some set of commands and their respective explanations
        
        - FROM => Base Image specification
        - LABELS => Adds metadata to an image, e.g. Project name, author name, etc.
        - RUN => execute commands in a new layer and commit the results. This instruction make changes to the image being created, for example, installing a package, creating a directory or creating a file. Whatever commands needed to execute are done through RUN instructions.
        - ADD/COPY => Adds files and folders into image while your are building it. A configuration file or an archive, etc. COPY just copy file and dump it while ADD instruction you can provide a link in archive, it download from a link and put it in your image, it can even unarchive an archive file.
        - CMD => Runs binaries/commands on docker run. Basically what will be run when *Docker run* is executed.
        - ENTRYPOINT => Allows you to configure a container that will run as an executable. Similar to CMD but has higher priority between the two. You use ENTRYPOINT and feed CMD as its argument.
        - VOLUMES => Creates a mount point and marks it as holding externally mounted volumes.
        - EXPOSE => Container listens on the specified network ports at runtime
        - ENV => Set the environment variable, e.g. like the MySQL root password
        - USER => Sets the user name (or UID)
        - WORKDIR => Sets the working directory, for example if you run an exec command, it'll run from the specified work directory.
        - ARG = > Defines a variable that users can pass at build-time
        - ONBUILD => Adds to the image a trigger instruction to be executed at a later time. This is used when you are going to use your image as a base image for another image.

      For more info, refer to [Build Reference](https://docs.docker.com/reference/dockerfile/)

### Containerize a Docker application

1. Create a folder named images and create a directory inside it
      
       mkdir images && cd images
       mkdir crispy-kitchen

2. Copy a web template from [tooplate](https://www.tooplate.com/)


      Open any template, hit fn + F12 > Network then hit Download button but don't save it. Select the .zip file to copy its URL

       https://www.tooplate.com/zip-templates/2129_crispy_kitchen.zip


3. Download the zip URL into the images folder

       wget https://www.tooplate.com/zip-templates/2129_crispy_kitchen.zip
4. Unzip the crispy_kitchen file

       sudo apt install unzip zip -y
       unzip 2129_crispy_kitchen.zip
      
5. Create a tarball archive file

       cd 2129_crispy_kitchen
       ls
       tar czvf crispy.tar.gz *
       mv crispy.tar.gz ../ && cd ../
       rm -rf 2129_crispy_kitchen 2129_crispy_kitchen.zip 
       mv crispy.tar.gz crispy-kitchen
       cd crispy-kitchen/

6. [Dockerfile](/Docker-notes/Dockerfile) creation
       
       vim Dockerfile
       docker build -t crispyimg .

7. Build a container from the image
   
       docker images

       # docker run -d --name container-name -p host_port:container_port image_name:tag
       docker run -d --name crispywebsite -p 9080:80 crispyimg:v1
8. Testing the website

       # Enter the host-IP-address:9080 and paste in a browser
       192.168.100.65:9080

9. Exec into the container to get the path to logs

       docker exec -it crispywebsite /bin/bash
       ls /var/log/apache2/
       exit

       docker run --name db-name -d -e MYSQL_ROOT_PASSWORD=your-pass-here -p host-port:3306 -v /home/vagrant/vprodbdata:/var/lib/mysql mysql:5.7 
       
10. Create a Bind Mount

        docker images

        docker run --name crispysite -d -p 8290:80 -v /home/vagrant/images/crispy-kitchen/crispylogs:/var/log/apache2/ crispyimg


11. Check to see the logs 

        docker ps

        ls crispylogs

12. Ship the image to docker hub

    - log into [dockerhub](https://app.docker.com/) and fetch your username
    - Build the image
    
            docker images
            docker build -t mbadwa/crispyimg:V2 .


    - Push the image
    
            docker login 
            docker push mbadwa/crispyimg:V2

13. Remove the local image

        docker ps -a
        docker stop crispy-kitchen
        docker rm  crispy-kitchen
        docker rmi crispyimg mbadwa/crispyimg:V2

14. Pull the image from Dockerhub

        docker run --name crispy-kitchen -d -p 8090:80 -v /home/vagrant/images/crispy-kitchen/crispylogs:/var/log/apache2/ mbadwa/crispyimg:V2

### Docker Compose

Docker Compose is a declarative YAML file that allows running multiple containers together and they can be easily managed centrally as well. We can liken Docker Compose to Vagrantfile where we can declare several servers and run them with vagrant up. Vagrant is for VMs, where as Docker Compose is for VMs.

#### Docker Compose Hands On

1. Install [Docker Compose](https://docs.docker.com/compose/install/linux/)

2. Docker Compose [Quick Start](https://docs.docker.com/compose/gettingstarted/)
3. Create a project directory


       mkdir composetest && cd composetest

4. Create a file called **app.py** and paste this [code](/Docker-notes/composetest/app.py)

       sudo vim app.py 

5. Create another file called **requirements.txt** in your project directory and paste the following [code]((/Docker-notes/composetest/requirements.txt)) in:

       sudo vim requirements.txt

6. Create a **Dockerfile** and paste this [code](/Docker-notes/composetest/Dockerfile) in
7. Create a file called **compose.yaml** in your project directory and paste this [code](/Docker-notes/composetest/compose-start.yaml)

8. From your project directory, start up your application by running 
   
       docker compose up

9. Enter the address in a browser to see the application running.

       http://localhost:8000/
10. Stop the container
       
        ctrl + C

11. Remove the container

        docker compose down

12. Edit the **compose.yaml** file in your project directory to use [watch](/Docker-notes/composetest/compose-watch.yaml) so you can preview your running Compose services which are automatically updated as you edit and save your code
      
13. Rebuild the app and run with compose

        # To watch the changes being synced in action
        docker compose watch 
        
        or 
        
        docker compose up --watch

        # To run the container to the foreground 
        docker compose up -d

14. Change the greeting in **app.py** and save it. For example, change the *Hello!* message to *Hello World from Docker!*  See the magic happen.

        return f'Hello! I have been seen {count} times.'

15. Remove the container

        ctrl + C
        docker compose down

16. Splitting Services

        sudo vim infra.yaml

17. Cut the Redis service from your [compose.yaml](/Docker-notes/composetest/compose-without-split.yaml) file and paste it into your new **infra.yaml** file. Make sure you add the services top-level attribute at the top of your file. Your **infra.yaml** file should now look like [this](/Docker-notes/composetest/infra.yaml):

        services:
          redis:
            image: "redis:alpine"

18. In your compose.yaml file, add the [include](/Docker-notes/composetest/add-include.yaml) top-level attribute along with the path to the infra.yaml file.
19. Run the containers in detached mode
 
        docker compose up -d
        
20. Other commands
    
        docker compose ps
        docker compose top
22. Clean up
    
        docker compose stop
        docker compose down
        docker compose ps
        docker compose ps -a
        docker images
        docker rmi image-id 

### Multistage Dockerfile

We will understand what it is why it is required

1. Clone Docker branch

       git clone -b docker https://github.com/devopshydclub/vprofile-project.git

       cd vprofile-project/Docker-files/app/

2. Change directory to multistage folder

       cd multistage 
       sudo vim Dockerfile

      Note: The BUILD_IMAGE is being built from openjdk:11 container from Dockerhub, then the RUN command to install the dependencies, the second RUN command to copy the source code from GitHub, a third RUN command to checkout to docker branch and build the artifact named vprofile-v2.war. The image is ready, then the second image is from tomcat:9-jre11 docker hub. It has RUN to remove the default artifact of ROOT.war, the COPY command copies the artifact from BUILD_IMAGE into the tomcat image. EXPOSE the port, and lastly CMD to execute the shell command and with the run argument.
3. Build the image

       docker build -t appimg:v1 .

      Note: The dot at the end is indicating the current directory

# References

1. [VirtualBox Installation](https://www.techrepublic.com/article/install-virtualbox-ubuntu/)
2. [Docker Engine Installation](https://docs.docker.com/engine/install/ubuntu/)
3. [Docker hub](https://hub.docker.com/)
4. [Docker Reference](https://docs.docker.com/reference/)

 