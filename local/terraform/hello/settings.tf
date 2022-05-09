# --------------------------------------
# vm configuration

variable "ami_id" {
  description = "Instance image id -- Ubuntu (>=20.04), e.g. 'ami-09f0506c9ef0fb473'"
  type        = string
  # use ami ids for Ubuntu 20.04 LTS
  default     = "ami-09f0506c9ef0fb473"
}

variable "instance_type" {
  description = "Instance type, e.g. 't3.micro'"
  type        = string
  default     = "t3.micro"
}


# --------------------------------------
# authentication


variable "keypair_name" {
  description = "A name for an existing ssh keypair"
  type        = string

  default     = "FILLME"
}


