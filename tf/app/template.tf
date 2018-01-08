data "template_file" "user_data" {
    template = "${file("./user_data.tpl")}"

    vars {
        cb-cluster  = "${var.ecs_cluster_name}"
        auth        = "${var.auth}"
        email       = "${var.email}"
    }
}

