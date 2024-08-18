# For Azure OpenAI

module "openai_role_user" {
  scope_id             = var.core_ai_resource_group_id
  source               = "../role"
  principal_id         = var.principal_id
  role_definition_name = "Storage Blob Data Reader"
  principal_type       = var.principal_type
}

# For both document intelligence and computer vision
module "cognitiveservices_role_user" {
  scope_id             = var.core_ai_resource_group_id
  source               = "../role"
  principal_id         = var.principal_id
  role_definition_name = "Cognitive Services User"
  principal_type       = var.principal_type
}

module "storage_role_user" {
  scope_id             = var.app_resource_group_id
  source               = "../role"
  principal_id         = var.principal_id
  role_definition_name = "Storage Blob Data Reader"
  principal_type       = var.principal_type
}

module "storage_contrib_role_user" {
  scope_id             = var.app_resource_group_id
  source               = "../role"
  principal_id         = var.principal_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_type       = var.principal_type
}

module "search_role_user" {
  scope_id             = var.core_ai_resource_group_id
  source               = "../role"
  principal_id         = var.principal_id
  role_definition_name = "Search Index Data Reader"
  principal_type       = var.principal_type
}

module "search_contrib_role_user" {
  scope_id             = var.core_ai_resource_group_id
  source               = "../role"
  principal_id         = var.principal_id
  role_definition_name = "Search Index Data Contributor"
  principal_type       = var.principal_type
}

module "search_svc_contrib_role_user" {
  scope_id             = var.core_ai_resource_group_id
  source               = "../role"
  principal_id         = var.principal_id
  role_definition_name = "Search Service Contributor"
  principal_type       = var.principal_type
}

# SYSTEM IDENTITIES
module "search_svc_contrib_role_managed_identity" {
  scope_id             = var.core_ai_resource_group_id
  source               = "../role"
  principal_id         = var.back_principal_id
  role_definition_name = "Search Service Contributor"
  principal_type       = "ServicePrincipal"
}

module "storaga_blob_data_reader" {
  scope_id             = var.core_ai_resource_group_id
  source               = "../role"
  principal_id         = var.back_principal_id
  role_definition_name = "Storage Blob Data Reader"
  principal_type       = "ServicePrincipal"
}

module "openai_role_backend" {
  scope_id             = var.core_ai_resource_group_id
  source               = "../role"
  principal_id         = var.back_principal_id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_type       = "ServicePrincipal"
}

module "ai_search_contributor" {
  scope_id             = var.core_ai_resource_group_id
  source               = "../role"
  principal_id         = var.back_principal_id
  role_definition_name = "Search Index Data Contributor"
  principal_type       = "ServicePrincipal"
}


module "storage_role_backend" {
  scope_id             = var.app_resource_group_id
  source               = "../role"
  principal_id         = var.back_principal_id
  role_definition_name = "Storage Blob Data Reader"
  principal_type       = "ServicePrincipal"
}

module "search_role_backend" {
  scope_id             = var.core_ai_resource_group_id
  source               = "../role"
  principal_id         = var.back_principal_id
  role_definition_name = "Search Index Data Reader"
  principal_type       = "ServicePrincipal"
}