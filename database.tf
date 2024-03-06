resource "azurerm_mysql_flexible_server" "example" {
  name                   = "mysql-fs-${random_string.name.result}"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  
  administrator_login    = random_string.name.result
  administrator_password = random_password.password.result
  
  backup_retention_days  = 7
  delegated_subnet_id    = azurerm_subnet.ABI-subnet.id
  private_dns_zone_id    = azurerm_private_dns_zone.zone.id
  sku_name               = "B_Standard_B1s"

  depends_on = [azurerm_private_dns_zone_virtual_network_link.example]
}

resource "azurerm_mysql_flexible_database" "mysql" {
  name                = "mysql-db"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.example.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_flexible_server_firewall_rule" "firewall-rule" {
  name                = "office"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.example.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}