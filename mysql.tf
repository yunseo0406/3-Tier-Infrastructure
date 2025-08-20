###################################
# MYSQL
###################################
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