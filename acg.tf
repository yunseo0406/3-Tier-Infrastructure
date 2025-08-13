# Web ACG
resource "ncloud_access_control_group" "web_acg" {
  name   = "${var.project}-web-acg"
  vpc_no = ncloud_vpc.this.id
}

resource "ncloud_access_control_group_rule" "web_rule" {
  access_control_group_no = ncloud_access_control_group.web_acg.id

  inbound {
    protocol   = "TCP"
    ip_block   = "0.0.0.0/0"
    port_range = tostring(var.web_port)
  }

  inbound {
    protocol   = "TCP"
    ip_block   = "0.0.0.0/0"
    port_range = 22
  }

  inbound {
    protocol = "ICMP"
    ip_block = "0.0.0.0/0"
  }

  outbound {
    protocol   = "TCP"
    ip_block   = "0.0.0.0/0"
    port_range = "1-65535"
  }
}

# WAS ACG
resource "ncloud_access_control_group" "was_acg" {
  name   = "${var.project}-was-acg"
  vpc_no = ncloud_vpc.this.id
}

resource "ncloud_access_control_group_rule" "was_rules" {
  access_control_group_no = ncloud_access_control_group.was_acg.id

  inbound {
    protocol   = "TCP"
    ip_block   = var.private_lb_cidr
    port_range = "8080"
  }

  outbound {
    protocol   = "TCP"
    ip_block   = "0.0.0.0/0"
    port_range = "1-65535"
  }
}
