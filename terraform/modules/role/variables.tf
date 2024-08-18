variable "principal_id" {
  description = "The ID of the principal (user, group, service principal, etc.)"
  type        = string
}

variable "principal_type" {
  description = "The type of the principal (User, Group, ServicePrincipal, etc.)"
  type        = string
  default     = "ServicePrincipal"
  validation {
    condition     = contains(["Device", "ForeignGroup", "Group", "ServicePrincipal", "User"], var.principal_type)
    error_message = "principal_type must be one of 'Device', 'ForeignGroup', 'Group', 'ServicePrincipal', or 'User'."
  }
}

variable "role_definition_name" {
  description = "The ID of the role definition (role) to assign."
  type        = string
}

variable "scope_id" {
  description = "The ID of the scope."
  type        = string
}