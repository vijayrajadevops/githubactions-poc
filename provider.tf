# provider.tf

provider "aws" {
  region = var.aws_region  # Using a variable for the region
  profile = "myprofile"

}
