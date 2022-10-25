output "public_ip" {
  value       = aws_eip.eip.public_ip
  description = "Elastic IP public address"
}
