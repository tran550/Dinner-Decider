# Terraform Deployment

Deploy the Dinner Decider app to AWS EC2 using Terraform.

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured (`aws configure` or env vars set)
- GitHub repository public or SSH key configured
- Valid Google GenAI and Unsplash API keys

## Quick Start

### 1. Set up variables

Copy `example.tfvars` and fill in your values:

```bash
cp example.tfvars terraform.tfvars
# Edit terraform.tfvars with your API keys and GitHub repo URL
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Plan the deployment

```bash
terraform plan -var-file="terraform.tfvars"
```

### 4. Apply the deployment

```bash
terraform apply -var-file="terraform.tfvars"
```

This will:
- Create a security group
- Launch an EC2 instance (Ubuntu 22.04)
- Install Docker and clone your repository
- Build and run your Docker image with env vars

### 5. Access your app

After `terraform apply` completes, Terraform will output the app URL:

```
app_url = "http://<PUBLIC_IP>:5000"
```

Visit that URL in your browser.

## Cleaning Up

To destroy all resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## File Descriptions

- **main.tf** - EC2 instance, security group, and data sources
- **variables.tf** - Input variables (region, instance type, API keys)
- **outputs.tf** - Output values (public IP, app URL)
- **user-data.sh.tpl** - Script that runs on instance startup
- **example.tfvars** - Template for your variables

## Best Practices

1. **Never commit `terraform.tfvars`** — it contains secrets. Use `.gitignore` to prevent accidental commits.
2. **Use remote state** — store state in S3 for team collaboration (see Remote State section below).
3. **Restrict SSH access** — change `ssh_cidr` from `0.0.0.0/0` to your IP in production.
4. **Use secrets management** — consider AWS Secrets Manager or Parameter Store for long-term use.

## Remote State (Optional)

To share state across a team, use S3 + DynamoDB for locking:

Create `backend.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "dinner-decider/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
```

Then run:

```bash
terraform init
```

Terraform will prompt you to confirm migrating state to S3.

## Troubleshooting

**Instance fails to start Docker container**
- SSH into the instance and check logs: `docker logs dinner-app`
- Verify env vars are set: `docker inspect dinner-app | grep -i env`

**Cannot connect to app**
- Check security group: ensure port 5000 is open
- Verify app is running: `docker ps` on the instance

**Terraform plan fails**
- Ensure AWS credentials are configured: `aws sts get-caller-identity`
- Check variable values: `terraform validate`

## Next Steps

- Add CI/CD to automatically run `terraform apply` on git push
- Set up Terraform Cloud for remote state and runs
- Migrate to ECS/Fargate for better scalability
