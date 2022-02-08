# --- SSH Key pair ---

resource "aws_key_pair" "kpAvi" {
  key_name = "kpAvi"
  public_key = file(var.ssh_key.public)
}

resource "aws_key_pair" "kpJump" {
  key_name = "kpJump"
  public_key = file(var.ssh_key.public)
}

resource "aws_key_pair" "kpBackend" {
  key_name = "kpBackend"
  public_key = file(var.ssh_key.public)
}

resource "aws_key_pair" "kpMysql" {
  key_name = "kpMySql"
  public_key = file(var.ssh_key.public)
}

resource "aws_key_pair" "kpOpencart" {
  key_name = "kpOpencart"
  public_key = file(var.ssh_key.public)
}
