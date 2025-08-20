###################################
# 프로젝트 기본 설정
###################################
variable "project" {
  type    = string
  default = "tf-3tier"
}

variable "zone" {
  type    = string
  default = "KR-1"
}

###################################
# 네트워크 설정
###################################
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "public_lb_cidr" {
  type    = string
  default = "10.0.10.0/24"
}

variable "private_lb_cidr" {
  type    = string
  default = "10.0.20.0/24"
}

variable "natgw_cidr"      { 
    type = string 
    default = "10.0.30.0/24"
}

variable "db_subnet_cidr" {
  type    = string
  default = "10.0.100.0/24"
  
}


###################################
# 서버 설정
###################################
variable "web_count" {
  type    = number
  default = 1
}

variable "was_count" {
  type    = number
  default = 1
}

###################################
# 포트 설정
###################################
variable "web_port" {
  type    = number
  default = 80
}

variable "was_port" {
  type    = number
  default = 8080
}
