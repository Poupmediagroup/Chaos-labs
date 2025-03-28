# Reference the existing managed image
data "azurerm_image" "existing_image" {
  name                = var.image_name
  resource_group_name = var.managed_image_resource_group
}

# Create a virtual network
resource "azurerm_virtual_network" "example" {
  name                = "test-net"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Create a subnet
resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = var.resource_group_name
  virtual_network_name = "test-net"
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a public IP
resource "azurerm_public_ip" "example" {
  name                = "test-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

# Create a network interface
resource "azurerm_network_interface" "example" {
  name                = "test-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

# Create the virtual machine using the managed image
resource "azurerm_linux_virtual_machine" "example" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.example.id]
  size                  = var.size

  # Use the managed image
  source_image_id = data.azurerm_image.existing_image.id

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Specify your admin credentials
  admin_username = "adminuser"
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("/Users/tai-dev/.ssh/terraform_key.pub")
  }
}

# Optional: Network security group
resource "azurerm_network_security_group" "example" {
  name                = "test-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate NSG with network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}