variable  "vpc_id" {
  default  = "vpc-4eee0237"
}
variable  "region" {
  default	= "us-east-1"
}

variable  "vpc_cidr"  {
  default = "10.27.0.0/20"
}

variable  "public_subnet_cidrs" {
  default = "10.27.0.0/23,10.27.2.0/23,10.27.4.0/23"
}
variable  "private_subnet_cidrs"  {
  default = "10.27.6.0/23,10.27.8.0/23,10.27.10.0/23"
}

variable  "availability_zones"  {
  type  = "list"
  default = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
}

variable  "pub_dest_cidr_blocks"  {
  default = "10.10.15.206/32,10.72.162.199/32,10.72.162.200/32,10.120.23.0/24,10.128.61.62/32,10.128.61.107/32,10.128.61.108/32"
}

variable  "access_key"  {
  default = "AKIAJGWRCHBEBICP37RQ"
}

variable  "secret_key"  {
  default = "82Lnw2ya43uYf5JIQo8OcbyIHyQNfsjsQ9+TeFhl" 
}
