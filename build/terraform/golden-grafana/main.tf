# Reference the existing managed image
data "azurerm_image" "existing_image" {
  name                = var.image_name
  resource_group_name = var.managed_image_resource_group
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.image_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Create a subnet
resource "azurerm_subnet" "subnet" {
  name                 = "default"
  resource_group_name  = var.resource_group_name
  virtual_network_name = "${var.image_name}-vnet"
  address_prefixes     = ["10.0.1.0/24"]
  depends_on = [azurerm_virtual_network.vnet]
}



# Create a public IP
resource "azurerm_public_ip" "ip" {
  name                = "${var.image_name}-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

# Create a network interface
resource "azurerm_network_interface" "nic" {
  name                = "${var.image_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.image_name}-config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip.id
  }
}

# Create the virtual machine using the managed image
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.size

  # Use the managed image
  source_image_id = data.azurerm_image.existing_image.id

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Specify your admin credentials
  admin_username = var.admin_username
  admin_ssh_key {
    username   = var.admin_username
    public_key = file("/Users/tai-dev/.ssh/packer_key.pub")
  }
}

# Query for my IP address
data "http" "my_ip" {
  url = "https://ipinfo.io/ip"
}

# Allow SSH for my IP
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.image_name}-nsg"
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
    source_address_prefix      = data.http.my_ip.response_body
    destination_address_prefix = "*"
  }

  # Allow Node exporter metrics collection 
    security_rule {
        name                       = "Node-Exporter"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = azurerm_public_ip.ip.ip_address
        destination_address_prefix = "*"
      }

    # Allow inbound for Grafna
    security_rule {
        name                       = "Grafana-inbound"
        priority                   = 1003
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "3000"
        source_address_prefix      = data.http.my_ip.response_body
        destination_address_prefix = "*"
      }

}

# Associate NSG with network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}