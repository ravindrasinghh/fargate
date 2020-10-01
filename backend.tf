
terraform {
  backend "s3" {
    bucket         = "terraformravindra"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    profile        = "default"
  }
}