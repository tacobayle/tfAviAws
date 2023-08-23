resource "null_resource" "foo7" {
  depends_on = [aws_instance.jump]
  connection {
    host        = aws_instance.jump.public_ip
    type        = "ssh"
    agent       = false
    user        = var.jump["username"]
    private_key = file(var.ssh_key.private)
  }

  provisioner "file" {
    source      = var.ssh_key.private
    destination = "/home/${var.jump["username"]}/.ssh/${basename(var.ssh_key.private)}"
  }

  provisioner "remote-exec" {
    inline      = [
      "chmod 600 ~/.ssh/${basename(var.ssh_key.private)}",
      "mkdir -p ansible",
      "cd ~/ansible ; git clone ${var.ansible.aviConfigureUrl} --branch ${var.ansible.aviConfigureTag} ; cd ${split("/", var.ansible.aviConfigureUrl)[4]}",
      "ansible-playbook local.yml --extra-vars '{\"avi_username\": ${jsonencode(var.avi_username)}, \"avi_password\": ${jsonencode(var.avi_password)}, \"avi_old_password\": ${jsonencode(var.avi_old_password)}, \"avi_version\": ${jsonencode(var.aws.controller.version)}, \"controller\": ${jsonencode(var.aws.controller)}, \"controllerPrivateIps\": ${jsonencode(aws_instance.aviCtrl.*.private_ip)}, \"controllerPublicIps\": ${jsonencode(aws_instance.aviCtrl.*.public_ip)}, \"aws\": ${jsonencode(var.aws)}, \"awsZones\": ${jsonencode(data.aws_availability_zones.available.names)}, \"awsSubnetAviVsIds\": ${jsonencode(aws_subnet.subnetAviVs.*.id)}, \"awsSubnetSeMgtIds\": ${jsonencode(aws_subnet.subnetAviSeMgt.*.id)}, \"aws_vpc_id\": ${jsonencode(aws_vpc.vpc[0].id)}, \"avi_backend_servers_aws\": ${jsonencode(aws_instance.backend.*.private_ip)}, \"asg_id\": ${jsonencode(aws_autoscaling_group.autoScalingGroup.id)}}'"
    ]
  }
}


data "template_file" "traffic_gen" {
  template = file("templates/traffic_gen.sh.template")
  vars = {
    controllerPrivateIp = jsonencode(aws_instance.aviCtrl[0].private_ip)
    avi_password = jsonencode(var.avi_password)
    avi_username = "admin"
  }
}

resource "null_resource" "transfer_traffic_gen" {
  depends_on = [null_resource.foo7]

  connection {
    host        = aws_instance.jump.public_ip
    type        = "ssh"
    agent       = false
    user        = var.jump["username"]
    private_key = file(var.ssh_key.private)
  }

  provisioner "file" {
    content = data.template_file.traffic_gen.rendered
    destination = "/home/ubuntu/traffic_gen.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod u+x /home/${var.jump["username"]}/traffic_gen.sh",
      "(crontab -l 2>/dev/null; echo \"* * * * * /home/${var.jump["username"]}/traffic_gen.sh\") | crontab -"
    ]
  }

}