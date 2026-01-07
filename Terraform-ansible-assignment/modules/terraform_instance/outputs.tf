# output "public_ips" {
#   value = {
#     for name, inst in aws_instance.Tomcat_instance :
#     name => inst.public_ip
#   }
# }


# output "public_ips" {
#   description = "Public IPs of all newly created Tomcat instances"
#   value       = [for instance in aws_instance.Tomcat_instance : instance.public_ip]
# }

# # output "private_ips" {
# #   description = "Private IPs of all newly created Tomcat instances"
# #   value       = [for instance in aws_instance.Tomcat_instance : instance.private_ip]
# # }

# output "instance_ids" {
#   description = "Instance IDs of all newly created Tomcat instances"
#   value       = [for instance in aws_instance.Tomcat_instance : instance.id]
# }


# All instance IPs (old + new)
output "all_instance_ips" {
  value = {
    for name, inst in aws_instance.Tomcat_instance :
    name => inst.public_ip
  }
}

# Only new instance IPs (based on previous_instance_count)
output "new_instance_ips" {
  value = {
    for name, inst in aws_instance.Tomcat_instance :
    name => inst.public_ip
    if tonumber(replace(name, "instance", "")) > var.previous_instance_count
  }
}
