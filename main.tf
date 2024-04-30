provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg" {
  name     = "firstrg701"
# location = "West Europe"
}

resource "azurerm_virtual_network" "vn01" {
  name                = "vino vn"
  address_space       = ["10.0.0.0/16"]
  location            =data.azurerm_resource_group.rg.location
  resource_group_name =data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "sn01" {
  name                 = "vino sn"
  resource_group_name  =data.azurerm_resource_group.rg.name
  virtual_network_name =data.azurerm_virtual_network.vn01.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "ni01" {
  name                = "vino ni"
  location            =data.azurerm_resource_group.rg.location
  resource_group_name =data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sn01.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm01" {
  name                = "vino vm"
  resource_group_name =data.azurerm_resource_group.rg.name
  location            =data.azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.ni01.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  