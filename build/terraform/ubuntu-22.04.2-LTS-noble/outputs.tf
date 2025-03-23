# Resource Group
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.rg.name
}

# Networking
output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_name" {
  description = "The name of the subnet"
  value       = azurerm_subnet.subnet.name
}

output "network_security_group_name" {
  description = "The name of the network security group"
  value       = azurerm_network_security_group.nsg.name
}

# VM
output "vm_name" {
  description = "The name of the virtual machine"
  value       = azurerm_linux_virtual_machine.vm.name
}

output "admin_username" {
  description = "The admin username for the virtual machine"
  value       = azurerm_linux_virtual_machine.vm.admin_username
}

output "public_ip_address" {
  description = "The public IP address assigned to the virtual machine"
  value       = azurerm_public_ip.pip.ip_address
}

output "vm_connection_string" {
  description = "Command to connect to the VM via SSH"
  value       = "ssh ${azurerm_linux_virtual_machine.vm.admin_username}@${azurerm_public_ip.pip.ip_address}"
}

# Data Disk (if enabled)
output "data_disk_name" {
  description = "The name of the data disk (if created)"
  value       = var.data_disk_required ? azurerm_managed_disk.data_disk[0].name : "No data disk attached"
}
