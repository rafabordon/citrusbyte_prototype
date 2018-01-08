resource "aws_elb" "cb-prototype-elb" {
    name = "cb-prototoype-elb"
    security_groups = ["${aws_security_group.elb.id}"]
    internal  = false
    subnets = ["${data.terraform_remote_state.infra.public_subnet_ids}"]

    listener {
        lb_protocol = "http"
        lb_port = 80

        instance_protocol = "http"
        instance_port = 5555
    }

    health_check {
        healthy_threshold = 5
        unhealthy_threshold = 5
        timeout = 5
        target = "HTTP:5555/testme"
        interval = 10
    }

    cross_zone_load_balancing = true
}

resource "aws_ecs_task_definition" "cb-prototype" {
    family = "cb-prototype"
    container_definitions = "${file("cb-prototype.json")}"
}

resource "aws_ecs_service" "cb-prototype" {
    name = "cb-prototoype"
    cluster = "${aws_ecs_cluster.cb-cluster.id}"
    task_definition = "${aws_ecs_task_definition.cb-prototype.arn}"
    iam_role = "${aws_iam_role.cb_service_role.arn}"
    desired_count = 3
    depends_on = ["aws_iam_role_policy.cb_service_role_policy"]

    load_balancer {
        elb_name = "${aws_elb.cb-prototype-elb.id}"
        container_name = "cb-prototype"
        container_port = 5555
    }
}
