# Create a public IP address for backend machine
resource "azurerm_public_ip" "backend-ip" {
  name                = "backend-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  lifecycle {
    create_before_destroy = true
  }
}

# Create a network interface for backend machine
resource "azurerm_network_interface" "backend-nic" {
  name                = "backend-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ABI-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.backend-ip.id
  }
}

# Create a virtual machine for backend
resource "azurerm_linux_virtual_machine" "backend" {
  name                  = "backend-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.backend-nic.id]
  size                  = "Standard_B1s"  # Adjust size as needed
  admin_username        = "saeed"

  admin_ssh_key {
    username   = "saeed"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    name                 = "backend-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }
}