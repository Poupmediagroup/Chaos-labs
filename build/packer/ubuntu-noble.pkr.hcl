packer {
  required_plugins {
    azure = {
      version = ">= 2.3.1"
      source  = "hashicorp/azure"
    }
  }
}

source "azure-arm-dtl" "example" {
  use_azure_cli_auth           = true
  location                     = "East US"
  resource_group_name          = "your-resource-group"
  lab_name                     = "your-devtest-lab-name"
  vm_name                      = "your-vm-name"
  managed_image_name           = "your-managed-image-name"
  managed_image_resource_group = "your-resource-group"
}

build {
  sources = [
    "source.azure-arm-dtl.example"
  ]
}

