variable "nsg" {
  type = map(object({
    nsg_name            = string
    location            = string
    resource_group_name = string
    security_rules = optional(map(object({
      security_rule_name         = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = optional(string)
      destination_port_range     = optional(string)
      source_address_prefix      = optional(string)
      destination_address_prefix = optional(string)
    })))
  }))
}