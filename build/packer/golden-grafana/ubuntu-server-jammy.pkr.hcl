packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

# Source: azure-arm builder
source "azure-arm" "ubuntu-jammy" {
  use_azure_cli_auth                = true
  communicator                      = "ssh"
  location                          = var.location
  image_publisher                   = var.image_publisher
  image_offer                       = var.image_offer
  image_sku                         = var.image_sku
  vm_size                           = var.vm_size
  os_disk_size_gb                   = var.os_disk_size_gb
  ssh_username                      = var.ssh_username
  ssh_private_key_file              = var.ssh_private_key_file
  os_type                           = var.os_type
  managed_image_name                = var.managed_image_name
  managed_image_resource_group_name = var.managed_image_resource_group_name
}

build {
  sources = ["source.azure-arm.ubuntu-jammy"]

  # Provisioning with shell scripts
  provisioner "shell" {
    scripts = [
      "../../scripts/tooling.sh",
      "../../scripts/monitoring-stack.sh"
    ]
  }

  # Provisioning with shell scripts inline
  provisioner "shell" {
    inline = [
      "echo 'Updating system packages'",
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "echo 'Cloning repo'",
      "git clone https://github.com/Poupmediagroup/Chaos-labs.git"
    ]
  }

  # Post-processors to show final output
  post-processors {
    post-processor "shell-local" {
      inline = [
        "echo '=== Packer Build Outputs ==='",
        "echo \"Image Name: ${var.managed_image_name}\"",
        "echo \"Resource Group: ${var.managed_image_resource_group_name}\""
      ]
    }
  }
}
