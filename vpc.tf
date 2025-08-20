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

# MYSQL Subnet
resource "ncloud_subnet" "mysql_subnet" {
  name           = "${var.project}-cdb-subnet"
  vpc_no         = ncloud_vpc.this.id
  subnet         = var.db_subnet_cidr
  zone           = var.zone
  subnet_type    = "PRIVATE"
  usage_type     = "GEN"
  network_acl_no = ncloud_vpc.this.default_network_acl_no
}

#####################################
# Nat Gateway
#####################################
resource "ncloud_subnet" "natgw_subnet" {
  name           = "${var.project}-natgw-subnet"
  vpc_no         = ncloud_vpc.this.id
  subnet         = var.natgw_cidr
  zone           = var.zone
  network_acl_no = ncloud_vpc.this.default_network_acl_no
  subnet_type    = "PUBLIC"
  usage_type     = "NATGW"
}
resource "ncloud_nat_gateway" "nat_gateway" {
  vpc_no      = ncloud_vpc.this.id
  subnet_no   = ncloud_subnet.natgw_subnet.id
  zone        = var.zone
  name        = "nat-gw"
}
resource "ncloud_route_table" "private_rt" {
  vpc_no                = ncloud_vpc.this.id  
  supported_subnet_type = "PRIVATE" 
  name                  = "route-table"
}
resource "ncloud_route" "nat_default" {
  route_table_no         = ncloud_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  target_type            = "NATGW"  
  target_name            = ncloud_nat_gateway.nat_gateway.name
  target_no              = ncloud_nat_gateway.nat_gateway.id
}
resource "ncloud_route_table_association" "route_table_subnet" {
    route_table_no        = ncloud_route_table.private_rt.id
    subnet_no             = ncloud_subnet.private.id
}