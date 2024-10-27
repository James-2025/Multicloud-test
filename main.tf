# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "azurerm" {
  features {}
}

# Include AWS and Azure resources
module "aws" {
  source = "./aws_instance.tf"
}

module "azure" {
  source = "./azure_instance.tf"
}
