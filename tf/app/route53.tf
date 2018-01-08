resource "aws_route53_record" "raf_elb" {
  zone_id = "${var.hosted_zone_id}"
  name = "${var.dns_name}"
  type = "${var.dns_type}"
  ttl = "${var.dns_ttl}"
  records = [ "${aws_elb.cb-prototype-elb.dns_name}" ]
}
