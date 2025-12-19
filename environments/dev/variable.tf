variable "rg" {
  type = map(object({
    rg_name     = string
    rg_location = string
    tags        = optional(map(string))
  }))
}
variable "vnet" {
  type = map(object({
    vnet_name           = string
    location            = string
    resource_group_name = string
    address_space       = optional(list(string))
    dns_servers         = optional(list(string))
  }))
}
variable "subnets" {
  type = map(object({
    subnet_name                   = string
    resource_group_name           = string
    existing_virtual_network_name = string
    address_prefixes              = list(string)


  }))
}

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
variable "subnet_nsg_assoc" {
  type = map(object({
    existing_subnet_name       = string
    existing_vnet_name         = string
    subnet_resource_group_name = string
    existing_nsg_name          = string
    nsg_resource_group_name    = string
  }))
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
variable "vm" {
  type = map(object({
    vm_name             = string
    resource_group_name = string
    location            = string
    size                = string
    admin_username      = string
    admin_password      = string
    existing_nic_name   = string
    nic_rg_name         = string
    os_disks = map(object({
      caching              = string
      storage_account_type = string
    }))
    source_image_references = map(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    }))
  }))
}
variable "pip" {
  type = map(object({
    pip_name            = string
    resource_group_name = string
    location            = string
    allocation_method   = string
  }))
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
variable "bep" {
  type = map(object({
    bep_name               = string
    existing_lb_name       = string
    lb_resource_group_name = string

  }))
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
variable "probe" {
  type = map(object({
    probe_name             = string
    port                   = number
    existing_lb_name       = string
    lb_resource_group_name = string

  }))
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