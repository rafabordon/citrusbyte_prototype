## Public Route Table

resource "aws_route_table" "NonProdPublic" {
    vpc_id = "${var.vpc_id}"
    tags {
        Name = "Public Subnets"
    }
}

resource "aws_route" "public_route"{
  route_table_id  = "${aws_route_table.NonProdPublic.id}"
  destination_cidr_block  = "${element(split(",", var.pub_dest_cidr_blocks), count.index)}"
  gateway_id  = "${aws_vpn_gateway.vpn_gw.id}"
  count = "${length(split(",", var.pub_dest_cidr_blocks))}"
}

resource "aws_route" "public_route_internet_gw"{
  route_table_id  = "${aws_route_table.NonProdPublic.id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.default.id}"
}

resource "aws_route_table_association" "public" {
    subnet_id = "${element(aws_subnet.nonprod-public-subnets.*.id, count.index)}"
    route_table_id = "${aws_route_table.NonProdPublic.id}"
    count = 3
}


## Private Route Tables

resource "aws_route_table" "NonProdPrivate" {
    vpc_id = "${var.vpc_id}"
    tags {
        Name = "Private Subnet - ${element(var.availability_zones, count.index)}"
    }
    count = 3
}

resource "aws_route" "vpg"{
  route_table_id  = "${element(aws_route_table.NonProdPrivate.*.id, count.index)}"
  destination_cidr_block  = "10.0.0.0/8"
  gateway_id  = "${aws_vpn_gateway.vpn_gw.id}"
  count = 3
}

resource "aws_route" "nat_gw"{
  route_table_id  = "${element(aws_route_table.NonProdPrivate.*.id, count.index)}"
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id = "${element(aws_nat_gateway.gw.*.id, count.index)}"
  count = 3
}

resource "aws_route_table_association" "private" {
    subnet_id = "${element(aws_subnet.nonprod-private-subnets.*.id, count.index)}"
    route_table_id = "${element(aws_route_table.NonProdPrivate.*.id, count.index)}"
    count = 3
}
