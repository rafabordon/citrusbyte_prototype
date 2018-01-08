## Private subnets

resource "aws_subnet" "nonprod-private-subnets" {
    vpc_id = "${var.vpc_id}"
    cidr_block  = "${element(split(",", var.private_subnet_cidrs), count.index)}"
    availability_zone = "${element(var.availability_zones, count.index)}"
    count = 3

    tags {
        Name = "NonProdPrivate-${element(var.availability_zones, count.index)}"
    }
}

## Public subnets

resource "aws_subnet" "nonprod-public-subnets" {
    vpc_id = "${var.vpc_id}"
    cidr_block  = "${element(split(",", var.public_subnet_cidrs), count.index)}"
    availability_zone = "${element(var.availability_zones, count.index)}"
    count = 3

    tags {
        Name = "NonProdPublic-${element(var.availability_zones, count.index)}"
    }
}
