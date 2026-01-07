# output "instance_ips" {
#   value = module.web.public_ips
# }
# output "instance_ips" {
#   value = module.web.public_ips
# }

# # output "private_ips" {
# #   value = module.web.private_ips
# # }

# output "instance_ids" {
#   value = module.web.instance_ids
# }

# Reference module outputs

output "all_instance_ips" {
  value = module.web.all_instance_ips
}

output "new_instance_ips" {
  value = module.web.new_instance_ips
}
