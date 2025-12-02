output "aws_tunnel1_address" {
  value = aws_vpn_connection.vpn.tunnel1_address
}

output "aws_tunnel2_address" {
  value = aws_vpn_connection.vpn.tunnel2_address
}

output "aws_vpn_connection_id" {
  value = aws_vpn_connection.vpn.id
}