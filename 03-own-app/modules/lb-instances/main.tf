# SG FOR EC2  INSTANCES
module "sg_instances" {
    source = "terraform-aws-modules/security-group/aws"
    name        = "${var.instance_name} sg"
    description = "${var.instance_name} sg"
    vpc_id      = var.vpc_id
    egress_rules = ["all-all"]

    computed_ingress_with_source_security_group_id = var.sg_instances_rules
    number_of_computed_ingress_with_source_security_group_id = length(var.sg_instances_rules)

}