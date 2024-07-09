# AWS Access Keys
variable "aws_access_key_id" {
  description = "AWS access key ID"
  type        = string
  default     = "githubsecret"
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
  type        = string
  default     = "githubsecret"
}

# Variables for vpc.tf

variable "vpc_cidr_block" {
  description = "The ID of the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cidr_block_public_us_east_1a" {
  description = "CIDR block for the public subnet in us-east-1a"
  type        = string
  default     = "10.0.1.0/24"
}

variable "cidr_block_private_us_east_1a" {
  description = "CIDR block for the private subnet in us-east-1a"
  type        = string
  default     = "10.0.2.0/24"
}

variable "cidr_block_public_us_east_1b" {
  description = "CIDR block for the public subnet in us-east-1b"
  type        = string
  default     = "10.0.3.0/24"
}

variable "cidr_block_private_us_east_1b" {
  description = "CIDR block for the private subnet in us-east-1b"
  type        = string
  default     = "10.0.4.0/24"
}


variable "instance_type" {
  description = "The instance type for the EC2 instances"
  type        = string
  default     = "t3.small"
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instances"
  type        = string
  default     = "ami-0e001c9271cf7f3b9"
}

variable "bootstrap-web" {
  description = "The path to the bootstrap script"
  type        = string
  default     = "web.sh"
}

# Variables for alb.tf
variable "tg_port" {
  description = "The port for the target group"
  type        = number
  default     = 80
}

variable "egress_cidr_blocks" {
  description = "CIDR blocks for egress rules."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ingress_ssh_cidr_blocks" {
  description = "CIDR blocks for SSH ingress rules."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ingress_http_cidr_blocks" {
  description = "CIDR blocks for HTTP ingress rules."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "security_group_name" {
  description = "Name tag for the security group."
  type        = string
  default     = "ssh-allowed"
}

variable "key_name" {
  description = "The name of the key pair."
  type        = string
  default     = "tbckey"
}

variable "algorithm" {
  description = "The algorithm for the key pair."
  type        = string
  default     = "RSA"
}

variable "rsa_bits" {
  description = "The number of RSA bits for the key pair."
  type        = number
  default     = 4096
}

variable "filename" {
  description = "The filename for the local file storing the private key."
  type        = string
  default     = "terrakey"
}

# DNS Variables

variable "domain_name" {
  description = "The domain name for the CloudFront distribution."
  type        = string
  default     = "yourhost.com"
}