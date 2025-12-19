resource "azurerm_network_interface" "nics" {
  for_each            = var.nics
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  dynamic "ip_configuration" {
    for_each = try(each.value.ip_configurations, {})
    content {
      name                          = ip_configuration.value.ip_configuration_name
      subnet_id                     = data.azurerm_subnet.subnets[each.key].id
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
    }

  }
}
variable "nics" {
  type = map(object({
    nic_name                            = string
    location                            = string
    resource_group_name                 = string
    existing_subnet_name                = string
    existing_virtual_network_name       = string
    existing_subnet_resource_group_name = string
    ip_configurations = map(object({
      ip_configuration_name         = string
      private_ip_address_allocation = string
    }))
  }))
}
data "azurerm_subnet" "subnets" {
  for_each             = var.nics
  name                 = each.value.existing_subnet_name
  virtual_network_name = each.value.existing_virtual_network_name
  resource_group_name  = each.value.existing_subnet_resource_group_name
}
