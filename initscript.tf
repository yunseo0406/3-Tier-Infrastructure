# Web init script
resource "ncloud_init_script" "web_apache" {
  name        = "web-apache-init"
  content     = file("${path.module}/scripts/web-init.sh")
}

# WAS init script
resource "ncloud_init_script" "was_tomcat" {
  name        = "was-tomcat-init"
  content     = file("${path.module}/scripts/was-init.sh")
}
