//variable "seal_id" {
//    type = string
//    description = "SEAL ID"

//}

variable "resourcegroup_name" {
  type        = string
  description = "resource group name"
  default     = "HUB-resource-group"

}


/*
variable "resourcegroup_name" {
  type        = list
  description = "resource group name"
  default     = ["HUB-resource-group","Spoke2-resource-group"]

}
*/

variable "location" {
  type        = string
  description = "azure region"
  default     = "westus2"
}

variable "vnet_name" {
  type        = string
  description = "virtual network name"
  default     = "HUB-vnet"
}

variable "address_space" {
  type        = list(string)
  description = "vnet cidr"
  default     = ["10.0.0.0/16"]

}

variable "subnet_name" {
  type        = string
  description = "subnet name"
  default     = "AzureFirewallSubnet"

}

variable "subnet_prefix" {
  type        = string
  description = "subnet cidr"
  default     = "10.0.0.0/26"
}

variable "env" {
  type        = string
  description = "environment"
  default     = "dev"

}

variable "firewall_ip" {
  type        = string
  description = "firewall staic ip"
  default     = "firewallpip"

}

variable "hub_firewall" {
  type        = string
  description = "firewall name"
  default     = "Hub-vnet-firewall"

}

variable "sku_tier" {
  type        = string
  description = "firewall sku standard or premium"
  default     = "Premium"
}

variable "sku_name" {
  type        = string
  description = "firewall sku name"
  default     = "AZFW_VNet"

}

// Spoke Variables 

variable "resourcegroup_spokename2" {
  type        = string
  description = "spoke2 resource group name"
  default     = "SPOKE2-resource-group"

}

variable "vnet_name_spoke2" {
  type        = string
  description = " spoke2 virtual network name"
  default     = "SPOKE2-vnet"
}

variable "spoke2_address_space" {
  //   type = list(string)
  description = "spoke2 vnet cidr for spoke2"
  default     = "10.2.0.0/16"

}

variable "counter" {
  type        = string
  description = "spoke2 vnet cidr for spoke2"
  default     = "2"

}

variable "spoke2_subnet1_name" {
  type        = list(any)
  description = "subnet name"
  default = [
    { ip = "10.2.16.0/24"
    name = "spoke2-subnet1" },
    { ip = "10.2.0.0/20"
    name = "spoke2-subnet2" }
  ]
}

/*
variable "spoke2_subnet1_name" {
    type = list
    description = "subnet name"
    default = ["spoke2-subnet1", "spoke2-subnet2"]
        /*
        {name = "spoke2-subnet1", ip = "10.2.16.0/24"},
        {name = "spoke2-subnet2", ip = "10.2.0.0/20"}] 
}

variable "subnet1_prefix_spoke2" {
    type = list
    description = "subnet ip"
    default = ["10.2.0.0/20", "10.2.16.0/24"]
    /*
    default = [
        /*
        {name = "spoke2-subnet1", ip = "10.2.16.0/24"},
        {name = "spoke2-subnet2", ip = "10.2.0.0/20"}] 
}

*/
/*

variable "subnet1_prefix_spoke2" {
    type = list(string)
    description = "subnet ip"
    default = [   
        {name = "spoke2-subnet1", ip = "10.2.16.0/24"},
        {name = "spoke2-subnet2", ip = "10.2.0.0/20"}]
}

*/
/*

variable "spoke2_subnet1_name" {
    type = list(string)
    description = "subnet name"
    default = ["spoke2-subnet1","spoke2-subnet2"]
}

variable "subnet1_prefix_spoke2" {
    type = list(string)
    description = "subnet1 cidr for spoke2"
    default = ["10.2.16.0/24","10.2.0.0/20"]
}
*/

/*



variable "spoke2_subnet1_name" {
    type = string
    description = "subnet name"
    default = "spoke2-subnet1"
}

variable "subnet1_prefix_spoke2" {
    type = string
    description = "subnet1 cidr for spoke2"
    default = "10.2.16.0/24"
}

variable "spoke2_subnet2_name" {
    type = string
    description = "subnet name"
    default = "spoke2-subnet2"

}

variable "subnet2_prefix_spoke2" {
    type = string
    description = "subnet2 cidr for spoke2"
    default = "10.2.0.0/20"
}

*/

variable "spoke2_route_table_name" {
  type        = string
  description = "route table for spoke2"
  default     = "spoke2-route-table"
}
