variable "env" {}
variable "region" {}

variable "role_arn" {}
variable "task_role_arn" {}


variable "tg_arn" {}

variable "app_sub1_id" {}

variable "app_sub2_id" {}

variable "vpc_id" {}
variable "vpc_cidr_block" {}
variable "container_name" {
 default = "backend"
}