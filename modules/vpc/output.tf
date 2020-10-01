output "out_vpc_id" {
  value = "${aws_vpc.vpc.id}"
}
output "out_vpc_cidr_block" {
  value = "${aws_vpc.vpc.cidr_block}"
}
output "out_db_sub1_id" {
  value = "${aws_subnet.db_sub1.id}"
}
output "out_db_sub2_id" {
  value = "${aws_subnet.db_sub2.id}"
}
output "out_app_sub1_id" {
  value = "${aws_subnet.app_sub1.id}"
}
output "out_app_sub2_id" {
  value = "${aws_subnet.app_sub2.id}"
}
output "out_pub_sub1_id" {
  value = "${aws_subnet.pub_sub1.id}"
}
output "out_pub_sub2_id" {
  value = "${aws_subnet.pub_sub2.id}"
}