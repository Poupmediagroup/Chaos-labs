packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}


source "azure-dtl" "ubuntu-noble" {
  subscription_id                   = var.subscription_id
  use_azure_cli_auth                = true
  lab_name                          = var.lab_name
  lab_resource_group_name           = var.lab_resource_group
  managed_image_name                = var.managed_image_name
  managed_image_resource_group_name = var.managed_image_resource_group_name
  os_type                           = var.os_type
  image_publisher                   = var.image_publisher
  image_offer                       = var.image_offer
  image_sku                         = var.image_sku
  location                          = var.location
  vm_size                           = var.vm_size
  communicator                      = var.communicator
  ssh_username                      = var.ssh_username
  ssh_password                      = var.ssh_password
  ssh_timeout                       = var.ssh_timeout
  os_disk_size_gb                   = var.os_disk_size_gb
  lab_virtual_network_name          = var.lab_virtual_network_name
  vm_name                           = var.vm_name
}

build {
  sources = ["source.azure-dtl.ubuntu-noble"]

  # Provisioning with shell script
  provisioner "shell" {
    inline = [
      "echo 'Updating system packages'",
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "echo 'Installation completed successfully!'"
    ]
  }
/*
# Copy files to the VM (optional)
  provisioner "file" {
    source      = "./files/"
    destination = "/tmp/"
  }

  # Run another shell script if needed (optional)
  provisioner "shell" {
    script = "./scripts/setup.sh"
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
  
  */
  
}