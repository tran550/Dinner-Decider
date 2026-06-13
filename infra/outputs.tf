output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.dinner_decider.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.dinner_decider.id
}

output "app_url" {
  description = "URL to access the Dinner Decider app"
  value       = "http://${aws_instance.dinner_decider.public_ip}:5000"
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.dinner_decider_sg.id
}
