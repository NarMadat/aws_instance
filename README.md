# Terraform + AWS Infrastructure with Grafana Integration

## Overview
This project sets up and manages infrastructure on AWS using Terraform. It also integrates with Grafana for monitoring and visualization of infrastructure metrics.

## Prerequisites

Before starting, ensure you have the following tools installed:

1. **Terraform** (>= 1.0)
   - [Installation Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
2. **AWS CLI** (>= 2.0)
   - [Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
   - Configured with appropriate credentials: `aws configure`
3. **Grafana**
   - Installed locally or accessible via a remote server.
   - [Installation Guide](https://grafana.com/docs/grafana/latest/setup-grafana/installation/)

## Architecture

The infrastructure includes the following components:

- **VPC**: A Virtual Private Cloud to isolate resources.
- **EC2 Instances**: Virtual servers for running applications.
- **S3 Buckets**: For storage purposes.
- **RDS**: Relational Database Service for managing databases.
- **CloudWatch**: AWS service for monitoring infrastructure metrics.
- **Grafana**: For visualizing CloudWatch metrics.

## Directory Structure

```
project-directory/
|-- terraform/
|   |-- main.tf         # Core infrastructure definition
|   |-- variables.tf    # Input variables
|   |-- outputs.tf      # Outputs for other modules or external use
|   |-- provider.tf     # AWS provider configuration
|   |-- modules/        # Optional modules for infrastructure
|-- grafana/
    |-- dashboards/     # JSON files for Grafana dashboards
    |-- config/         # Grafana configuration files
```

## Setup Instructions

### 1. Clone the Repository

```bash
git clone <repository-url>
cd project-directory
```

### 2. Configure Terraform

1. Navigate to the `terraform/` directory.
2. Create a `terraform.tfvars` file to store your variable values (example below):

```hcl
aws_region = "us-east-1"
instance_type = "t2.micro"
key_name = "your-key-name"
s3_bucket_name = "your-unique-s3-bucket-name"
db_username = "admin"
db_password = "your-secure-password"
```

3. Initialize Terraform:

```bash
terraform init
```

4. Preview the infrastructure changes:

```bash
terraform plan
```

5. Apply the changes:

```bash
terraform apply
```

### 3. Set Up Grafana

1. Log in to Grafana (default: `http://localhost:3000`).
2. Add AWS CloudWatch as a data source:
   - Go to **Configuration > Data Sources** > Add new data source.
   - Select **CloudWatch**.
   - Enter AWS credentials and region.
3. Import predefined dashboards from the `grafana/dashboards/` folder or create new ones.

### 4. Monitor Your Infrastructure

- Use Grafana dashboards to visualize metrics such as:
  - EC2 instance performance
  - S3 bucket usage
  - RDS metrics

## Clean-Up

To destroy the infrastructure, run:

```bash
terraform destroy
```

## Contributing

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature-branch-name`).
3. Commit your changes (`git commit -m "Feature description"`).
4. Push to the branch (`git push origin feature-branch-name`).
5. Open a pull request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

