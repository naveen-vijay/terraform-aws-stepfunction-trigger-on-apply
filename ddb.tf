resource "aws_dynamodb_table" "for_stepfunction_trigger" {
  name             = "stepfunction_auto_trigger_${random_id.something_arbitrary.hex}"
  billing_mode     = "PROVISIONED"
  read_capacity    = 1
  write_capacity   = 1
  hash_key         = "id"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "for_stepfunction_trigger" {
  depends_on = [aws_lambda_function.lambda, aws_lambda_event_source_mapping.for_lambda_trigger]
  hash_key   = aws_dynamodb_table.for_stepfunction_trigger.hash_key
  table_name = aws_dynamodb_table.for_stepfunction_trigger.name
  item       = <<ITEM
  {
    "id" : {"S" : "${timestamp()}" }
  }
  ITEM
}

resource "aws_lambda_event_source_mapping" "for_lambda_trigger" {
  event_source_arn       = aws_dynamodb_table.for_stepfunction_trigger.stream_arn
  function_name          = aws_lambda_function.lambda.arn
  starting_position      = "LATEST"
  batch_size             = 1
  maximum_retry_attempts = 3
}
