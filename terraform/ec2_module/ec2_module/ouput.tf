output "instance_id" {
value = aws_instance.instancename.public_ip
}

output "instance_private_ip" {
value = aws_instance.instancename.public_ip
}

output "instance_public_ip" {
  value = aws_instance.instancename.public_ip
}
