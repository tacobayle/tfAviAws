# AWS  variables

variable "avi_password" {}
variable "avi_username" {}
variable "avi_old_password" {}

variable "aws" {}

variable "ssh_key" {
  default = {
    private = "/opt/creds/ssh/cloudKey"
    public = "/opt/creds/ssh/cloudKey.pub"
  }
}

variable "jump" {
  type = map
  default = {
    type = "t2.medium"
    userdata = "userdata/jump.sh"
    count = "1"
    avisdkVersion = "22.1.1"
    username = "ubuntu"
    hostname = "jump"
  }
}

variable "ansible" {
  type = map
  default = {
    version = "2.10.7"
    prefixGroup = "aws"
    aviPbAbsentUrl = "https://github.com/tacobayle/ansibleAviClear"
    aviPbAbsentTag = "v1.02"
    aviConfigureTag = "v1.00"
    aviConfigureUrl = "https://github.com/tacobayle/ansibleAviConfig"
  }
}

variable "backend" {
  type = map
  default = {
    type = "t2.micro"
    userdata = "userdata/backend.sh"
    url_demovip_server = "https://github.com/tacobayle/demovip_server"
    username = "ubuntu"
  }
}

variable "autoScalingGroupUserdata" {
  default = "userdata/backendGroup.sh"
}