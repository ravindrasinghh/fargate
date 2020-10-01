provider "aws" {
  profile = "${var.profile}"
  region  = "${var.region}"
}

module "vpc" {
  source = "./modules/vpc"

  env    = "${var.env}"
  region = "${var.region}"
}

module "iam" {
  source = "./modules/iam"
  env    = "${var.env}"
}

module "ecs" {
  source         = "./modules/ecs"
  env            = "${var.env}"
  region         = "${var.region}"
  role_arn       = "${module.iam.role_arn}"
  tg_arn         = "${module.alb.tg_arn}"
  vpc_id         = "${module.vpc.out_vpc_id}"
  vpc_cidr_block = "${module.vpc.out_vpc_cidr_block}"
  app_sub1_id    = "${module.vpc.out_app_sub1_id}"
  app_sub2_id    = "${module.vpc.out_app_sub2_id}"
  task_role_arn  = "${module.iam.task_role_arn}"
}

module "alb" {
  source         = "./modules/alb"
  env            = "${var.env}"
  region         = "${var.region}"
  vpc_id         = "${module.vpc.out_vpc_id}"
  vpc_cidr_block = "${module.vpc.out_vpc_cidr_block}"
  pub_sub1_id    = "${module.vpc.out_pub_sub1_id}"
  pub_sub2_id    = "${module.vpc.out_pub_sub2_id}"
}
