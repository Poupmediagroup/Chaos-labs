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

  # Provisioning with shell script
  provisioner "shell" {
    inline = [
      "echo 'Updating system packages'",
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "echo 'Installation completed successfully!'",
      "echo 'Cloning repo'",
      "git clone https://github.com/Poupmediagroup/Chaos-labs.git",
      "echo 'Starting setup scripts'",
      "echo 'Navigating to scripts directory'",
      "cd Chaos-labs/build/scripts/",
      "echo 'Setting permissions on monitoring stack, grafana-setup and tooling.sh'",
      "chmod +x ./tooling.sh ./monitoring-stack.sh ./grafana-setup.py",
      "echo 'executing scripts now'",
      "./tooling.sh && ./monitoring-stack.sh"
    ]
  }

  # Clean up the VM before creating the image
  provisioner "shell" {
    inline = [
      "echo 'Cleaning up'",
      "sudo apt-get clean",
      "sudo rm -rf /var/lib/apt/lists/*",
      "sudo waagent -force -deprovision+user && export HISTSIZE=0"
    ]
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
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
