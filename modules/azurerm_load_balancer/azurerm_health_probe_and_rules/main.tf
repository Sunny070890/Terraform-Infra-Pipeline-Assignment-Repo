resource "azurerm_lb_probe" "probe" {
  for_each        = var.probe_rules
  loadbalancer_id = data.azurerm_lb.lb[each.key].id
  name            = each.value.probe_name
  port            = each.value.port
}
resource "azurerm_lb_rule" "lbrule" {
  for_each                       = var.probe_rules
  loadbalancer_id                = data.azurerm_lb.lb[each.key].id
  name                           = each.value.lbrule_name
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  backend_address_pool_ids       = [data.azurerm_lb_backend_address_pool.bep[each.key].id]
  probe_id                       = azurerm_lb_probe.probe[each.key].id
  disable_outbound_snat          = true
}




data "azurerm_lb_backend_address_pool" "bep" {
  for_each        = var.probe_rules
  name            = each.value.existing_bep_name
  loadbalancer_id = data.azurerm_lb.lb[each.key].id
}


data "azurerm_lb" "lb" {
  for_each            = var.probe_rules
  name                = each.value.existing_lb_name
  resource_group_name = each.value.lb_resource_group_name
}
variable "probe_rules" {
  type = map(object({
    probe_name                     = string
    port                           = number
    lbrule_name                    = string
    protocol                       = string
    frontend_port                  = number
    backend_port                   = number
    frontend_ip_configuration_name = string
    existing_bep_name              = string
    existing_lb_name               = string
    lb_resource_group_name         = string
  }))
}
