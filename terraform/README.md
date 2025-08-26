# HAM Radio Practice Test Application - AWS Infrastructure

This Terraform configuration sets up a complete AWS infrastructure for the HAM Radio Practice Test Application in the Europe North (eu-north-1) region.

## Architecture Overview

The infrastructure includes:

- **VPC with Multi-AZ setup** across 2 availability zones
- **Public, Private, and Database subnets** for proper network segmentation
- **Application Load Balancer** for high availability and traffic distribution
- **ECS Fargate cluster** for running the Node.js backend
- **DocumentDB cluster** (MongoDB-compatible) for data storage
- **S3 buckets** for frontend hosting and file uploads
- **CloudFront distribution** for global content delivery
- **Security Groups** with least-privilege access
- **IAM roles and policies** for secure service interactions

## Prerequisites

1. **AWS CLI configured** with appropriate credentials
2. **Terraform installed** (version >= 1.0)
3. **AWS account** with necessary permissions

## Quick Start

1. **Clone the repository and navigate to terraform directory:**
   ```bash
   cd terraform
   ```

2. **Copy the example variables file:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. **Edit terraform.tfvars** with your specific values:
   ```bash
   nano terraform.tfvars
   ```

4. **Initialize Terraform:**
   ```bash
   terraform init
   ```

5. **Plan the deployment:**
   ```bash
   terraform plan
   ```

6. **Apply the configuration:**
   ```bash
   terraform apply
   ```

## Configuration Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `aws_region` | AWS region for resources | `eu-north-1` | No |
| `project_name` | Name of the project | `ham-radio-practice` | No |
| `environment` | Environment name | `dev` | No |
| `vpc_cidr` | CIDR block for VPC | `10.0.0.0/16` | No |
| `backend_cpu` | CPU units for backend container | `256` | No |
| `backend_memory` | Memory (MiB) for backend | `512` | No |
| `db_instance_class` | DocumentDB instance class | `db.t3.medium` | No |
| `allowed_cidr_blocks` | CIDR blocks allowed access | `["0.0.0.0/0"]` | No |
| `domain_name` | Custom domain name | `""` | No |

## Outputs

After successful deployment, Terraform will output important information including:

- **Application URL**: CloudFront distribution URL for the frontend
- **API URL**: Load balancer URL for the backend API
- **S3 bucket names**: For frontend and uploads
- **Database endpoint**: DocumentDB connection details
- **VPC and subnet IDs**: For reference

## Architecture Components

### Network Layer
- **VPC**: 10.0.0.0/16 with DNS support enabled
- **Public Subnets**: 10.0.1.0/24, 10.0.2.0/24 (for ALB)
- **Private Subnets**: 10.0.10.0/24, 10.0.20.0/24 (for ECS tasks)
- **Database Subnets**: 10.0.30.0/24, 10.0.40.0/24 (for DocumentDB)
- **NAT Gateways**: For private subnet internet access
- **VPC Endpoints**: S3 endpoint for cost optimization

### Security
- **Security Groups**: Separate groups for ALB, backend, and database
- **IAM Roles**: ECS task execution and task roles with minimal permissions
- **S3 Bucket Policies**: CloudFront-only access to frontend bucket
- **DocumentDB**: TLS encryption enabled

### Compute Layer
- **ECS Fargate**: Serverless container platform
- **Application Load Balancer**: Layer 7 load balancing with health checks
- **Auto Scaling**: Can be configured for production workloads

### Storage and Content Delivery
- **DocumentDB**: MongoDB-compatible database with automatic backups
- **S3 Buckets**: Separate buckets for frontend and uploads
- **CloudFront**: Global CDN with custom error pages

## Development vs Production

This configuration is optimized for development with:
- Single DocumentDB instance
- Minimal ECS resources (256 CPU, 512MB memory)
- CloudWatch logs retention of 7 days
- Skip final snapshot for DocumentDB

For production, consider:
- Multi-instance DocumentDB cluster
- Increased ECS resources
- Longer log retention
- Final snapshots enabled
- Custom domain with SSL certificate
- Restricted CIDR blocks for security

## Security Considerations

⚠️ **Important Security Notes:**

1. **Change default CIDR blocks**: The default allows access from anywhere (0.0.0.0/0). Update `allowed_cidr_blocks` in terraform.tfvars to your specific IP ranges.

2. **Database password**: Automatically generated and stored in AWS Systems Manager Parameter Store at:
   ```
   /${project_name}/${environment}/docdb/password
   ```

3. **TLS/SSL**: DocumentDB has TLS enabled. Consider adding SSL certificates for custom domains.

## Cost Optimization

This setup is designed for cost efficiency:
- **Fargate**: Pay only for running time
- **DocumentDB t3.medium**: Burstable performance for development
- **S3**: Pay per use
- **CloudFront**: Free tier available
- **VPC Endpoints**: Reduce NAT Gateway costs

Estimated monthly cost for development: ~$50-100 USD (varies by usage)

## Deployment Steps

1. **Backend Application**: Update the ECS task definition with your actual Docker image
2. **Frontend Application**: Build React app and upload to S3 bucket
3. **Database Migration**: Connect to DocumentDB and set up initial data

## Monitoring and Logging

- **CloudWatch Logs**: ECS task logs with 7-day retention
- **Container Insights**: Enabled for ECS cluster monitoring
- **ALB Metrics**: Built-in load balancer monitoring

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

⚠️ **Warning**: This will permanently delete all resources including data in DocumentDB and S3.

## Support

For issues with this infrastructure:
1. Check Terraform state and logs
2. Verify AWS CLI configuration
3. Review CloudWatch logs for application issues
4. Check security group rules for connectivity issues

## Next Steps

After infrastructure deployment:
1. Build and deploy the React frontend to S3
2. Build and push the Node.js backend Docker image
3. Update ECS task definition with the actual image
4. Configure application-specific environment variables
5. Set up monitoring and alerting
6. Configure backup and disaster recovery procedures