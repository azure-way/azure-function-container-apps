variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Location in which to deploy the network"
  type        = string
}

variable "vnet_name" {
  description = "VNET name"
  type        = string
}

variable "address_space" {
  description = "VNET address space"
  type        = list(string)
}

variable "subnets" {
  description = "Subnets configuration"
  type = list(object({
    name                                          = string
    address_prefixes                              = list(string)
    private_endpoint_network_policies             = string
    private_link_service_network_policies_enabled = bool
    delegation                                    = list(string)
  }))
}

variable "network_peerings" {
  description = "Network peerings configuration"
  type = list(object({
    name                         = string
    remote_virtual_network_name  = string
    remote_virtual_network_id    = string
    remote_resource_group_name   = string
    allow_forwarded_traffic      = bool
    allow_gateway_transit        = bool
    allow_virtual_network_access = bool
  }))

  default = []
}

variable "tags" {
  description = "(Optional) Specifies the tags of the storage account"
  default     = {}
}

variable "log_analytics_workspace_id" {
  description = "Specifies the log analytics workspace id"
  type        = string
}

variable "log_analytics_retention_days" {
  description = "Specifies the number of days of the retention policy"
  type        = number
  default     = 7
}