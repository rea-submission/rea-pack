# --------------------------------------
# AWS access credentials

variable "aws_access_key" {
  type = string
  description = "AWS access key"
}

variable "aws_secret_key" {
  type = string
  description = "AWS secret key"
}

# --------------------------------------
# AWS region

variable "aws_region" {
  type = string
  description = "AWS region, e.g. 'eu-north-1'"
  # // just an example
  default     = "eu-north-1"
}

