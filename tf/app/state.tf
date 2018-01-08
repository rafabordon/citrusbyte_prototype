terraform {
  backend "s3" {
    bucket = "raf-tfstate"
    key    = "cb-prototype-service.tfstate"
    region = "us-east-1"
  }
}
