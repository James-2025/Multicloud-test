# main.tf

# Configure AWS Provider
provider "aws" {
  region = "us-east-1"  # Update as needed
}

# Configure Azure Provider
provider "azurerm" {
  features {}
}

# Include AWS instance configuration from aws_instance.tf
module "aws_instance" {
  source = "./aws_instance.tf"
}

# Include Azure instance configuration from azure_instance.tf
module "azure_instance" {
  source = "./azure_instance.tf"
}
