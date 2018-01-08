terraform {
  backend "s3" {
    bucket = "raf-tfstate"
    key    = "cb-prototype-infra.tfstate"
    region = "us-east-1"
  }
}
