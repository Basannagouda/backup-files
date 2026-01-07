module "web" {
  source              = "../../modules/terraform_private_auto"
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

  public_instance_count  = var.public_instance_count
  private_instance_count = var.private_instance_count
  nat_ami_id             = var.nat_ami_id
  private_subnet_cidr    = var.subnet_cidrs.private[0] #
}

# module "web" {
#   source                 = "../../modules/terraform_private_auto"
#   aws_region             = var.aws_region
#   vpc_cidr               = var.vpc_cidr
#   subnet_cidrs           = var.subnet_cidrs
#   availability_zones     = var.availability_zones
#   ami_value              = var.ami_value
#   instance_type          = var.instance_type
#   public_instance_count  = var.public_instance_count
#   private_instance_count = var.private_instance_count
#   allow_ssh_cidr         = var.allow_ssh_cidr
#   key_name               = var.key_name
#   public_key_path        = var.public_key_path
#   private_key_path       = var.private_key_path
#   env                    = var.env
# }
