resource "azurerm_azuread_application" "admin" {
  name                       = "${var.env_name}"
}
resource "azurerm_azuread_service_principal" "admin" {
  application_id = "${azurerm_azuread_application.admin.application_id}"
}

resource "random_string" "password" {
  length = 20
  special = true
  override_special = "/@\" "
  keepers = {
    service_principal = "${azurerm_azuread_service_principal.admin.id}"
  }
}
resource "azurerm_azuread_service_principal_password" "admin" {
  service_principal_id = "${azurerm_azuread_service_principal.admin.id}"
  value                = "${random_string.password.result}"
  end_date             = "${timeadd(timestamp(), "8760h")}"
  lifecycle {
    ignore_changes = ["end_date"]
  }
}

resource "azurerm_kubernetes_cluster" "admin" {
  name                = "${var.env_name}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.admin.name}"
  dns_prefix          = "${var.env_name}"
  kubernetes_version = "${var.admin_k_ver}"
  /*this is not correct , separate service principal must be created https://docs.microsoft.com/en-us/azure/aks/aad-integration
  role_based_access_control {
    azure_active_directory {
      client_app_id     = "${azurerm_azuread_service_principal.admin.application_id}"
      server_app_id     = "${azurerm_azuread_service_principal.admin.id}"
      server_app_secret = "${random_string.password.result}"
    }
  }*/

  agent_pool_profile {
    name            = "default"
    count           = 2
    vm_size         = "Standard_DS2_v2"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${azurerm_azuread_service_principal.admin.application_id}"
    client_secret = "${random_string.password.result}"
  }

  tags {
    Environment = "${var.env_name}"
  }
}
