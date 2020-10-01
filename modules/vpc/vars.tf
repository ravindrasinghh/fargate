variable vpc_cidr_block {
  type = "map"
  default = {
    "dev"   = "10.10.0.0/16"
    "stage" = "10.20.0.0/16"
    "prod"  = "10.30.0.0/16"
  }
}

variable pub_sub1_cidr_block {
  type = "map"
  default = {
    "dev"   = "10.10.1.0/24"
    "stage" = "10.20.1.0/24"
    "prod"  = "10.30.1.0/24"
  }
}

variable pub_sub2_cidr_block {
  type = "map"
  default = {
    "dev"   = "10.10.2.0/24"
    "stage" = "10.20.2.0/24"
    "prod"  = "10.30.2.0/24"
  }
}

variable app_sub1_cidr_block {
  type = "map"
  default = {
    "dev"   = "10.10.3.0/24"
    "stage" = "10.20.3.0/24"
    "prod"  = "10.30.3.0/24"
  }
}

variable "db_public_access" {
  type = "map"
  default = {
    "dev"   = true
    "stage" = false
    "prod"  = false
  }
}

variable app_sub2_cidr_block {
  type = "map"
  default = {
    "dev"   = "10.10.4.0/24"
    "stage" = "10.20.4.0/24"
    "prod"  = "10.30.4.0/24"
  }
}

variable db_sub1_cidr_block {
  type = "map"
  default = {
    "dev"   = "10.10.5.0/24"
    "stage" = "10.20.5.0/24"
    "prod"  = "10.30.5.0/24"
  }
}

variable db_sub2_cidr_block {
  type = "map"
  default = {
    "dev"   = "10.10.6.0/24"
    "stage" = "10.20.6.0/24"
    "prod"  = "10.30.6.0/24"
  }
}

variable "env" {}

variable "region" {}

