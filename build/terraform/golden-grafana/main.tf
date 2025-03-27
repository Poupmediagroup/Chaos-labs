resource "azurerm_dev_test_virtual_machine" "dtl_vm" {
  name                = "my-dtl-vm"
  lab_name            = var.lab_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size

  # Reference the Packer image from DevTest Labs
  lab_virtual_machine_create_option = "FromCustomImage"
  lab_custom_image_id               = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.DevTestLab/labs/${var.lab_name}/customimages/${var.image_name}"

  network_interface {
    name    = "${var.vm_name}-nic"
    shared_public_ip_address = false
  }

}

