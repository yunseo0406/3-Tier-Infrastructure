###################################
# MYSQL
##################################

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

resource "ncloud_access_control_group_rule" "cdb_default_rules" {
  access_control_group_no = element(ncloud_mysql.mysql.access_control_group_no_list, 0)

  inbound {
    protocol   = "TCP"
    ip_block   = var.private_cidr
    port_range = "3306"
  }

  outbound {
    protocol   = "TCP"
    ip_block   = "0.0.0.0/0"
    port_range = "1-65535"
  }
}

resource "ncloud_mysql" "mysql" {
  subnet_no = ncloud_subnet.mysql_subnet.id
  service_name = "mysql"
  server_name_prefix = "mysql-server"
  user_name = "user1"
  user_password = "qwer1234!"
  host_ip = var.private_cidr
  database_name = "yunseo_db"
}

resource "ncloud_mysql_databases" "mysql_db" {
  mysql_instance_no = ncloud_mysql.mysql.id
  mysql_database_list = [
    {
      name = "testdb1"
    },
    {
      name = "testdb2"
    }
  ]
}