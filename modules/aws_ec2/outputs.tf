output "security_group_id" {
  description = "The ID of the security group"
  value       = module.sg.security_group_id
}

output "ec2_instance_ids" {
  description = "The IDs of the EC2 instances"
  value       = module.ec2_instance.*.id
}

output "alb_arn" {
  description = "The ARN of the ALB"
  value       = module.alb.lb_arn
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.alb.lb_dns_name
}

output "target_group_arns" {
  description = "The ARNs of the target groups"
  value       = module.alb.target_group_arns
}