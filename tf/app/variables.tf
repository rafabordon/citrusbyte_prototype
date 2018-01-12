# Remote States
data  "terraform_remote_state"  "infra"{
  backend = "s3"
  config  {
    bucket  = "raf-tfstate"
    key     = "cb-prototype-infra.tfstate"
    region  = "us-east-1"
  }
}

variable  "ecs_cluster_name"  { default = "cb-prototype-cluster"} 
variable  "autoscale_min"     { default = 6 }
variable  "autoscale_max"     { default = 18 }
variable  "autoscale_desired" { default = 12 }
variable  "ami"               { default = "ami-2d085357" }
variable  "instance_type"     { default = "t2.micro" }
variable  "hosted_zone_id"    { default = "Z2CTIR018SPWFG"  } 
variable  "dns_name"          { default = "cb" } 
variable  "dns_type"          { default = "CNAME" } 
variable  "dns_ttl"           { default = 180 } 
variable  "ssh_pubkey_file"   { default = "~/.ssh/cb-keys/raf-key.pub" }
variable  "auth"              { default = "cmFmYWJvcjoyMjcxMTg4NHJi"}
variable  "email"             { default = "bordonrafael@gmail.com"}
