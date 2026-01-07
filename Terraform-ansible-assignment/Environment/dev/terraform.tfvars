aws_region         = "us-east-1"
vpc_cidr           = "10.0.0.0/16"
subnet_cidrs       = ["10.0.1.0/24", "10.0.2.0/24"]
availability_zones = ["us-east-1a", "us-east-1b"]
ami_value          = "ami-020cba7c55df1f615"  
instance_type      = "t2.micro"
# instance_count     = 5
env                = "dev"
key_name           = "dev-my-key"
public_key_path    = "~/.ssh/dev-my-key.pub"
private_key_path   = "~/.ssh/dev-my-key"
previous_instance_count = 2
new_instance_count      = 2
vpc_name         = "terraform-vpc"
gateway_name     = "terraform-gateway"
subnet_names     = ["AppSubnet1-dev", "AppSubnet2-dev"]
route_table_name = "TerraformRouteTable"
sg_name          = "TomcatSecurityGroup"


