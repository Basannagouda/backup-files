# Public instance public IPs
output "public_instance_public_ips" {
  value = module.web.public_instance_public_ips
}

# Public instance private IPs
output "public_instance_private_ips" {
  value = module.web.public_instance_private_ips
}

# Private instance private IPs
output "private_instance_private_ips" {
  value = module.web.private_instance_private_ips
}

# Public subnet IDs
output "public_subnet_ids" {
  value = module.web.public_subnet_ids
}

# Private subnet IDs
output "private_subnet_ids" {
  value = module.web.private_subnet_ids
}

# output "bastion_public_ip" {
#   value = aws_instance.bastion.public_ip
# }
