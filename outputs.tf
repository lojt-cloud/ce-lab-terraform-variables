output "environment" {
  description = "The environment this configuration was deployed to"
  value       = var.environment
}
output "s3_bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.app_data.id
}
output "instance_IPs" {
  description = "Public IP address of the app server"
  value = aws_instance.app_server.public_ip
}
output "security_group_ID" {
  description = "number of the created security_group_ID"
  value = aws_security_group.app_sg.id
}
