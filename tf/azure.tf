resource "azurerm_resource_group" "admin" {
  name     = "${var.env_name}"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.env_name}"
  location            = "${var.location}"
  address_space       = ["${var.address_space}"]
  resource_group_name = "${azurerm_resource_group.admin.name}"
  dns_servers         = "${var.dns_servers}"
  tags                = "${var.tags}"
}
resource "azurerm_subnet" "subnet" {
  name                 = "${var.subnet_names[count.index]}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.admin.name}"
  address_prefix       = "${var.subnet_prefixes[count.index]}"
  count                = "${length(var.subnet_names)}"
}