resource "azurerm_network_interface" "main" {
  for_each = var.components
  name                = "{each.key}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "{each.key}-nic"
    subnet_id                     = "/subscriptions/7ba54b86-56e1-4dd5-a544-23df4caeb2aa/resourceGroups/Denmark-east-rg/providers/Microsoft.Network/virtualNetworks/image-vm-vnet/subnets/default"
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id          = azurerm_public_ip.frontend.id
  }
}
resource "azurerm_linux_virtual_machine" "main" {
  for_each = var.components
  name                = "{each.key}"-vm
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = each.value
  #admin_username      = "adminuser"
  network_interface_ids = [
    #azurerm_network_interface.main.id, --> since we used for_each set here,Terraform doesn’t know which instance you mean, so we need to use azurerm_network_interface.main[each.key]
    azurerm_network_interface.main[each.key].id
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  admin_username = "devops"
  admin_password = "Devops@12345"
  disable_password_authentication = "false"

  source_image_id = var.image_id

  secure_boot_enabled = "true"
  vtpm_enabled = "true"

}

resource "azurerm_dns_a_record" "main" {
  for_each = var.components
  name                = "{each.key}-dev"
  zone_name           = "kubek8.online"
  resource_group_name = var.resource_group_name
  ttl                 = 30
  records             = [azurerm_network_interface.frontend[each.key].private_ip_address]
}

