###################################
# Web Servers (Public)
###################################
resource "ncloud_server" "web" {
  count                = var.web_count
  name                 = "${var.project}-web-${count.index + 1}"
  subnet_no            = ncloud_subnet.public.id
  server_image_product_code = var.server_image_number
  server_product_code  = var.web_spec_code
  login_key_name       = ncloud_login_key.this.key_name
  network_interface   {
      network_interface_no = ncloud_network_interface.web_nic.id
      order = 0
  }
}

resource "ncloud_network_interface" "web_nic" {
	name                  = "web-nic"
	subnet_no             = ncloud_subnet.public.id
	access_control_groups = [ncloud_access_control_group.web_acg.id]
}

###################################
# WAS Servers (Private)
###################################
resource "ncloud_server" "was" {
  count                = var.was_count
  name                 = "${var.project}-was-${count.index + 1}"
  subnet_no            = ncloud_subnet.private.id
  server_image_product_code = var.server_image_number
  server_product_code  = var.was_spec_code
  login_key_name       = ncloud_login_key.this.key_name
  network_interface   {
      network_interface_no = ncloud_network_interface.was_nic.id
      order = 0
  }
}

resource "ncloud_network_interface" "was_nic" {
	name                  = "was-nic"
	subnet_no             = ncloud_subnet.private.id
	access_control_groups = [ncloud_access_control_group.was_acg.id]
}