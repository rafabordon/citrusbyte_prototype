## This is only for output purposes. 

output  "region" {
    value = "${var.region}"
}

output  "vpc_id"  {
  value = "${var.vpc_id}"
}

output "private_subnet_ids" {
  value = "${aws_subnet.nonprod-private-subnets.*.id}"
}

output "public_subnet_ids" {
  value = "${aws_subnet.nonprod-public-subnets.*.id}"
}

output "availability_zones" {
  value = "${var.availability_zones}"
}
