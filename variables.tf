variable "prefix" {
  type        = string
  description = "VPC prefix"
}

variable "region" {
  type        = string
  description = "VPC region"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "public_subnet_count" {
  description = "Number of public subnets to create"
  type        = number
  default     = 2 # Default number of public subnets
}

variable "private_subnet_count" {
  description = "Number of private subnets to create"
  type        = number
  default     = 2 # Default number of private subnets
}