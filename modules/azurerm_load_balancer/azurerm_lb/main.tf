resource "azurerm_lb" "lb" {
  for_each            = var.lb
  name                = each.value.lbname
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  dynamic "frontend_ip_configuration" {
    for_each = try(each.value.frontend_ip_configurations, {})
    content {
      name                 = frontend_ip_configuration.value.frontend_ip_configuration_name
      public_ip_address_id = data.azurerm_public_ip.pip[each.key].id
    }

  }
}
variable "lb" {
  type = map(object({
    lbname                  = string
    location                = string
    resource_group_name     = string
    existing_pip_name       = string
    pip_resource_group_name = string
    frontend_ip_configurations = map(object({
      frontend_ip_configuration_name = string
    }))

  }))
}
data "azurerm_public_ip" "pip" {
  for_each            = var.lb
  name                = each.value.existing_pip_name
  resource_group_name = each.value.pip_resource_group_name
}
