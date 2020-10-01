output "tg_arn" {
  value = "${aws_lb_target_group.my-tg.arn}"
}
output "dns_name" {
  value = "${aws_lb.alb.dns_name}"
}
