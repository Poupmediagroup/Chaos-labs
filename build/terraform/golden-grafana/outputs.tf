output "admin_username" {
  description = "The admin username for the virtual machine"
  value       = "azureuser"
}

output "public_ip_address" {
  description = "The public IP address assigned to the virtual machine"
  value       = azurerm_public_ip.ip.ip_address
}

