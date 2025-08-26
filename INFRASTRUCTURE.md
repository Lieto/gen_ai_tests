# Infrastructure Overview

## What's Been Created

This Terraform configuration creates a complete AWS development environment for the HAM Radio Practice Test Application in the Europe North (eu-north-1) region.

## Files Created

```
terraform/
├── README.md                    # Comprehensive deployment guide
├── deploy.sh                    # Automated deployment script
├── main.tf                      # Main Terraform configuration and providers
├── variables.tf                 # Input variables
├── outputs.tf                   # Output values
├── vpc.tf                      # VPC, subnets, NAT gateways, routing
├── security_groups.tf          # Security groups for all tiers
├── load_balancer.tf           # Application Load Balancer configuration
├── iam.tf                     # IAM roles and policies
├── ecs.tf                     # ECS Fargate cluster and service
├── database.tf                # DocumentDB (MongoDB-compatible) cluster
├── s3_cloudfront.tf          # S3 buckets and CloudFront distribution
├── terraform.tfvars.example  # Example configuration file
└── .gitignore                # Terraform-specific gitignore
```

## Architecture Summary

### Network Layer
- **VPC**: 10.0.0.0/16 with public, private, and database subnets
- **Multi-AZ**: Resources spread across 2 availability zones
- **NAT Gateways**: Secure internet access for private resources
- **VPC Endpoints**: Cost-optimized S3 access

### Security Layer
- **Security Groups**: Least-privilege access between tiers
- **IAM Roles**: Secure service-to-service authentication
- **TLS Encryption**: Enabled for database connections
- **Private Subnets**: Backend services not directly internet-accessible

### Compute Layer
- **ECS Fargate**: Serverless container platform for Node.js backend
- **Application Load Balancer**: High availability and health checking
- **Auto Scaling**: Ready for production scaling

### Data Layer
- **DocumentDB**: MongoDB-compatible database with automatic backups
- **S3 Buckets**: Separate buckets for frontend and uploads
- **CloudFront**: Global CDN for fast content delivery

## Quick Start

1. **Copy configuration file:**
   ```bash
   cd terraform
   cp terraform.tfvars.example terraform.tfvars
   ```

2. **Edit configuration:**
   ```bash
   nano terraform.tfvars
   ```

3. **Deploy infrastructure:**
   ```bash
   ./deploy.sh apply
   ```

## Cost Estimate

Development environment: ~$50-100 USD/month
- ECS Fargate: ~$15-25/month (256 CPU, 512MB RAM)
- DocumentDB: ~$25-40/month (t3.medium instance)
- Load Balancer: ~$18/month
- S3/CloudFront: ~$5-15/month (depends on usage)

## Security Notes

⚠️ **Important**: Update `allowed_cidr_blocks` in terraform.tfvars to restrict access to your IP ranges only.

## Next Steps

After infrastructure deployment:

1. **Build frontend**: Create React app and upload to S3 bucket
2. **Build backend**: Create Docker image for Node.js API
3. **Update ECS task**: Replace placeholder container with actual application
4. **Configure DNS**: Point domain to CloudFront distribution (optional)
5. **Set up monitoring**: Configure CloudWatch alarms and notifications

## Application Integration

The infrastructure is designed to support the HAM Radio Practice Test app architecture:

- **Frontend (React)**: Served from S3 via CloudFront
- **Backend (Node.js/Express)**: Running on ECS Fargate
- **Database (MongoDB)**: DocumentDB cluster
- **API Gateway**: Application Load Balancer handles API routing
- **File Uploads**: Dedicated S3 bucket for question images/attachments

## Monitoring and Operations

- **CloudWatch Logs**: ECS tasks log to CloudWatch
- **Container Insights**: ECS cluster monitoring enabled
- **Health Checks**: ALB monitors backend service health
- **Backups**: DocumentDB automated daily backups

This infrastructure provides a solid foundation for developing and testing the HAM Radio Practice Test application with proper security, scalability, and monitoring in place.