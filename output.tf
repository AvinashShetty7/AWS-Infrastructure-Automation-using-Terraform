output "lbaddress" {
  value = aws_lb.mydemoLB.dns_name
}

output "bastianip" {
  value = aws_instance.jumphost.public_ip
}

