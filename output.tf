output "az" {
  value = data.aws_availability_zones.available.names
}

output "aviAmi" {
  value = data.aws_ami.aviAmi.id
}

output "ubuntuBionic" {
  value = data.aws_ami.ubuntuBionic.id
}

output "ubuntuFocal" {
  value = data.aws_ami.ubuntuFocal.id
}

output "jumpPublicIp" {
  value = aws_instance.jump.public_ip
}

output "aviCtrlPublicIp" {
  value = aws_instance.aviCtrl.*.public_ip
}

output "destroy" {
  value = "ssh -o StrictHostKeyChecking=no -i ${var.ssh_key.private} -t ubuntu@${aws_instance.jump.public_ip} 'git clone ${var.ansible["aviPbAbsentUrl"]} --branch ${var.ansible["aviPbAbsentTag"]}; ansible-playbook ${basename(var.ansible.aviPbAbsentUrl)}/local.yml --extra-vars @${var.aws.controller["aviCredsJsonFile"]}' ; sleep 20 ; terraform destroy -auto-approve -var-file=aws.json"
  description = "command to destroy the infra"
}
