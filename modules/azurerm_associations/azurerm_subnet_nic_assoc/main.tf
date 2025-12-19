resource "azurerm_subnet_network_security_group_association" "subnetnsgassoc" {
  for_each                  = var.subnet_nsg_assoc
  subnet_id                 = data.azurerm_subnet.subnetids[each.key].id
  network_security_group_id = data.azurerm_network_security_group.nsg[each.key].id
}

data "azurerm_subnet" "subnetids" {
  for_each             = var.subnet_nsg_assoc
  name                 = each.value.existing_subnet_name
  virtual_network_name = each.value.existing_vnet_name
  resource_group_name  = each.value.subnet_resource_group_name
}
data "azurerm_network_security_group" "nsg" {
  for_each            = var.subnet_nsg_assoc
  name                = each.value.existing_nsg_name
  resource_group_name = each.value.nsg_resource_group_name
}
variable "subnet_nsg_assoc" {
  type = map(object({
    existing_subnet_name       = string
    existing_vnet_name         = string
    subnet_resource_group_name = string
    existing_nsg_name          = string
    nsg_resource_group_name    = string
  }))
}
