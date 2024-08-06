output "instance_ids" {
  value = aws_instance.web0.*.id
}

output "instance_public_ips" {
  value = aws_instance.web0.*.public_ip
}