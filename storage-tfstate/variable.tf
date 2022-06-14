
variable "resouregroup_name_storage" {
  type        = string
  description = "Resource Group name for storage"
  default     = "tfstate"
}

variable "storage_tier" {
  type        = string
  description = "Tier for storage"
  default     = "Standard"

}

variable "st_account_name" {
  type        = string
  description = "storage account name"
  default     = "mystorageank5647"

}

variable "st_account_replication_type" {
  type        = string
  description = "Replcation type for storage"
  default     = "LRS"

}

variable "st_container_name" {
  type        = string
  description = "Resource Group name for container"
  default     = "tfstate"
}

variable "st_container_access_type" {
  type        = string
  description = "Resource Group name for container"
  default     = "blob"
}


variable "location" {
  type        = string
  description = "azure region"
  default     = "westus2"
}

variable "env" {
  type        = string
  description = "environment"
  default     = "dev"

}