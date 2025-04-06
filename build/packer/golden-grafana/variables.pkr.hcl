variable "subscription_id" {
  type    = string
  default = null    # Fed in from pipeline
}

variable "managed_image_name" {
  type    = string
  default = "golden-grafana"
}

variable "managed_image_resource_group_name" {
  type    = string
  default = "RG-Packer-images"
}

variable "os_type" {
  type    = string
  default = "Linux"
}

variable "image_publisher" {
  type    = string
  default = "Canonical"
}

variable "image_offer" {
  type    = string
  default = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  type    = string
  default = "22_04-lts"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "vm_size" {
  type    = string
  default = "Standard_DS2_v2"
}
variable "communicator" {
  type    = string
  default = "ssh"
}

variable "ssh_username" {
  type    = string
  default = "azureuser" # Default user for Ubuntu images in Azure
}

variable "ssh_private_key_file" {
  type    = string
  default = null # This will be overwritten by actual secret in github
}

variable "ssh_timeout" {
  type    = string
  default = "10m"
}

variable "os_disk_size_gb" {
  type    = number
  default = 30
}
