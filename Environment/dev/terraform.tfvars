aws_region         = "us-east-1"
vpc_cidr           = "10.0.0.0/16"

subnet_cidrs = {
  public  = ["10.0.1.0/24"]
  private = ["10.0.3.0/24"]
}

availability_zones = ["us-east-1a"]
ami_value          = "ami-020cba7c55df1f615"
instance_type      = "t2.micro"
# instance_count     = 2
public_instance_count  = 2
private_instance_count = 1
env                = "dev"
key_name           = "dev-my-key"
public_key_path    = "~/.ssh/dev-my-key.pub"
private_key_path   = "~/.ssh/dev-my-key"
allow_ssh_cidr  = "122.179.16.155/32" # Replace with  IP of the cuuurrent machine

nat_ami_id = "ami-020cba7c55df1f615" # Example NAT AMI ID, replace with your own if needed
private_subnet_cidr = "10.0.3.0/24" # Replace with  private subnet CIDR

