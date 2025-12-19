variable "vm" {
  type = map(object({
    vm_name             = string
    resource_group_name = string
    location            = string
    size                = string
    admin_username      = string
    admin_password     = string
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