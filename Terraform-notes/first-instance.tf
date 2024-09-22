provider "aws" {
  region = "us-east-1"
  # access_key = ""
  # secret_key = ""
} 

resource "aws_instance" "terra_intro" {
  ami = "ami-0ebfd941bbafe70c6"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "dove-key"
  vpc_security_group_ids = ["sg-05240e7b1f709ac75"]
  tags = {
    Name = "Dove-instance"
  }
}