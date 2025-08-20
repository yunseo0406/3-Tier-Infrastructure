# server image and spec data sources
data "ncloud_server_image_numbers" "kvm-image" {
  server_image_name = "ubuntu-22.04-base"
  filter {
    name = "hypervisor_type"
    values = ["KVM"]
  }
}

data "ncloud_server_specs" "kvm-spec" {
  filter {
    name   = "server_spec_code"
    values = ["s2-g3"]
  }
}

###################################
# Web Servers (Public)
###################################
resource "ncloud_server" "web" {
  count                     = var.web_count
  name                      = "${var.project}-web-${count.index + 1}"
  subnet_no                 = ncloud_subnet.public.id
  server_image_number       = data.ncloud_server_image_numbers.kvm-image.image_number_list.0.server_image_number
  server_spec_code          = data.ncloud_server_specs.kvm-spec.server_spec_list.0.server_spec_code
  login_key_name            = ncloud_login_key.this.key_name

  network_interface {
    network_interface_no = ncloud_network_interface.web_nic.id
    order                = 0
  }
}

resource "ncloud_network_interface" "web_nic" {
  name                  = "web-nic"
  subnet_no             = ncloud_subnet.public.id
  access_control_groups = [ncloud_access_control_group.web_acg.id]
}
# 공인 ip
resource "ncloud_public_ip" "web_eip" {
  server_instance_no = ncloud_server.web.id
}

###################################
# WAS Servers (Private)
###################################
resource "ncloud_server" "was" {
  count                     = var.was_count
  name                      = "${var.project}-was-${count.index + 1}"
  subnet_no                 = ncloud_subnet.private.id
  server_image_number       = data.ncloud_server_image_numbers.kvm-image.image_number_list.0.server_image_number
  server_spec_code          = data.ncloud_server_specs.kvm-spec.server_spec_list.0.server_spec_code
  login_key_name            = ncloud_login_key.this.key_name

  network_interface {
    network_interface_no = ncloud_network_interface.was_nic.id
    order                = 0
  }
}

resource "ncloud_network_interface" "was_nic" {
  name                  = "was-nic"
  subnet_no             = ncloud_subnet.private.id
  access_control_groups = [ncloud_access_control_group.was_acg.id]
}
