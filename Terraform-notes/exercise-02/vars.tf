variable REGION {
  default = "us-east-1"
}

variable ZONE1 {
  default = "us-east-1a"
}

variable AMIS {
  description = "ID of AMIs to use for the instance"
  type = map
  default = {
    us-east-1 = "ami-0ebfd941bbafe70c6"
    us-east-2 = "ami-037774efca2da0726"
  }
}

variable INSTANCE_TYPE {
  description = "The type of instance to start"
  type        = string
  default     = "t2.micro"
}