variable "subscription_id" {
  type    = string
  default = "42321656-24c7-449a-85cb-e5aeb9b9659b"
}

variable "lab_name" {
  type    = string
  default = "Packer-lab"
}

variable "lab_resource_group" {
  type    = string
  default = "RG-Tai-lab"
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
  default = "/Users/tai-dev/.ssh/packer_key" # Path to your private key
}

variable "ssh_timeout" {
  type    = string
  default = "10m"
}

variable "os_disk_size_gb" {
  type    = number
  default = 30
}
