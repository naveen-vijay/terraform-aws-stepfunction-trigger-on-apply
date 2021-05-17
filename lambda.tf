resource "aws_iam_role" "for_lambda" {
  name               = "stepfunction_trigger_role_${random_id.something_arbitrary.hex}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "for_iam_role" {
  statement {
    actions = [
      "states:StartExecution"
    ]
    resources = [
      var.stepfunction_arn
    ]
  }

  statement {
    actions = [
      "dynamodb:GetRecords",
      "dynamodb:GetShardIterator",
      "dynamodb:DescribeStream",
      "dynamodb:ListShards",
      "dynamodb:ListStreams"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "for_iam_role" {
  policy = data.aws_iam_policy_document.for_iam_role.json
  name   = "stepfunction_auto_trigger_${random_id.something_arbitrary.hex}"
}

resource "aws_iam_role_policy_attachment" "for_iam_role" {
  policy_arn = aws_iam_policy.for_iam_role.arn
  role       = aws_iam_role.for_lambda.name
}

resource "aws_iam_role_policy_attachment" "for_lambda_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.for_lambda.name
}


data "archive_file" "for_lambda" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/trigger_stepfunction/"
  output_path = "${path.module}/lambda/trigger_stepfunction.zip"
}

resource "aws_lambda_function" "lambda" {
  filename         = "${path.module}/lambda/trigger_stepfunction.zip"
  function_name    = "stepfunction_auto_trigger_${random_id.something_arbitrary.hex}"
  role             = aws_iam_role.for_lambda.arn
  handler          = "trigger_stepfunction.lambda_handler"
  source_code_hash = data.archive_file.for_lambda.output_base64sha256

  runtime = "python3.7"

  environment {
    variables = {
      STEPFUNCTION_ARN = var.stepfunction_arn
    }
  }
}