provider "aws" {
  profile = local.aws_name_profile 
  region  = local.aws_region

  default_tags {
    tags = {
      management = "terraform"
    }
  }
}
