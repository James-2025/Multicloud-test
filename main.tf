# main.tf

# aws_instance.tf
provider "aws" {
  region = "us-east-1"  # Adjust as needed
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with a valid AMI for your region
  instance_type = "t2.micro"

  provisioner "file" {
    source      = "index.html"
    destination = "/var/www/html/index.html"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y apache2",
      "sudo mv /var/www/html/index.html /var/www/html/",
      "sudo systemctl start apache2",
      "sudo systemctl enable apache2"
    ]
  }

  tags = {
    Name = "aws-web-server"
  }
}

# azure_instance.tf
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-webapp"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-webapp"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-webapp"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-webapp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-webapp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                = "Standard_B1s"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_username = "azureuser"
  admin_password = "P@ssword1234!"  # Update to a secure password

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  provisioner "file" {
    source      = "index.html"
    destination = "/var/www/html/index.html"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y apache2",
      "sudo mv /var/www/html/index.html /var/www/html/",
      "sudo systemctl start apache2",
      "sudo systemctl enable apache2"
    ]
  }
}
