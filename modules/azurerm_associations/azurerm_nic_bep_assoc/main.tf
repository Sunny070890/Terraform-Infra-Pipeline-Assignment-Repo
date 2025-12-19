resource "azurerm_network_interface_backend_address_pool_association" "nicbepassoc" {
  for_each                = var.nicbep
  network_interface_id    = data.azurerm_network_interface.nic[each.key].id
  ip_configuration_name   = each.value.nic_ip_configuration_name
  backend_address_pool_id = data.azurerm_lb_backend_address_pool.bep[each.key].id
}
variable "nicbep" {
  type = map(object({
    nic_ip_configuration_name = string
    existing_nic_name         = string
    nic_resource_group_name   = string
    existing_lb_name          = string
    lb_resource_group_name    = string
    existing_bep_name         = string
  }))
}
data "azurerm_network_interface" "nic" {
  for_each            = var.nicbep
  name                = each.value.existing_nic_name
  resource_group_name = each.value.nic_resource_group_name
}
data "azurerm_lb" "lb" {
  for_each            = var.nicbep
  name                = each.value.existing_lb_name
  resource_group_name = each.value.lb_resource_group_name
}
data "azurerm_lb_backend_address_pool" "bep" {
  for_each        = var.nicbep
  name            = each.value.existing_bep_name
  loadbalancer_id = data.azurerm_lb.lb[each.key].id
}
