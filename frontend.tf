# Create a public IP address for frontend machine
resource "azurerm_public_ip" "frontend-ip" {
  name                = "frontend-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create a network interface for frontend machine
resource "azurerm_network_interface" "frontend-nic" {
  name                = "frontend-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.frontend-ip.id
  }
}

# Create a virtual machine for frontend
resource "azurerm_linux_virtual_machine" "frontend" {
  name                  = "frontend-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.frontend-nic.id]
  size                  = "Standard_B1s"
  admin_username        = "saeed"

  admin_ssh_key {
    username   = "saeed"
    public_key = file("~/.ssh/id_rsa_frontend.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    name                 = "frontend-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }
}
