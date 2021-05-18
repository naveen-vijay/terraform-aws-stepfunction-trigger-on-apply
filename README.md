# terraform-aws-stepfunction-trigger-on-apply

## Introduction 

Terraform module that triggers the execution of the step function on every Terraform Apply. Utilizes the DynamoDB Streams to trigger AWS Lambda which starts the Step Function execution.

## Architecture
<img src="https://raw.githubusercontent.com/naveen-vijay/terraform-aws-stepfunction-trigger-on-apply/dev/docs/architecture-diagram.jpg">

## Usage

```
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
        Foo = "Bar"
    }
  }
}

module "this" {
  source = "naveen-vijay/stepfunction-trigger-on-apply/aws"

  stepfunction_arn = var.stepfunction_arn
}
```