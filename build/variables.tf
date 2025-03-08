# General Variables
variable "prefix" {
  description = "Prefix to be used for all resources"
  type        = string
}

variable "environment" {
  description = "Environment (dev, test, prod)"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Network Variables
variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_address_prefix" {
  description = "Address prefix for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "ssh_source_address_prefix" {
  description = "Source IP range for SSH access"
  type        = string
  default     = "*"
}

# VM Variables
variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "admin_username" {
  description = "Username for the VM admin account"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for VM authentication"
  type        = string
}

# OS Disk Variables
variable "os_disk_storage_account_type" {
  description = "Storage account type for OS disk"
  type        = string
  default     = "Premium_LRS"
}

variable "os_disk_size_gb" {
  description = "Size of the OS disk in GB"
  type        = number
  default     = 30
}

# Data Disk Variables
variable "data_disk_required" {
  description = "Whether a data disk should be attached to the VM"
  type        = bool
  default     = false
}

variable "data_disk_storage_account_type" {
  description = "Storage account type for data disk"
  type        = string
  default     = "Premium_LRS"
}

variable "data_disk_size_gb" {
  description = "Size of the data disk in GB"
  type        = number
  default     = 100
}

# OS Image Variables
variable "os_image_publisher" {
  description = "Publisher of the OS image"
  type        = string
  default     = "Canonical"
}

variable "os_image_offer" {
  description = "Offer of the OS image"
  type        = string
  default     = "0001-com-ubuntu-server-noble"
}

variable "os_image_sku" {
  description = "SKU of the OS image"
  type        = string
  default     = "24_04-lts"
}

variable "os_image_version" {
  description = "Version of the OS image"
  type        = string
  default     = "latest"
}
