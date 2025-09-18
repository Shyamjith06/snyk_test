provider "aws" {
  region = "us-east-1"
}

# Public S3 bucket (vulnerability: should not be public-read)
resource "aws_s3_bucket" "bad_example" {
  bucket = "my-insecure-bucket-snyk-test"
  acl    = "public-read"

  tags = {
    Name        = "insecure-bucket"
    Environment = "dev"
  }
}

# Security group with open ingress (vulnerability: allows 0.0.0.0/0 on port 22)
resource "aws_security_group" "open_sg" {
  name        = "open-sg"
  description = "Allow SSH from anywhere"
  vpc_id      = "vpc-123456" # replace with a real VPC ID if testing with AWS

  ingress {
    description = "SSH from world"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
