resource "azurerm_lb_backend_address_pool" "example" {
  for_each        = var.bep
  loadbalancer_id = data.azurerm_lb.lb[each.key].id
  name            = each.value.bep_name
}
data "azurerm_lb" "lb" {
  for_each            = var.bep
  name                = each.value.existing_lb_name
  resource_group_name = each.value.lb_resource_group_name
}

variable "bep" {
  type = map(object({
    bep_name               = string
    existing_lb_name       = string
    lb_resource_group_name = string

  }))
}
