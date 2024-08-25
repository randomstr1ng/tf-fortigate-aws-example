output "FortiGatePublicIP" {
  value = aws_eip.fgtpublicip.public_ip
}

output "Username" {
  value = "admin"
}

output "Password" {
  value = aws_instance.fgtvm.id
}

resource "local_file" "ssh_key" {
  content         = tls_private_key.ssh_key.private_key_openssh
  filename        = "${path.module}/ssh_key.pem"
  file_permission = "0400"
}

output "WebserverIP" {
  value = aws_instance.webserver.private_ip
}