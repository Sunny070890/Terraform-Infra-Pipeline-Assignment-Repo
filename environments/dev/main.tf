module "rg" {
  source = "../../modules/azurerm_resource_group"
  rg     = var.rg
}
module "vnet" {
  source     = "../../modules/azurerm_networking/azurerm_vnet"
  vnet       = var.vnet
  depends_on = [module.rg]
}
module "subnet" {
  source     = "../../modules/azurerm_networking/azurerm_subnet"
  subnets    = var.subnets
  depends_on = [module.vnet]
}

module "nsg" {
  source     = "../../modules/azurerm_networking/azurerm_nsg"
  nsg        = var.nsg
  depends_on = [module.rg, module.subnet]
}
module "nsg_subnet_assoc" {
  source           = "../../modules/azurerm_associations/azurerm_subnet_nic_assoc"
  subnet_nsg_assoc = var.subnet_nsg_assoc
  depends_on       = [module.subnet, module.nsg]
}
module "nics" {
  source     = "../../modules/azurerm_networking/azurerm_nic"
  nics       = var.nics
  depends_on = [module.subnet]
}
module "vms" {
  source     = "../../modules/azurerm_compute/azurerm_virtual_machine"
  vm         = var.vm
  depends_on = [module.nics, module.subnet]
}
module "pip" {
  source     = "../../modules/azurerm_networking/azurerm_public_ip"
  pip        = var.pip
  depends_on = [module.rg]

}
module "lb" {
  source     = "../../modules/azurerm_load_balancer/azurerm_lb"
  lb         = var.lb
  depends_on = [module.pip, module.vms]
}
module "bep" {
  source     = "../../modules/azurerm_load_balancer/azurerm_backend_pool"
  bep        = var.bep
  depends_on = [module.lb]
}
module "nicbepassoc" {
  source     = "../../modules/azurerm_associations/azurerm_nic_bep_assoc"
  nicbep     = var.nicbep
  depends_on = [module.bep, module.nics]
}
module "health_probe_and_lb_rules" {
  source      = "../../modules/azurerm_load_balancer/azurerm_health_probe_and_rules"
  probe_rules = var.probe_rules
  depends_on  = [module.lb, module.bep]
}

module "outbound_rules" {
  source     = "../../modules/azurerm_load_balancer/azurerm_outbound_rule"
  out_rule   = var.out_rule
  depends_on = [module.health_probe_and_lb_rules]
}