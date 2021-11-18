terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

locals { 
  project_name = "terraform-project"
}

resource "aws_instance" "web_server" {
  ami                    = "ami-083654bd07b5da81d"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data 	         = <<-EOF
	      	           #!/bin/bash
	      	           echo "Hello, World!" > index.html
	      	           nohup busybox httpd -f -p 8080 &
	      	           EOF
  tags = {
    Name = "WebServer-${local.project_name}"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
} 

output "public_ip" {
  value       = aws_instance.web_server.public_ip
  description = "The public IP address of the web server"
}
