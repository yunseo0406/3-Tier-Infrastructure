###################################
# VPC & Subnets
###################################
resource "ncloud_vpc" "this" {
  name            = "${var.project}-vpc"
  ipv4_cidr_block = var.vpc_cidr
}

# Public Subnet (Web)
resource "ncloud_subnet" "public" {
  name           = "${var.project}-pub"
  vpc_no         = ncloud_vpc.this.id
  subnet         = var.public_cidr
  zone           = var.zone
  subnet_type    = "PUBLIC"
  usage_type     = "GEN"
  network_acl_no = ncloud_vpc.this.default_network_acl_no
}

# Private Subnet (WAS)
resource "ncloud_subnet" "private" {
  name           = "${var.project}-priv"
  vpc_no         = ncloud_vpc.this.id
  subnet         = var.private_cidr
  zone           = var.zone
  subnet_type    = "PRIVATE"
  usage_type     = "GEN"
  network_acl_no = ncloud_vpc.this.default_network_acl_no
}

# External LB 전용 Subnet (Public)
resource "ncloud_subnet" "public_lb" {
  name           = "${var.project}-pub-lb"
  vpc_no         = ncloud_vpc.this.id
  subnet         = var.public_lb_cidr
  zone           = var.zone
  subnet_type    = "PUBLIC"
  usage_type     = "LOADB"
  network_acl_no = ncloud_vpc.this.default_network_acl_no
}

# Internal LB 전용 Subnet (Private)
resource "ncloud_subnet" "private_lb" {
  name           = "${var.project}-priv-lb"
  vpc_no         = ncloud_vpc.this.id
  subnet         = var.private_lb_cidr
  zone           = var.zone
  subnet_type    = "PRIVATE"
  usage_type     = "LOADB"
  network_acl_no = ncloud_vpc.this.default_network_acl_no
}
