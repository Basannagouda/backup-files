# provider "aws" {
#   region = var.aws_region
# }

# resource "aws_vpc" "VPC" {
#   cidr_block = var.vpc_cidr
#   tags = { Name = "TerraformVPC" }
# }

# resource "aws_internet_gateway" "gateway" {
#   vpc_id = aws_vpc.VPC.id
# }

# resource "aws_subnet" "public" {
#   count                   = length(var.subnet_cidrs)
#   vpc_id                  = aws_vpc.VPC.id
#   cidr_block              = var.subnet_cidrs[count.index]
#   availability_zone       = var.availability_zones[count.index]
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "public-subnet-${count.index + 1}"
#   }
# }

# resource "aws_route_table" "route_table" {
#   vpc_id = aws_vpc.VPC.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.gateway.id
#   }
# }

# resource "aws_route_table_association" "attach" {
#   count          = length(var.subnet_cidrs)
#   subnet_id      = aws_subnet.public[count.index].id
#   route_table_id = aws_route_table.route_table.id
# }

# resource "aws_security_group" "security_group" {
#   name   = "security_group"
#   vpc_id = aws_vpc.VPC.id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = [var.allow_ssh_cidr]
#   }

#   ingress {
#     from_port   = 8080
#     to_port     = 8080
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_key_pair" "key_generation" {
#   key_name   = var.key_name
#   public_key = file(var.public_key_path)
# }

# locals {
#   instance_names = [for i in range(1, var.instance_count + 1) : "instance${i}"]
#   subnet_ids     = aws_subnet.public[*].id

#   subnet_map = {
#     for idx, name in local.instance_names :
#     name => idx < ceil(var.instance_count / 2) ? local.subnet_ids[0] : local.subnet_ids[1]
#   }
# }


# # this is the main resource block for creating EC2 instances which is correct 


# resource "aws_instance" "Tomcat_instance" {
#   for_each                    = tomap({ for name in local.instance_names : name => name })
# #   for_each = { for name in local.all_instance_names : name => name }
#   ami                         = var.ami_value
#   instance_type               = var.instance_type
#   subnet_id                   = local.subnet_map[each.key]
# #   subnet_id                   = local.merged_subnet_map[each.key]
#   vpc_security_group_ids      = [aws_security_group.security_group.id]
#   associate_public_ip_address = true
#   key_name                    = aws_key_pair.key_generation.key_name

#   tags = {
#     Name = each.key
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt update -y",
#       "sudo apt install -y python3"
#     ]

#     connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       private_key = file(var.private_key_path)
#       host        = self.public_ip
#     }
#   }
# }

#-----------------------------------------------------------------------------------------------------------
provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "VPC" {
  cidr_block = var.vpc_cidr
  tags = { 
    Name = "${var.vpc_name}-${var.env}" }
}

# Internet Gateway
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.VPC.id
    tags = {
        Name = "${var.gateway_name}-${var.env}"
    }
}

# Subnets
# Public Subnets
# This will create public subnets based on the provided CIDRs and availability zones.
resource "aws_subnet" "public" {
  count                   = length(var.subnet_cidrs)
  vpc_id                  = aws_vpc.VPC.id
  cidr_block              = var.subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.subnet_names[count.index]}-${var.env}"
  }
}

# Route Table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

    tags = {
        Name = "${var.route_table_name}-${var.env}"
    }
}

# Route Table Associations
resource "aws_route_table_association" "attach" {
  count          = length(var.subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.route_table.id
}

# Security Group
resource "aws_security_group" "security_group" {
  name   = "security_group"
  vpc_id = aws_vpc.VPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allow_ssh_cidr]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags = {
        Name = "${var.sg_name}-${var.env}"
    }
}
resource "aws_key_pair" "key_generation" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)

}

#
# locals {
#   instance_names = [for i in range(1, var.instance_count + 1) : "instance${i}"]
#   subnet_ids     = aws_subnet.public[*].id

#   # If only 1 subnet, assign all instances to it.
#   # If 2 subnets, use 60/40 logic.

#   subnet_map = length(local.subnet_ids) == 1 ? {
#     for name in local.instance_names : name => local.subnet_ids[0]
#   } : {
#     # for idx, name in local.instance_names :
#     # name => idx < ceil(var.instance_count * 0.6) ? local.subnet_ids[0] : local.subnet_ids[1]

#     for idx, name in local.instance_names :
#     name => idx < ceil(var.instance_count / 2) ? local.subnet_ids[0] : local.subnet_ids[1]
#   }
# }

# this will solve the issue of assigning instances to subnets based on count and availability
# if the instnaces are varied after the VPC plan the instnace will not change the subnet once a instance is created it will stay in the same subnet 

# locals {
#   instance_names = [for i in range(1, var.instance_count + 1) : "instance${i}"]
#   subnet_ids     = aws_subnet.public[*].id
#   subnet_count   = length(local.subnet_ids)

#   subnet_map = {
#     for idx, name in local.instance_names :
#     name => local.subnet_ids[
#       idx % local.subnet_count
#     ]
#   }
# }


# # EC2 Instances
# resource "aws_instance" "Tomcat_instance" {
#   for_each                    = tomap({ for name in local.instance_names : name => name })
#   ami                         = var.ami_value
#   instance_type               = var.instance_type
#   subnet_id                   = local.subnet_map[each.key]
#   vpc_security_group_ids      = [aws_security_group.security_group.id]
#   associate_public_ip_address = true
#   key_name                    = aws_key_pair.key_generation.key_name

#   tags = {
#     Name        = "${each.key}-${var.env}"
#     Environment = var.env
#   }


#   # provisioner "remote-exec" {
#   #   inline = [
#   #     "sudo apt update -y",
#   #     "sudo apt install -y python3"
#   #   ]

#   #   connection {
#   #     type        = "ssh"
#   #     user        = "ubuntu"
#   #     private_key = file(var.private_key_path)
#   #     host        = self.public_ip
#   #   }
#   # }
# }


#-----------------------------------------------------------------------------------------------------------
# locals {
#   # Create only NEW instances starting after the existing ones
#   instance_names = [
#     for i in range(var.previous_instance_count + 1, var.previous_instance_count + var.new_instance_count + 1) :
#     "instance${i}"
#   ]

#   subnet_ids   = aws_subnet.public[*].id
#   subnet_count = length(local.subnet_ids)

#   subnet_map = {
#     for idx, name in local.instance_names :
#     name => local.subnet_ids[idx % local.subnet_count]
#   }
# }


# resource "aws_instance" "Tomcat_instance" {
#   for_each                    = tomap({ for name in local.instance_names : name => name })
#   ami                         = var.ami_value
#   instance_type               = var.instance_type
#   subnet_id                   = local.subnet_map[each.key]
#   vpc_security_group_ids      = [aws_security_group.security_group.id]
#   associate_public_ip_address = true
#   key_name                    = aws_key_pair.key_generation.key_name

#   tags = {
#     Name        = "${each.key}-${var.env}"
#     Environment = var.env
#   }
# }


#==========================================================================================
locals {
  # Old instance names (previously deployed ones)
  existing_instance_names = [
    for i in range(1, var.previous_instance_count + 1) :
    "instance${i}"
  ]

  # New instance names (to be created now)
  new_instance_names = [
    for i in range(var.previous_instance_count + 1, var.previous_instance_count + var.new_instance_count + 1) :
    "instance${i}"
  ]

  # Combined (all instances)
  all_instance_names = concat(local.existing_instance_names, local.new_instance_names)

  subnet_ids   = aws_subnet.public[*].id
  subnet_count = length(local.subnet_ids)

  subnet_map = {
    for idx, name in local.all_instance_names :
    name => local.subnet_ids[idx % local.subnet_count]
  }
}

resource "aws_instance" "Tomcat_instance" {
  for_each                    = tomap({ for name in local.all_instance_names : name => name })
  ami                         = var.ami_value
  instance_type               = var.instance_type
  subnet_id                   = local.subnet_map[each.key]
  vpc_security_group_ids      = [aws_security_group.security_group.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key_generation.key_name

  tags = {
    Name        = "${each.key}-${var.env}"
    Environment = var.env
  }
}

#==========================================================================================