resource "azurerm_linux_virtual_machine" "vm" {
  for_each                        = var.vm
  name                            = each.value.vm_name
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  size                            = each.value.size
  admin_username                  = each.value.admin_username
  admin_password                  = each.value.admin_password
  disable_password_authentication = false
  network_interface_ids           = [data.azurerm_network_interface.nic[each.key].id]
  dynamic "os_disk" {
    for_each = try(each.value.os_disks, {})
    content {
      caching              = os_disk.value.caching
      storage_account_type = os_disk.value.storage_account_type
    }
  }
  dynamic "source_image_reference" {
    for_each = try(each.value.source_image_references, {})
    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }
}
data "azurerm_network_interface" "nic" {
  for_each            = var.vm
  name                = each.value.existing_nic_name
  resource_group_name = each.value.nic_rg_name
}
