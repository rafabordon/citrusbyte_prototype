resource "aws_security_group" "elb" {
    name = "CB Protoype ELB"
    description = "ELB - Allows all traffic for CB Prototype"
    vpc_id = "${data.terraform_remote_state.infra.vpc_id}"

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "prototype-ecs" {
    name = "CB Prototype - ECS"
    description = "ECS - Allows all traffic for CB Prototype"
    vpc_id = "${data.terraform_remote_state.infra.vpc_id}"

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        security_groups = ["${aws_security_group.elb.id}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
