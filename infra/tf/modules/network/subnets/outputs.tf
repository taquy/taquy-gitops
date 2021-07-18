output "private_subnet_1a" {
  description = "Private subnet AZ #1"
  value       = aws_subnet.private_subnet_1a.id
}

output "private_subnet_2b" {
  description = "Private subnet AZ #2"
  value       = aws_subnet.private_subnet_2b.id
}

output "public_subnet_1a" {
  description = "Public subnet AZ #1"
  value       = aws_subnet.public_subnet_1a.id
}
output "public_subnet_2b" {
  description = "Public subnet AZ #2"
  value       = aws_subnet.public_subnet_2b.id
}
