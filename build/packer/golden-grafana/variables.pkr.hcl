variable "subscription_id" {
  type    = string
  default = null    # Fed in from pipeline
}

variable "ssh_private_key_file" {
  type    = string
  default = null # This will be overwritten by actual secret in github
}
