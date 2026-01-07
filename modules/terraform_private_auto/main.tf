provider "aws" {
  region = var.aws_region
}

# -----------------
# VPC
# -----------------
resource "aws_vpc" "Terraform_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.env}-vpc"
  }
}

# -----------------
# Internet Gateway
# -----------------
resource "aws_internet_gateway" "private_internet_gateway" {
  vpc_id = aws_vpc.Terraform_vpc.id

  tags = {
    Name = "${var.env}-private_internet_gateway"
  }
}

# -----------------
# Public Subnets
# -----------------
resource "aws_subnet" "public" {
  count                   = length(var.subnet_cidrs.public)
  vpc_id                  = aws_vpc.Terraform_vpc.id
  cidr_block              = var.subnet_cidrs.public[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-public-${count.index + 1}"
  }
}

# -----------------
# Private Subnets
# -----------------
resource "aws_subnet" "private" {
  count                   = length(var.subnet_cidrs.private)
  vpc_id                  = aws_vpc.Terraform_vpc.id
  cidr_block              = var.subnet_cidrs.private[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.env}-private-${count.index + 1}"
  }
}

# -----------------
# Public Route Table
# -----------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.Terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.private_internet_gateway.id
  }

  tags = {
    Name = "${var.env}-public-rt"
  }
}



resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


resource "aws_key_pair" "key_generation" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)

  # lifecycle {
  #   prevent_destroy = true
  # }
}


# Bastion Host Security Group (Public Subnet)
resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.Terraform_vpc.id
  name   = "${var.env}-bastion-sg"

  ingress {
    description = "Allow SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

   ingress {
    description = "HTTP from my IP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Or "0.0.0.0/0" if public web access needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-bastion-sg"
  }
}

# Private Instance Security Group (No Public Access)
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.Terraform_vpc.id
  name   = "${var.env}-private-sg"

  ingress {
    description     = "Allow SSH from Bastion Host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id] # Allow SSH only from Bastion
  }

  ingress {
    description = "Allow Tomcat (8080) from Bastion Host"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }
  ingress {
    description = "HTTP from my IP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allow_ssh_cidr] # Or "0.0.0.0/0" if public web access needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-private-sg"
  }
}



# Public instances (Bastion hosts)
resource "aws_instance" "public_instances" {
  count         = var.public_instance_count
  ami           = var.ami_value
  instance_type = var.instance_type
  subnet_id     = element(aws_subnet.public[*].id, count.index % length(aws_subnet.public))
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id] # SG for bastion/public access


  tags = {
    Name = "${var.env}-bastion-public-instance-${count.index + 1}"
  }
   provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y apache2",
      "sudo systemctl enable apache2",
      "sudo systemctl start apache2",
      "echo 'Apache has started' | sudo tee /var/www/html/index.html"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
}



# Private instances
resource "aws_instance" "private_instances" {
  count         = var.private_instance_count
  ami           = var.ami_value
  instance_type = var.instance_type
  subnet_id     = element(aws_subnet.private[*].id, count.index % length(aws_subnet.private))
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
    Name        = "${var.env}-private-instance-${count.index + 1}"
    Environment = var.env
  }
}



# 1. NAT Instance Security Group (allow traffic from private subnet)
resource "aws_security_group" "nat_sg" {
  name        = "${var.env}-nat-sg"
  description = "Security group for NAT Instance"
  vpc_id      = aws_vpc.Terraform_vpc.id

  ingress {
    description = "Allow all traffic from private subnet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.subnet_cidrs.private
  }

  egress {
    description = "Allow all outbound internet traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-nat-sg"
  }
}

# 2. NAT Instance
resource "aws_instance" "nat_instance" {
  ami                         = var.nat_ami_id  
  instance_type               = var.instance_type    
  subnet_id                   = aws_subnet.public[0].id
  associate_public_ip_address = true
  key_name                   = var.key_name
  vpc_security_group_ids     = [aws_security_group.nat_sg.id]
  source_dest_check           = false  # Required for NAT instance

  tags = {
    Name = "${var.env}-nat-instance"
  }
}

# 3. Create a Route Table for private subnet to route 0.0.0.0/0 via NAT instance
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.Terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = aws_instance.nat_instance.primary_network_interface_id
  }

  tags = {
    Name = "${var.env}-private-rt"
  }
}

# 4. Associate private subnets with the NAT route table
resource "aws_route_table_association" "private_assoc" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}




