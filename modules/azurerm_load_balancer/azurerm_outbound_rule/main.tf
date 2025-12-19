resource "azurerm_lb_outbound_rule" "out_rule" {
  for_each                 = var.out_rule
  name                     = each.value.outbound_rule_name
  loadbalancer_id          = data.azurerm_lb.lb[each.key].id
  protocol                 = each.value.protocol
  backend_address_pool_id  = data.azurerm_lb_backend_address_pool.bep[each.key].id
  allocated_outbound_ports = 1024 # ⭐ REQUIRED FIELD

  dynamic "frontend_ip_configuration" {
    for_each = try(each.value.frontend_ip_configurations, {})
    content {
      name = frontend_ip_configuration.value.frontend_ip_configuration_name
    }
  }
}
data "azurerm_lb" "lb" {
  for_each            = var.out_rule
  name                = each.value.existing_lb_name
  resource_group_name = each.value.lb_resource_group_name

}
data "azurerm_lb_backend_address_pool" "bep" {
  for_each        = var.out_rule
  name            = each.value.existing_bep_name
  loadbalancer_id = data.azurerm_lb.lb[each.key].id
}
variable "out_rule" {
  type = map(object({
    outbound_rule_name     = string
    protocol               = string
    existing_lb_name       = string
    lb_resource_group_name = string
    existing_bep_name      = string
    frontend_ip_configurations = map(object({
      frontend_ip_configuration_name = string
    }))
  }))

}
