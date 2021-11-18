output "vpc_id" {
  description = "ID of the VPC"
  value	      = aws_vpc.production_vpc.id
}

output "public_ip" {
  value       = aws_instance.web_server.public_ip
  description = "The public IP address of the web server"
}
