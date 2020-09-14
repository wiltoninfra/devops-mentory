output "sg-http" {
  description = "Security Group HTTP"
    value = aws_security_group.http.id
}

output "sg-https" {
  description = "Security Group HTTPS"
    value = aws_security_group.https.id
}

output "sg-mysql" {
  description = "Security Group MySQL"
    value = aws_security_group.mysql.id
}

output "sg-ssh" {
  description = "Security Group SSH"
    value = aws_security_group.ssh.id
}

output "sg-openvpn" {
  description = "Security Group OpenVPN"
    value = aws_security_group.openvpn.id
}

