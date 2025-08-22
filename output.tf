output "web_private_ips" {
  value = ncloud_server.web.network_interface[0].private_ip
}

output "was_private_ips" {
  value = ncloud_server.was.network_interface[0].private_ip
}

output "web_block_devices" {
  value = [ncloud_block_storage.web_storage.device_name]
}

output "login_key_name" { value = ncloud_login_key.this.key_name }
output "login_key_pem_path" { value = local_file.login_key_pem.filename }