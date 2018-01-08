resource "aws_ecs_cluster" "cb-cluster" {
    name = "${var.ecs_cluster_name}"
}

resource "aws_autoscaling_group" "cb-ecs-cluster" {
    availability_zones = ["${data.terraform_remote_state.infra.availability_zones}"]
    name = "ECS ${var.ecs_cluster_name} - ${element(data.terraform_remote_state.infra.availability_zones, count.index)}"
    min_size = "${var.autoscale_min}"
    max_size = "${var.autoscale_max}"
    desired_capacity = "${var.autoscale_desired}"
    health_check_grace_period = 300
    health_check_type = "EC2"
    launch_configuration = "${aws_launch_configuration.ecs.name}"
    load_balancers  = ["${aws_elb.cb-prototype-elb.id}"]
    vpc_zone_identifier = ["${data.terraform_remote_state.infra.public_subnet_ids}"]
}

resource "aws_launch_configuration" "ecs" {
    name = "ECS ${var.ecs_cluster_name}"
    image_id = "${var.ami}"
    instance_type = "${var.instance_type}"
    security_groups = ["${aws_security_group.prototype-ecs.id}"]
    iam_instance_profile = "${aws_iam_instance_profile.ecs.name}"
    key_name = "${aws_key_pair.raf.key_name}"
    associate_public_ip_address = true
    user_data = "${data.template_file.user_data.rendered}"
}
