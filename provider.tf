terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  backend "s3" {
    bucket = "modmedterra"
    key    = "terraform.tfstate"          # The state file will be stored in the root of the bucket
    region = "us-east-1"
  
}

}
