variable "stepfunction_arn" {
  description = "ARN of the StepFunction to trigger"
}

variable "tags" {
  description = "common tags attached to all resources"
  default     = {}
}