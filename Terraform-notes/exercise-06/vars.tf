variable "REGION" {
  default = "us-east-1"
}

variable "ZONE1" {
  default = "us-east-1a"
}

variable "ZONE2" {
  default = "us-east-1b"
}

variable "ZONE3" {
  default = "us-east-1c"
}

variable "AMIS" {
  type = map(any)
  default = {
    us-east-1 = "ami-0ebfd941bbafe70c6"
    us-east-2 = "ami-037774efca2da0726"
  }
}

variable "INSTANCE_TYPE" {
  description = "The type of instance to start"
  type        = string
  default     = "t2.micro"
}

variable "USER" {
  default = "ec2-user"
}

variable "PUB_KEY" {
  default = "terrakey.pub"
}

variable "PRIV_KEY" {
  default = "terrakey" 
}

variable "MYIP" {
  default = "181.114.76.191/32"
}