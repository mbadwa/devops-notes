#!/bin/bash

# Install latest Java JDK
sudo apt-get update

sudo apt-get install openjdk-21-jdk -y

# Download repo key
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Create repo file
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
sudo apt-get update

sudo apt-get install jenkins -y

sudo systemctl start jenkins

sudo systemctl enable jenkins