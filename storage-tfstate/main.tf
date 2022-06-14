provider "azurerm" {
  features {}
}


//Storage for state file

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}



resource "azurerm_resource_group" "tfstate" {
  name     = var.resouregroup_name_storage
  location = var.location
}

resource "azurerm_storage_account" "tfstate" {
  name                     = var.st_account_name
  // name                     = "mystorageank564"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = var.storage_tier
  account_replication_type = var.st_account_replication_type
  //allow_blob_public_access = true

  tags = {
    environment = var.env
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = var.st_container_name
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = var.st_container_access_type
}