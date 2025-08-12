# 키 생성
resource "ncloud_login_key" "this" {
  key_name = "${var.project}-key-${formatdate("YYYYMMDDhhmmss", timestamp())}"
}