##  Internet Gateway

resource "aws_internet_gateway" "default" {
    vpc_id = "${var.vpc_id}"
}

## VPN Gateway

resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "Main VPN Gateway"
  }
}

## EIP

resource  "aws_eip" "nat" {
  vpc = true
  count = 3

}

## NAT Gateways

resource "aws_nat_gateway" "gw" {
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id = "${element(aws_subnet.nonprod-public-subnets.*.id, count.index)}"
  count = 3

  depends_on = ["aws_internet_gateway.default"]
}
