terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  backend "s3" {
    bucket = "modmedterra"
    key    = "/"
    region = "us-east-1"
  
}

}
