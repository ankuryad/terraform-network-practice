provider "azurerm" {
  features {}
}


//Storage for state file


resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}



//HUB

resource "azurerm_resource_group" "rg" {
  name     = var.resourcegroup_name
  location = var.location
}

/*
resource "azurerm_resource_group" "rg" {
  count = 2
  name     = var.resourcegroup_name
  location = var.location
}
*/

resource "azurerm_virtual_network" "hub_vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  // address_space       = ["10.0.0.0/16"]
  address_space = [var.hub_vnet_prefix]

  tags = {
    environment = var.env
  }

}

resource "azurerm_subnet" "firewall_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  //address_prefixes     = ["10.0.0.0/26"]
  address_prefixes = [var.firewall_subnet_prefix]
}

resource "azurerm_public_ip" "firewall_ip" {
  name                = var.firewall_ip
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "Hub_firewall" {
  name                = var.hub_firewall
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_tier            = var.sku_tier
  sku_name            = var.sku_name


  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.firewall_ip.id
  }
}

// Spoke 2 Configuration

resource "azurerm_resource_group" "rgs2" {
  name     = var.resourcegroup_spokename2
  location = var.location
}

resource "azurerm_virtual_network" "spoke2_vnet" {
  name                = var.vnet_name_spoke2
  location            = azurerm_resource_group.rgs2.location
  resource_group_name = azurerm_resource_group.rgs2.name
  address_space       = [var.spoke2_address_space]
  tags = {
    environment = var.env
  }

}


resource "azurerm_subnet" "spoke2_subnet1" {
  count = length(var.spoke2_subnet1_name)
  //count = var.counter
  name                 = lookup(element(var.spoke2_subnet1_name, count.index), "name")
  resource_group_name  = azurerm_resource_group.rgs2.name
  virtual_network_name = azurerm_virtual_network.spoke2_vnet.name
  address_prefixes     = [lookup(element(var.spoke2_subnet1_name, count.index), "ip")]
  //address_prefixes = "${lookup(element(var.spoke2_subnet1_name, count.index), "ip")}"
  //address_prefixes = "${lookup(element(var.subnet1_prefix_spoke2, count.index), "ip")}"
}



/* 
resource "azurerm_subnet" "spoke2_subnet1" {
    name                 = var.spoke2_subnet1_name
    resource_group_name  = azurerm_resource_group.rgs2.name
    virtual_network_name = azurerm_virtual_network.spoke2_vnet.name
    address_prefixes     = [var.subnet1_prefix_spoke2]
}



resource "azurerm_subnet" "spoke2_subnet2" {
    name                 = var.spoke2_subnet2_name
    resource_group_name  = azurerm_resource_group.rgs2.name
    virtual_network_name = azurerm_virtual_network.spoke2_vnet.name
    address_prefixes     = [var.subnet2_prefix_spoke2]
}

*/


resource "time_sleep" "wait_for_azfirewall" {
  create_duration = "60s"

  depends_on = [azurerm_firewall.Hub_firewall]
}


data "azurerm_firewall" "firewall_data" {

  name                = var.hub_firewall
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = [time_sleep.wait_for_azfirewall]
}

/* 

output "firewall_private_ip" {
 // value = data.azurerm_firewall.firewall_data.hub_firewall.ip_configuration[0].private_ip_address
 value = data.azurerm_firewall.firewall_data.ip_configuration[0].private_ip_address
}

*/




resource "azurerm_route_table" "spoke2_route_table" {
  name                = var.spoke2_route_table_name
  location            = azurerm_resource_group.rgs2.location
  resource_group_name = azurerm_resource_group.rgs2.name

  route {
    name = var.route-hub-name
    //  next_hop_in_ip_address = data.azurerm_firewall.firewall_data.outputs.firewall_private_ip
    //  address_prefix = "10.0.0.0/16"
    //address_prefix         = "0.0.0.0/0"
    address_prefix         = var.next-hop-type-address-prefix
    next_hop_type          = var.next_hop_type-name
    next_hop_in_ip_address = data.azurerm_firewall.firewall_data.ip_configuration[0].private_ip_address
  }

  tags = {
    environment = var.env
  }
}


resource "azurerm_subnet_route_table_association" "subnet_route_map1" {
  count = length(var.spoke2_subnet1_name)
  // subnet_id      = "${azurerm_subnet.spoke2_subnet1[count.index].id}"
  subnet_id      = azurerm_subnet.spoke2_subnet1[count.index].id
  route_table_id = azurerm_route_table.spoke2_route_table.id
}

/*
resource "azurerm_subnet_route_table_association" "subnet_route_map2" {
  count = "${length(var.spoke2_subnet1_name)}"
  //subnet_id      = "${azurerm_subnet.spoke2_subnet1[count.index].id}"
  subnet_id      = azurerm_subnet.spoke2_subnet1[count.index].id
  route_table_id = azurerm_route_table.spoke2_route_table.id
}

*/

/* 

resource "azurerm_subnet_route_table_association" "subnet_route_map1" {
  subnet_id      = azurerm_subnet.spoke2_subnet1.id
  route_table_id = azurerm_route_table.spoke2_route_table.id
}

resource "azurerm_subnet_route_table_association" "subnet_route_map2" {
  subnet_id      = azurerm_subnet.spoke2_subnet2.id
  route_table_id = azurerm_route_table.spoke2_route_table.id
}

*/



resource "azurerm_virtual_network_peering" "spoke2-hub" {
  name                      = "spoke2hub"
  resource_group_name       = azurerm_resource_group.rgs2.name
  virtual_network_name      = azurerm_virtual_network.spoke2_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id
}

resource "azurerm_virtual_network_peering" "hub-spoke2" {
  name                      = "hubspoke2"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke2_vnet.id
}




