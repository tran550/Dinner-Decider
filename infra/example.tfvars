# Example Terraform variables file
# Copy this to terraform.tfvars and fill in your actual values
# DO NOT commit terraform.tfvars to git (it may contain secrets)

aws_region           = "us-east-1"
instance_type        = "t3.small"
github_repo_url      = "https://github.com/brandontran/devops.git"
gemini_api_key       = "YOUR_GEMINI_API_KEY_HERE"
unsplash_access_key  = "YOUR_UNSPLASH_ACCESS_KEY_HERE"
ssh_cidr             = "0.0.0.0/0"  # Restrict this to your IP in production
