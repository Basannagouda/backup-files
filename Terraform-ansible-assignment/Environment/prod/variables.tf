variable "aws_region" {}
variable "vpc_cidr" {}

variable "subnet_cidrs" {
  type        = list(string)
  description = "List of public subnet CIDRs"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of AZs for subnets"
}

variable "ami_value" {}
variable "instance_type" {}
variable "instance_count" {
  type = number
}
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
variable "prevent_key_destroy" {
  description = "Prevent the key from being destroyed"
  type        = bool
  default     = true
  
}

