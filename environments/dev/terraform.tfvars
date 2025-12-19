rg = {
  rg1 = {
    rg_name     = "rg-bdy"
    rg_location = "eastus2"
    tags = {
      owner = "sk"
      env   = "dev"
    }
  }
}
vnet = {
  vnet1 = {
    vnet_name           = "bdyvnet"
    location            = "eastus2"
    resource_group_name = "rg-bdy"
    address_space       = ["10.0.0.0/16"]
    dns_servers         = ["10.0.0.4", "10.0.0.5"]
  }
}
subnets = {
  fesubnet = {
    subnet_name                   = "FEbdysubnet"
    resource_group_name           = "rg-bdy"
    existing_virtual_network_name = "bdyvnet"
    address_prefixes              = ["10.0.1.0/24"]

  }
  besubnet = {
    subnet_name                   = "BEbdysubnet"
    resource_group_name           = "rg-bdy"
    existing_virtual_network_name = "bdyvnet"
    address_prefixes              = ["10.0.3.0/24"]

  }
  subnet2 = {
    subnet_name                   = "AzureBastionSubnet"
    resource_group_name           = "rg-bdy"
    existing_virtual_network_name = "bdyvnet"
    address_prefixes              = ["10.0.2.0/24"]

  }
}
nsg = {
  nsg_bastion = {
    nsg_name            = "BASTIONNSG"
    location            = "eastus2"
    resource_group_name = "rg-bdy"
    security_rules = {
      inbound_https = {
        security_rule_name         = "Allow-HTTPS"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
      }

      inbound_control = {
        security_rule_name         = "Allow-Bastion-Control"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "4443"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
      }

      outbound_azurecloud = {
        security_rule_name         = "Allow-AzureCloud"
        priority                   = 120
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "AzureCloud"
      }

      outbound_rdp = {
        security_rule_name         = "Allow-RDP"
        priority                   = 130
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }

      outbound_ssh = {
        security_rule_name         = "Allow-SSH"
        priority                   = 140
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    }
  }

  nsg_fe = {
    nsg_name            = "FENSG"
    location            = "eastus2"
    resource_group_name = "rg-bdy"
    security_rules = {
      allow_ssh = {
        security_rule_name         = "Allow-SSH-From-VNET"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "*"
      }
      allow_http = {
        security_rule_name         = "Allow-HTTP"
        priority                   = 120
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
      }
    }
  }
  nsg_be = {
    nsg_name            = "BENSG"
    location            = "eastus2"
    resource_group_name = "rg-bdy"
    security_rules = {
      allow_ssh = {
        security_rule_name         = "Allow-SSH-From-VNET"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "*"
      }
      allow_http = {
        security_rule_name         = "Allow-HTTP"
        priority                   = 120
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
      }
    }
  }
}
subnet_nsg_assoc = {
  subnsg_assoc_fe = {
    existing_subnet_name       = "FEbdysubnet"
    existing_vnet_name         = "bdyvnet"
    subnet_resource_group_name = "rg-bdy"
    existing_nsg_name          = "FENSG"
    nsg_resource_group_name    = "rg-bdy"
  }
  subnsg_assoc_be = {
    existing_subnet_name       = "BEbdysubnet"
    existing_vnet_name         = "bdyvnet"
    subnet_resource_group_name = "rg-bdy"
    existing_nsg_name          = "BENSG"
    nsg_resource_group_name    = "rg-bdy"
  }
  subnsg_assoc_bastion = {
    existing_subnet_name       = "AzureBastionSubnet"
    existing_vnet_name         = "bdyvnet"
    subnet_resource_group_name = "rg-bdy"
    existing_nsg_name          = "BASTIONNSG"
    nsg_resource_group_name    = "rg-bdy"
  }
}
nics = {
  fenic = {
    nic_name                            = "FENIC"
    location                            = "eastus2"
    resource_group_name                 = "rg-bdy"
    existing_subnet_name                = "FEbdysubnet"
    existing_virtual_network_name       = "bdyvnet"
    existing_subnet_resource_group_name = "rg-bdy"
    ip_configurations = {
      ipconfig1 = {
        ip_configuration_name         = "ipconfigbdyfe"
        private_ip_address_allocation = "Dynamic"
      }
    }
  }
  benic = {
    nic_name                            = "BENIC"
    location                            = "eastus2"
    resource_group_name                 = "rg-bdy"
    existing_subnet_name                = "BEbdysubnet"
    existing_virtual_network_name       = "bdyvnet"
    existing_subnet_resource_group_name = "rg-bdy"
    ip_configurations = {
      ipconfig1 = {
        ip_configuration_name         = "ipconfigbdybe"
        private_ip_address_allocation = "Dynamic"
      }
    }
  }
}
vm = {
  fevm = {
    vm_name             = "FEVM"
    resource_group_name = "rg-bdy"
    location            = "eastus2"
    size                = "Standard_D2s_v3"
    admin_username      = "username"
    admin_password      = "birthday@123"
    existing_nic_name   = "FENIC"
    nic_rg_name         = "rg-bdy"
    os_disks = {
      disck1 = {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
      }
    }
    source_image_references = {
      source_image_references1 = {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
      }
    }
  }
  bevm = {
    vm_name             = "BEVM"
    resource_group_name = "rg-bdy"
    location            = "eastus2"
    size                = "Standard_D2s_v3"
    admin_username      = "username"
    admin_password      = "birthday@123"
    existing_nic_name   = "BENIC"
    nic_rg_name         = "rg-bdy"
    os_disks = {
      disck1 = {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
      }
    }
    source_image_references = {
      source_image_references1 = {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
      }
    }
  }
}
pip = {
  lbpip = {
    pip_name            = "BDYPIP"
    resource_group_name = "rg-bdy"
    location            = "eastus2"
    allocation_method   = "Static"
  }
}
lb = {
  lb = {
    lbname                  = "BDYLB"
    location                = "eastus2"
    resource_group_name     = "rg-bdy"
    existing_pip_name       = "BDYPIP"
    pip_resource_group_name = "rg-bdy"
    frontend_ip_configurations = {
      frontend_ip_configurations1 = {
        frontend_ip_configuration_name = "PublicIPAddress"
      }
    }
  }
}
bep = {
  bep1 = {
    bep_name               = "BDYBEP"
    existing_lb_name       = "BDYLB"
    lb_resource_group_name = "rg-bdy"
  }
}
nicbep = {
  nicbep1 = {
    nic_ip_configuration_name = "ipconfigbdyfe"
    existing_nic_name         = "FENIC"
    nic_resource_group_name   = "rg-bdy"
    existing_lb_name          = "BDYLB"
    lb_resource_group_name    = "rg-bdy"
    existing_bep_name         = "BDYBEP"
  }
  nicbep2 = {
    nic_ip_configuration_name = "ipconfigbdybe"
    existing_nic_name         = "BENIC"
    nic_resource_group_name   = "rg-bdy"
    existing_lb_name          = "BDYLB"
    lb_resource_group_name    = "rg-bdy"
    existing_bep_name         = "BDYBEP"
  }
}
probe = {
  lbrule1 = {
    probe_name             = "BDYPROBE"
    port                   = 80
    existing_lb_name       = "BDYLB"
    lb_resource_group_name = "rg-bdy"
  }
}
probe_rules = {
  probe_rules1 = {
    probe_name                     = "BDYPROBE"
    port                           = 80
    lbrule_name                    = "BDYRULE"
    protocol                       = "Tcp"
    frontend_port                  = 80
    backend_port                   = 80
    frontend_ip_configuration_name = "PublicIPAddress"
    existing_bep_name              = "BDYBEP"
    existing_lb_name               = "BDYLB"
    lb_resource_group_name         = "rg-bdy"
  }
}
out_rule = {
  out_rule1 = {
    outbound_rule_name     = "BDYOUTRULE"
    protocol               = "Tcp"
    existing_lb_name       = "BDYLB"
    lb_resource_group_name = "rg-bdy"
    existing_bep_name      = "BDYBEP"
    frontend_ip_configurations = {
      fip1 = {
        frontend_ip_configuration_name = "PublicIPAddress"
      }
    }
  }
}
