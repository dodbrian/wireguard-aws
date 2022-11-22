output "public_ip" {
  value       = aws_eip.wg_test_eip.public_ip
  description = "Elastic IP public address"
}
