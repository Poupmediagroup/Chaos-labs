variable "subscription_id" {
  type    = string
  default = ""
} 

variable "lab_name" {
  type    = string
  default = "Packer-lab"
}


variable "location" {
  type    = string
  default = "eastus"
}


variable "vm_name" {
  type    = string
  default = "golden-grafana-image"
}
