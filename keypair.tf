# 키 생성
resource "ncloud_login_key" "this" {
  key_name = "${var.project}-key-${formatdate("YYYYMMDDhhmmss", timestamp())}"
}

# 생성된 private_key를 .pem 파일로 저장
resource "local_file" "login_key_pem" {
  content         = ncloud_login_key.this.private_key
  filename        = "${path.module}/${ncloud_login_key.this.key_name}.pem"
  file_permission = "0400"  
}

# 출력
output "login_key_name"     { value = ncloud_login_key.this.key_name }
output "login_key_pem_path" { value = local_file.login_key_pem.filename }