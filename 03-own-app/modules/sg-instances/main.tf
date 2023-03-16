# SG FOR EC2  INSTANCES
module "sg_instances" {
    source = "terraform-aws-modules/security-group/aws"
    name        = "${var.instance_name} sg"
    description = "${var.instance_name} sg"
    vpc_id      = var.vpc_id
    egress_rules = ["all-all"]
    ingress_with_cidr_blocks = var.sg_instances_rules

}