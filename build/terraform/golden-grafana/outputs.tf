output "Connection-string" {
  description = "Connect to the server with:"
  value       = "${var.admin_username}@${azurerm_public_ip.ip.ip_address}"
}

output "Grafana" {
  description = "Grafana URL"
  value       = "${azurerm_public_ip.ip.ip_address}:3000"
}

