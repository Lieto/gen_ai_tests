#!/bin/bash

# Deployment script for HAM Radio Practice Test Application Infrastructure
# Usage: ./deploy.sh [plan|apply|destroy]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if terraform is installed
if ! command -v terraform &> /dev/null; then
    print_error "Terraform is not installed. Please install Terraform first."
    exit 1
fi

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    print_warning "AWS CLI is not installed. You may need it for credentials configuration."
fi

# Set default action
ACTION=${1:-plan}

case $ACTION in
    plan)
        print_status "Planning Terraform deployment..."
        ;;
    apply)
        print_status "Applying Terraform configuration..."
        ;;
    destroy)
        print_warning "Destroying Terraform infrastructure..."
        ;;
    *)
        print_error "Invalid action. Use: plan, apply, or destroy"
        exit 1
        ;;
esac

# Check if terraform.tfvars exists
if [ ! -f "terraform.tfvars" ]; then
    print_warning "terraform.tfvars not found. Copying from example..."
    cp terraform.tfvars.example terraform.tfvars
    print_warning "Please edit terraform.tfvars with your specific values before proceeding."
    exit 1
fi

# Initialize Terraform
print_status "Initializing Terraform..."
terraform init

# Validate configuration
print_status "Validating Terraform configuration..."
terraform validate

# Format check
print_status "Checking Terraform formatting..."
if ! terraform fmt -check; then
    print_status "Formatting Terraform files..."
    terraform fmt
fi

# Execute the specified action
case $ACTION in
    plan)
        print_status "Running Terraform plan..."
        terraform plan
        ;;
    apply)
        print_status "Running Terraform apply..."
        terraform apply
        if [ $? -eq 0 ]; then
            print_status "Deployment completed successfully!"
            print_status "Check the outputs above for important information about your infrastructure."
        fi
        ;;
    destroy)
        print_warning "This will destroy ALL infrastructure resources!"
        read -p "Are you sure you want to continue? (type 'yes' to confirm): " confirm
        if [ "$confirm" = "yes" ]; then
            terraform destroy
            if [ $? -eq 0 ]; then
                print_status "Infrastructure destroyed successfully."
            fi
        else
            print_status "Destroy operation cancelled."
        fi
        ;;
esac

print_status "Script completed."