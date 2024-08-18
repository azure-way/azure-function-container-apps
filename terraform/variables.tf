variable "name_prefix" {
  description = "(Optional) A prefix for the name of all the resource groups and resources."
  type        = string
  nullable    = true
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
  default     = "WestEurope"
}

variable "resource_group_name" {
  description = "Name of the resource group in which the resources will be created"
  default     = "RG"
}

variable "tags" {
  description = "(Optional) Specifies tags for all the resources"
  default = {
    createdWith   = "Terraform",
    containerApps = "true"
  }
}

variable "log_analytics_workspace_name" {
  description = "Specifies the name of the log analytics workspace"
  default     = "Workspace"
  type        = string
}

variable "log_analytics_retention_days" {
  description = "Specifies the number of days of the retention policy for the log analytics workspace."
  type        = number
  default     = 30
}

variable "vnet_name" {
  description = "Specifies the name of the virtual network"
  default     = "VNet"
  type        = string
}

variable "vnet_address_space" {
  description = "Specifies the address prefix of the virtual network"
  default     = ["10.0.0.0/16"]
  type        = list(string)
}

variable "aca_subnet_name" {
  description = "Specifies the name of the subnet"
  default     = "ContainerApps"
  type        = string
}

variable "aca_subnet_address_prefix" {
  description = "Specifies the address prefix of the Azure Container Apps environment subnet"
  default     = ["10.0.0.0/20"]
  type        = list(string)
}

variable "container_app_environment_name" {
  description = "(Required) Specifies the name of the Azure Container Apps Environment."
  type        = string
  default     = "Environment"
}

variable "internal_load_balancer_enabled" {
  description = "(Optional) specifies whether the Azure Container Apps Environment operate in Internal Load Balancing Mode? Defaults to false. Changing this forces a new resource to be created."
  type        = bool
  default     = false
}

variable "acr_name" {
  description = "Specifies the name of the container registry"
  type        = string
  default     = "Registry"
}

variable "image_with_tag" {
  type        = string
  description = "The image with tag to use for the container application"

}

variable "subscription-id" {
  description = "Subscription for service principal"
}

variable "spn-client-id" {
  description = "Client ID of the service principal"
}

variable "spn-client-secret" {
  description = "Secret for service principal"
}

variable "spn-tenant-id" {
  description = "Tenant ID for service principal"
}
