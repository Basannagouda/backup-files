
module "web" {
  source              = "../../modules/terraform_instance"
  aws_region          = var.aws_region
  vpc_cidr            = var.vpc_cidr
  subnet_cidrs        = var.subnet_cidrs
  availability_zones  = var.availability_zones
  ami_value           = var.ami_value
  instance_type       = var.instance_type
  # instance_count      = var.instance_count
  allow_ssh_cidr      = var.allow_ssh_cidr
  key_name            = var.key_name
  public_key_path     = var.public_key_path
  private_key_path    = var.private_key_path
  env                 = var.env
  previous_instance_count = var.previous_instance_count
  new_instance_count      = var.new_instance_count
  vpc_name            = var.vpc_name
  gateway_name        = var.gateway_name
  subnet_names        = var.subnet_names
  route_table_name    = var.route_table_name
  sg_name             = var.sg_name
}
