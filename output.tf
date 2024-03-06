output "backend_vm_public_ip" {
  value = azurerm_public_ip.backend-ip.ip_address
}

output "frontend_vm_public_ip" {
  value = azurerm_public_ip.frontend-ip.ip_address
}

output "mysql_flexible_server_name" {
  value = azurerm_mysql_flexible_server.example.name
}
