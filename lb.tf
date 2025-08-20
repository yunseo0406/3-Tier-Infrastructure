###################################
# 외부 로드 밸런서 (ALB)
###################################
resource "ncloud_lb" "external_lb" {
  name           = "external-lb-${var.project}"
  network_type   = "PUBLIC"
  type           = "APPLICATION"
  subnet_no_list = [ncloud_subnet.public_lb.id]
}

# external lb target group
resource "ncloud_lb_target_group" "ex_lb_target_group" {
  vpc_no      = ncloud_vpc.this.id
  protocol    = "HTTP"
  target_type = "VSVR"
  port        = var.web_port
  health_check {
    protocol       = "HTTP"
    http_method    = "GET"
    port           = var.web_port
    url_path       = "/"
    cycle          = 30
    up_threshold   = 2
    down_threshold = 2
  }
  algorithm_type = "RR"
}

# external lb listener
resource "ncloud_lb_listener" "ex_lb_listener" {
  load_balancer_no = ncloud_lb.external_lb.id
  protocol         = "HTTP"
  port             = 80
  target_group_no  = ncloud_lb_target_group.ex_lb_target_group.id
}

# external lb target group attachment
resource "ncloud_lb_target_group_attachment" "ex_lb_target_group_attach" {
  target_group_no = ncloud_lb_target_group.ex_lb_target_group.id
  target_no_list  = [ncloud_server.web.id]

  depends_on = [
    ncloud_lb_target_group.ex_lb_target_group,
    ncloud_server.web
  ]
}

###################################
# 내부 로드 밸런서 (NLB)
###################################
resource "ncloud_lb" "internal_nlb" {
  name           = "internal-nlb-${var.project}"
  network_type   = "PRIVATE"
  type           = "NETWORK"
  subnet_no_list = [ncloud_subnet.private_lb.id]
}

# internal lb target group
resource "ncloud_lb_target_group" "in_nlb_target_group" {
  vpc_no      = ncloud_vpc.this.id
  protocol    = "TCP"
  target_type = "VSVR"
  port        = var.was_port # 8080

  health_check {
    protocol       = "TCP"
    port           = var.was_port
    cycle          = 30
    up_threshold   = 2
    down_threshold = 2
  }

  algorithm_type = "RR"
}

# external lb listener
resource "ncloud_lb_listener" "in_nlb_listener" {
  load_balancer_no = ncloud_lb.internal_nlb.id
  protocol         = "TCP"
  port             = var.was_port # 8080
  target_group_no  = ncloud_lb_target_group.in_nlb_target_group.id
}

# internal lb target group attachment
resource "ncloud_lb_target_group_attachment" "in_nlb_attach" {
  target_group_no = ncloud_lb_target_group.in_nlb_target_group.target_group_no
  target_no_list  = [ncloud_server.was.id]
  depends_on = [
    ncloud_lb_target_group.in_nlb_target_group,
    ncloud_server.was
  ]
}


output "internal_nlb_vip" {
  value = ncloud_lb.internal_nlb.ip_list
}
