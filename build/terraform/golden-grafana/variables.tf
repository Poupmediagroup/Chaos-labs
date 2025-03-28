variable "subscription_id" {
  type    = string
  default = "42321656-24c7-449a-85cb-e5aeb9b9659b"
}


variable "image_name" {
  type    = string
  default = "golden-grafana"
}


variable "location" {
  type    = string
  default = "East US"
}


variable "managed_image_resource_group" {
  type    = string
  default = "RG-Packer-images"
}

variable "resource_group_name" {
  type    = string
  default = "RG-Deployments"
}

variable "vnet_name" {
  type    = string
  default = "golden-vnet"
}

variable "vm_name" {
  type    = string
  default = "golden-grafana-vm"
}

variable "size" {
  type    = string
  default = "Standard_DS2_v2"
}