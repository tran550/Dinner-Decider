variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "github_repo_url" {
  description = "GitHub repository URL to clone (e.g., https://github.com/brandontran/devops.git)"
  type        = string
}

variable "gemini_api_key" {
  description = "Google GenAI API key"
  type        = string
  sensitive   = true
}

variable "unsplash_access_key" {
  description = "Unsplash API access key"
  type        = string
  sensitive   = true
}

variable "ssh_cidr" {
  description = "CIDR block for SSH access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ssh_key_name" {
  description = "Name of the AWS key pair to use for EC2"
  type        = string
  default     = ""
}