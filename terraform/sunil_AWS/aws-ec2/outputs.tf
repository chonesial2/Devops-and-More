output "instance_id" {
  value = aws_instance.server1.id
}

output "instance_private_ip" {
  value = aws_instance.server1.private_ip
}

output "instance_public_ip" {
  value = aws_instance.server1.public_ip
}

