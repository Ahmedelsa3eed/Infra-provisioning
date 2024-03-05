output "backend_vm_public_ip" {
  value = azurerm_public_ip.backend-ip.ip_address
}