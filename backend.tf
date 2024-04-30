terraform {
  backend "azurerm" {
    storage_account_name = "firststs702"
    container_name       = "deveopscontainer"
    key                  = "vm terraform"
    resource_group_name  = "firstrg701"
  }
}