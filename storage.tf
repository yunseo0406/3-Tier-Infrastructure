#####################################
# Block Storage (Web 서버용)
#####################################
resource "ncloud_block_storage" "web_storage" {
  size               = "10"
  server_instance_no = ncloud_server.web.id
  name               = "${var.project}-web-storage"
  hypervisor_type    = "KVM"
  volume_type        = "CB1"
  zone               = var.zone
}

#####################################
# NAS (WAS 서버용)
#####################################
resource "ncloud_nas_volume" "was_nas" {
  volume_name_postfix            = "vol"
  volume_size                    = "500"
  volume_allotment_protocol_type = "NFS"
  zone                           = var.zone
  server_instance_no_list = [ncloud_server.was.id]
}
