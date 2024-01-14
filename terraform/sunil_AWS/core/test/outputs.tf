output "eip-nat" {
  value       = aws_eip.nat.public_ip
  description = "The public IP address of the NAT server."
}

// VPC
output "vpc-main-id" {
  value       = aws_vpc.main.id
  description = "The VPC ID"
}

output "vpc-main-cidr" {
  value       = aws_vpc.main.cidr_block
  description = "The VPC CIDR"
}

// Subnets
output "subnet-id-private-01" {
  value       = aws_subnet.private-01.id
  description = "The Subnet ID"
}

output "subnet-id-private-02" {
  value       = aws_subnet.private-02.id
  description = "The Subnet ID"
}

output "subnet-id-private-03" {
  value       = aws_subnet.private-03.id
  description = "The Subnet ID"
}


output "subnet-id-public-01" {
  value       = aws_subnet.public-01.id
  description = "The Subnet ID"
}

output "subnet-id-public-02" {
  value       = aws_subnet.public-02.id
  description = "The Subnet ID"
}

output "subnet-id-public-03" {
  value       = aws_subnet.public-03.id
  description = "The Subnet ID"
}

// Security Groups
output "sg-allow-public-web-id" {
  value       = aws_security_group.allow-public-web.id
  description = "The SG ID"
}

output "sg-limit-web-id" {
  value       = aws_security_group.limit-web.id
  description = "The SG ID"
}

output "sg-limit-ssh-id" {
  value       = aws_security_group.limit-ssh.id
  description = "The SG ID"
}

output "sg-testing-mode-id" {
  value       = aws_security_group.testing-mode.id
  description = "The SG ID"
}

# output "dns-uat-zoneid" {
#   value       = aws_route53_zone.app.zone_id
#   description = "route 53 id"
# }
