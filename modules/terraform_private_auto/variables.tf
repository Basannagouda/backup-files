variable "aws_region" {}
variable "vpc_cidr" {}
variable "subnet_cidrs" {
  type = object({
    public  = list(string)
    private = list(string)
  })
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
# variable "allow_ssh_cidr" {
#   default = "0.0.0.0/0"
# }
variable "key_name" {}
variable "public_key_path" {}
variable "private_key_path" {}

variable "env" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "public_instance_count" {
  type = number
}

variable "private_instance_count" {
  type = number
}

variable "allow_ssh_cidr" {
  description = "CIDR block allowed to SSH into Bastion host"
  type        = string
}

variable "nat_ami_id" {
  description = "AMI ID for the NAT instance"
  type        = string
  default     = "ami-020cba7c55df1f615"
  
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string 
}