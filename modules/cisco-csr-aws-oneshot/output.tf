output "cisco_csr_ami" {
  value = "${data.aws_ami_ids.cisco_csr.ids}"
}

output "destination_cidr" {
  value = "${data.template_file.aws-terraform-dcos-default-cidr.rendered}"
}

output "aws_public_ip_address" {
  value = "${coalesce(var.public_ip_local_site, aws_eip.csr.public_ip)}"
}

output "aws_private_ip_address" {
  value = "${aws_instance.cisco.private_ip}"
}

output "aws_ssh_user" {
  value = "ec2-user"
}

output "aws_config_out" {
  value = "${module.aws_csr_userdata.userdata}"
}