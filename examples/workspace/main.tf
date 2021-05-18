provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = var.tags
  }
}

module "this" {
  source           = "naveen-vijay/stepfunction-trigger-on-apply/aws"
  stepfunction_arn = var.stepfunction_arn

  providers = {
    aws = aws
  }
}