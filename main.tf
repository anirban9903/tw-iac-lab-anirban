terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.40.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "ap-south-1"
  profile = "PowerUserPlusRole-160071257600"
}

# Create a VPC
resource "aws_vpc" "iac_lab_vpc_anirban" {
  cidr_block           = "192.168.1.0/25"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  instance_tenancy     = "default"
  tags = {
    Name = "iac-lab-anirban"
  }
}