variable "profile" {
  default = "default" # aws credential profile
}


variable "region" {
  default = "ap-southeast-1" # region where you want to launch your resources
}
variable "env" {
  default = "dev" # valid values: dev, stage and prod
}
variable "bucket_name" {
  default = "" # valid values: dev, stage and prod
}