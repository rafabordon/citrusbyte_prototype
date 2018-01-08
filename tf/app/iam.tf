resource "aws_iam_role" "cb_host_role" {
    name = "cb_ecs_role"
    assume_role_policy = "${file("policies/host-role.json")}"
}

resource "aws_iam_role_policy" "cb_instance_role_policy" {
    name = "cb_instance_role_policy"
    policy = "${file("policies/cb-instance-role-policy.json")}"
    role = "${aws_iam_role.cb_host_role.id}"
}

resource "aws_iam_role" "cb_service_role" {
    name = "cb_service_role"
    assume_role_policy = "${file("policies/host-role.json")}"
}

resource "aws_iam_role_policy" "cb_service_role_policy" {
    name = "cb_service_role_policy"
    policy = "${file("policies/cb-service-role-policy.json")}"
    role = "${aws_iam_role.cb_service_role.id}"
}

resource "aws_iam_instance_profile" "ecs" {
    name = "ecs-instance-profile"
    path = "/"
    role = "${aws_iam_role.cb_host_role.name}"
}
