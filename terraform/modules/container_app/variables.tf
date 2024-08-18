variable "name_prefix" {
  description = "Prefix for naming the container app"
  type        = string
}

variable "container_app_environment_id" {
  description = "The ID of the Container App environment"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "image" {
  description = "Version tag for the front application container image"
  type        = string
}

variable "env_vars" {
  description = "A map of environment variables for the container"
  type        = map(string)
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "target_port" {
  description = "The port that the container listens on"
  type        = number

}

variable "container_name" {
  description = "Specifies the name of the container"
  type        = string

}

variable "principal_id" {
  description = "Specifies the principal id"
  type        = string

}

variable "container_registry_url" {
  description = "Specifies the URL of the container registry"
  type        = string

}

variable "min_replicas" {
  description = "Specifies the minimum number of replicas"
  type        = number
  default     = 1
  
}

variable "max_replicas" {
  description = "Specifies the maximum number of replicas"
  type        = number
  default     = 1
  
}