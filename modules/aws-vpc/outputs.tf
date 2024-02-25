output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.final_work_vpc.id
}

output "subnet_ids" {
    value = [
        aws_subnet.final_work_subnet_1.id,
        aws_subnet.final_work_subnet_2.id
    ]
}