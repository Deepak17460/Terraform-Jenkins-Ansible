terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
   name     = "deepakkumar25"
   location = "Central India"
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "DpcodeVM"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2s"

  os_disk {
    name                 = "dpcode"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  computer_name  = "monitoringvm"
  admin_username = "azureuser"

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("id_rsa.pub")
  }

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  disable_password_authentication = true
}
output "public_ip" {
  value = azurerm_public_ip.pip.ip_address
}
