variable "name" {
  default = "admin"
}

variable "adminvpc_cidr" {
    default = "192.168.0.0/16"
}

variable "adminvpc_private_subnets" {
    default = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
}

variable "adminvpc_public_subnets" {
    default = ["192.168.10.0/24", "192.168.20.0/24", "192.168.30.0/24"]
}

variable "adminvpc_azs" {
    default             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}


