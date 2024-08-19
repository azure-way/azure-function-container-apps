data "azurerm_client_config" "current" {
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.name_prefix}-app-rg"
  location = var.location
  tags     = var.tags
}

module "log_analytics_workspace" {
  source              = "./modules/log_analytics"
  name                = "${var.name_prefix}-law"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

module "virtual_network" {
  source                       = "./modules/virtual_network"
  resource_group_name          = azurerm_resource_group.rg.name
  vnet_name                    = "${var.name_prefix}-vnet"
  location                     = var.location
  address_space                = var.vnet_address_space
  tags                         = var.tags
  log_analytics_workspace_id   = module.log_analytics_workspace.id
  log_analytics_retention_days = var.log_analytics_retention_days

  subnets = [
    {
      name : var.aca_subnet_name
      address_prefixes : var.aca_subnet_address_prefix
      private_endpoint_network_policies : "Enabled"
      private_link_service_network_policies_enabled : false
      delegation = ["Microsoft.App/environments"]
    }
  ]
}

resource "null_resource" "build_docker_image" {
  provisioner "local-exec" {
    command = "cd ../azure_function && docker build --platform linux/amd64 -t ${module.container_registry.login_server}/${var.image_with_tag} ."
  }
}

resource "null_resource" "push_docker_image" {
  provisioner "local-exec" {
    command = "docker login -p ${module.container_registry.admin_password} -u ${module.container_registry.admin_username} ${module.container_registry.login_server} && docker push ${module.container_registry.login_server}/${var.image_with_tag}"
  }

  depends_on = [ null_resource.build_docker_image, azurerm_role_assignment.acrpush_current_user ]
}

resource "azurerm_user_assigned_identity" "managed_identity" {
  name                = "${var.name_prefix}-mi"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_role_assignment" "acrpull_mi" {
  scope                = module.container_registry.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.managed_identity.principal_id
}

resource "azurerm_role_assignment" "acrpush_current_user" {
  scope                = module.container_registry.id
  role_definition_name = "AcrPush"
  principal_id         = data.azurerm_client_config.current.object_id
}

module "container_registry" {
  source = "./modules/container_registry"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  name = "${var.name_prefix}acr"

  admin_enabled = true
  sku           = "Basic"

  log_analytics_workspace_id = module.log_analytics_workspace.id

  tags = var.tags
}

module "container_app_environment" {
  source                         = "./modules/container_app_environment"
  name                           = "${var.name_prefix}-cae"
  location                       = var.location
  resource_group_name            = azurerm_resource_group.rg.name
  tags                           = var.tags
  infrastructure_subnet_id       = module.virtual_network.subnet_ids[var.aca_subnet_name]
  internal_load_balancer_enabled = var.internal_load_balancer_enabled
  log_analytics_workspace_id     = module.log_analytics_workspace.id

  workload_profiles = [
    {
      name                  = "Consumption"
      workload_profile_type = "Consumption"
      maximum_count         = 0
      minimum_count         = 0
    }
  ]
}

resource "azurerm_storage_account" "data_storage" {
  name                     = "${var.name_prefix}fusa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

resource "azurerm_storage_container" "example" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.data_storage.name
  container_access_type = "private"
}

module "azfunction_app" {
  source = "./modules/container_app"

  resource_group_name          = azurerm_resource_group.rg.name
  
  name_prefix                  = "${var.name_prefix}-blob-trigger"
  
  container_app_environment_id = module.container_app_environment.id
  
  image                        = var.image_with_tag
  container_registry_url       = module.container_registry.login_server
  principal_id                 = azurerm_user_assigned_identity.managed_identity.id
  
  container_name               = "azure-function"
  min_replicas = 1
  max_replicas = 1

  target_port = 80

  env_vars = {
    AzureWebJobsIndexDataStorageConnection = azurerm_storage_account.data_storage.primary_blob_connection_string
    AzureWebJobsStorage                    = azurerm_storage_account.data_storage.primary_blob_connection_string
    AzureWebJobsFeatureFlags               = "EnableWorkerIndexing"
  }

  tags = {
    Purpose = "BlobTrigger"
    Type    = "AzureFunction"
  }

  depends_on = [null_resource.push_docker_image]
}

