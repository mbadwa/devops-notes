#!/bin/bash

# Jenkins Server install with two JDK versions as dependencies

sudo apt update

sudo apt install openjdk-11-jdk  -y

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
	https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
	https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
	/etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update

sudo apt install jenkins -y

sudo systemctl start jenkins

sudo systemctl enable jenkins

sleep 5

sudo apt install openjdk-8-jdk  -y
sudo apt install maven -y

