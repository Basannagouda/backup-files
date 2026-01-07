variable "aws_region" {}
variable "vpc_cidr" {}
variable "subnet_cidrs" {
  type = list(string)
}
variable "availability_zones" {
  type = list(string)
}
variable "ami_value" {
    type = string
}
variable "instance_type" {
    type = string
}
# variable "instance_count" {
#   type = number
# }
variable "allow_ssh_cidr" {
  default = "0.0.0.0/0"
}
variable "key_name" {}
variable "public_key_path" {}
variable "private_key_path" {}

variable "env" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}
variable "prevent_key_destroy" {
  description = "Prevent the key from being destroyed"
  type        = bool
  default     = true
  
}

#---------------------------------------------------------------
variable "previous_instance_count" {
  description = "Number of instances already deployed"
  type        = number
  default     = 0
}

variable "new_instance_count" {
  description = "Number of new instances to deploy"
  type        = number
  default     = 0
}

#===================================================================
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "gateway_name" {
  description = "Name of the Internet Gateway"
  type        = string
}

variable "subnet_names" {
  description = "List of names for public subnets"
  type        = list(string)
}

variable "route_table_name" {
  description = "Name of the route table"
  type        = string
}

variable "sg_name" {
  description = "Name of the Security Group"
  type        = string
}
