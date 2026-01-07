variable "aws_region" {}
variable "vpc_cidr" {}
variable "subnet_cidrs" {
  type = list(string)
}
variable "availability_zones" {
  type = list(string)
}
variable "ami_value" {}
variable "instance_type" {}
# variable "instance_count" {
#   type = number
# }
variable "allow_ssh_cidr" {
  default = "0.0.0.0/0"
}
variable "env" {
  description = "Environment name like dev or prod"
  type        = string
}

variable "key_name" {
  description = "AWS Key Pair name"
  type        = string
}

variable "public_key_path" {
  description = "Path to the public key file"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private key file"
  type        = string
}

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


