# Public (bastion) instance public IPs
output "public_instance_public_ips" {
  description = "Public IP addresses of the bastion/public instances"
  value       = aws_instance.public_instances[*].public_ip
}

# Private IPs of public (bastion) instances
output "public_instance_private_ips" {
  description = "Private IP addresses of the bastion/public instances"
  value       = aws_instance.public_instances[*].private_ip
}

# Private instance private IPs
output "private_instance_private_ips" {
  description = "Private IP addresses of the private instances"
  value       = aws_instance.private_instances[*].private_ip
}

# All public subnet IDs
output "public_subnet_ids" {
  description = "IDs of all public subnets"
  value       = aws_subnet.public[*].id
}

# All private subnet IDs
output "private_subnet_ids" {
  description = "IDs of all private subnets"
  value       = aws_subnet.private[*].id
}

# output "bastion_public_ip" {
#   value = aws_instance.bastion.public_ip
# }
