resource "aws_key_pair" "terra-key" {
  key_name   = "terrakey"
  public_key = file("terrakey.pub")
}

resource "aws_instance" "crispy-kitchen" {
  ami                    = var.AMIS[var.REGION]
  instance_type          = var.INSTANCE_TYPE
  availability_zone      = var.ZONE1
  subnet_id = aws_subnet.dove-pub-1.id
  key_name               = aws_key_pair.terra-key.key_name
  vpc_security_group_ids = [aws_security_group.dove_stack_sg.id]
  tags = {
    Name    = "Dove-Instance"
    Project = "Dove"
  }

  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }

  provisioner "remote-exec" {

    inline = [
      "chmod +x /tmp/web.sh",
      "sudo /tmp/web.sh"
    ]
  }

  connection {
    user        = var.USER
    private_key = file("terrakey")
    host        = self.public_ip
  }
}

resource "aws_ebs_volume" "vol-4-dove" {
  availability_zone = var.ZONE1
  size = 3
  tags = {
    Name = "extr-vol-4-dove"
  }
}

resource "aws_volume_attachment" "atch_vol_dove" {
  device_name = "/dev/xvdh"
  volume_id = aws_ebs_volume.vol-4-dove.id
  instance_id = aws_instance.crispy-kitchen.id
}

output "PublicIP" {
  value = aws_instance.crispy-kitchen.public_ip
}

output "PrivateIP" {
  value = aws_instance.crispy-kitchen.public_ip
}
