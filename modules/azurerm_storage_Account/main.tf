# This block is hardcoded only to test tfsec results
resource "azurerm_storage_account" "example" {
  name                     = "stg0282618"
  resource_group_name      = "rg-bdy"
  location                 = "eastus2"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  account_kind             = "Storage" 
}
variable "unused_variable_test" {
  type    = string
  default = "hello"
}