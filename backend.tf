terraform {
  backend "azurerm" {
    storage_account_name = "firststg702"
    container_name       = "devopscontainer"
    key                  = "vm terraform"
    resource_group_name  = "firstrg701"
  }
}