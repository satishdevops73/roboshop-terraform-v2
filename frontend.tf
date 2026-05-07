resource "azurerm_public_ip" "frontend" {
  name                = "frontend-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  domain_name_label   = "youruniquename123"
}

resource "azurerm_network_interface" "frontend" {
  name                = "frontend-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "frontend-nic"
    subnet_id                     = "/subscriptions/7ba54b86-56e1-4dd5-a544-23df4caeb2aa/resourceGroups/Denmark-east-rg/providers/Microsoft.Network/virtualNetworks/image-vm-vnet/subnets/default"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.frontend.id
  }
}
resource "azurerm_linux_virtual_machine" "frontend" {
  name                = "frontend-vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B1s"
  #admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.frontend.id,
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

resource "azurerm_dns_a_record" "frontend" {
  name                = "frontend-dev"
  zone_name           = "kubek8.online"
  resource_group_name = var.resource_group_name
  ttl                 = 30
  records             = [azurerm_network_interface.frontend.private_ip_address]
}