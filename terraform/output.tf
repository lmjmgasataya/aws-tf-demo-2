output "demo_vpc_id" {
  value       = aws_vpc.demo_vpc.id
  description = "VPC ID"
}

output "public_subnet_id" {
  value       = aws_subnet.demo_public_subnet.id
  description = "Public subnet ID"
}

output "private_subnet_id" {
  value       = aws_subnet.demo_private_subnet.id
  description = "Private subnet ID"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.demo_igw.id
  description = "Internet gateway ID"
}

output "iam_role_id" {
  value       = aws_iam_role.demo_role.id
  description = "IAM role ID"
}

output "instance_id" {
  value       = aws_instance.demo_instance.id
  description = "Instance ID"
}
