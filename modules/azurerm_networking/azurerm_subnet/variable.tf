variable "subnets" {
  type = map(object({
    subnet_name                   = string
    resource_group_name           = string
    existing_virtual_network_name = string
    address_prefixes              = list(string)


  }))
}
