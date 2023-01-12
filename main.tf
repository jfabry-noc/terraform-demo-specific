resource "aws_instance" "terraform-demo-1" {
  ami           = var.ami-1
  instance_type = var.instance_type-1
  key_name      = "ray-demo"

  user_data = file("user-data-script.sh")

  tags = {
    Name             = "terraform-demo-1"
    turbo_owner      = "Ray.Mileo@ibm.com"
    Terraform_Config = "https://github.com/turbonomic-integrations/terraform-demo/blob/main/terraform.tfvars::instance_type-1"
  }
}

resource "aws_instance" "astra-test" {
  ami           = var.ami-2
  instance_type = var.instance_type-4
  key_name      = "ray-demo"

  user_data = file("user-data-script.sh")

  tags = {
    Name             = "astra-test"
    turbo_owner      = "tester@test.com"
    Terraform_Config = "https://github.com/turbonomic-integrations/terraform-demo/blob/main/terraform.tfvars::instance_type-3"
  }
}

resource "azurerm_virtual_machine" "vm_linux" {
  count = !contains(tolist([
    var.vm_os_simple, var.vm_os_offer
  ]), "WindowsServer") && !var.is_windows_image ? var.nb_instances : 0

  location                         = local.location
  name                             = "${var.vm_hostname}-vmLinux-${count.index}"
  network_interface_ids            = [element(azurerm_network_interface.vm[*].id, count.index)]
  resource_group_name              = var.resource_group_name
  vm_size                          = var.azure_vm_size
  availability_set_id              = var.zone == null ? azurerm_availability_set.vm[0].id : null
  delete_data_disks_on_termination = var.delete_data_disks_on_termination
  delete_os_disk_on_termination    = var.delete_os_disk_on_termination
  tags = {
    Name        = "jfabry-actions-test"
    turbo_owner = "tester@test.com"
  }
  zones = var.zone == null ? null : [var.zone]
}

resource "google_compute_instance" "default" {
  name         = "RayTest-VM01"
  machine_type = var.gcp_vm_size
  zone         = "us-west1-a"
  tags = {
    Name        = "RayTest-VM01"
    turbo_owner = "tester@test.com"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.default.id
  }
}
