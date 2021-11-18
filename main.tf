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
    Terraform = "true"
    Environment = "lab"
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

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name               = "my-vpc"
  cidr               = "10.0.0.0/16"
  azs                = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  enable_nat_gateway = true
  enable_vpn_gateway = true
  tags		     = {
		       Terraform = "true"
		       Environment = "lab"
  }
}
