output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}

output "public_subnet_1a_id" {
  description = "Public subnet 1"
  value       = aws_subnet.public_subnet_1a.id
}

output "public_subnet_2b_id" {
  description = "Public subnet 2"
  value       = aws_subnet.public_subnet_2b.id
}

output "private_subnet_1a_id" {
  description = "Private subnet 1"
  value       = aws_subnet.private_subnet_1a.id
}

output "private_subnet_2b_id" {
  description = "Private subnet 2"
  value       = aws_subnet.private_subnet_2b.id
}

output "vm_public_ip" {
  description = "Elastic public IP of VM"
  value       = aws_eip.vm_eip.public_ip
}




