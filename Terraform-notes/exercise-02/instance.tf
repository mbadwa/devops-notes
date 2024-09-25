resource "aws_instance" "dove-instance" {
  ami = var.AMIS[var.REGION]
  instance_type = var.INSTANCE_TYPE
  availability_zone = var.ZONE1
  key_name = "dove-key"
  vpc_security_group_ids = ["sg-05240e7b1f709ac75"]
  tags = {
    Name = "Dove-instance"
    Project = "Dove"
  }
}