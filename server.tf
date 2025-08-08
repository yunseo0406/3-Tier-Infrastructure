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
}

resource "ncloud_access_control_group_server" "web_attach" {
  count                   = var.web_count
  access_control_group_no = ncloud_access_control_group.web_acg.id 
  server_instance_no      = ncloud_server.web[count.index].id
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
}

resource "ncloud_access_control_group_server" "was_attach" {
  count                   = var.was_count
  access_control_group_no = ncloud_access_control_group.was.id
  server_instance_no      = ncloud_server.was[count.index].id
}