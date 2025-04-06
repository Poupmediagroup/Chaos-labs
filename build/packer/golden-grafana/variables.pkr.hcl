variable "subscription_id" {
  type    = string
  default = null # Fed in from pipeline
}

variable "managed_image_name" {
  type = string
}

variable "managed_image_resource_group_name" {
  type = string
}

variable "os_type" {
  type = string
}

variable "image_publisher" {
  type = string
}

variable "image_offer" {
  type = string
}

variable "image_sku" {
  type = string
}

variable "location" {
  type = string
}

variable "vm_size" {
  type = string
}
variable "communicator" {
  type = string
}

variable "ssh_username" {
  type = string
  # Default user for Ubuntu images in Azure
}

variable "ssh_private_key_file" {
  type = string
}

variable "ssh_timeout" {
  type = string
}

variable "os_disk_size_gb" {
  type = number
}
