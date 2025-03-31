# OpenShift Cluster on Oracle Cloud Infrastructure (OCI)

This repository contains Terraform configurations to deploy an OpenShift cluster on Oracle Cloud Infrastructure (OCI).

## Prerequisites

- Oracle Cloud Infrastructure account
- Terraform installed (version >= 1.0)
- OCI CLI configured
- SSH key pair for bastion host access

## Architecture

The infrastructure includes:
- VCN with public and private subnets
- Bastion host in public subnet
- Control plane nodes in private subnet
- Compute nodes in private subnet
- Load balancers for API and ingress
- NAT Gateway for outbound internet access
- Service Gateway for OCI services access

## Directory Structure

```
.
├── shared_modules/
│   ├── bastion/         # Bastion host configuration
│   ├── compute/         # Compute nodes configuration
│   ├── dns/            # DNS configuration
│   ├── iam/            # IAM policies and dynamic groups
│   ├── image/          # Custom image configuration
│   ├── lb/             # Load balancer configuration
│   ├── manifest/       # OpenShift manifests
│   ├── meta/           # Availability domain and fault domain configuration
│   ├── network/        # Network configuration
│   └── tags/           # Tag configuration
├── main.tf             # Main Terraform configuration
├── variables.tf        # Input variables
├── outputs.tf         # Output values
└── locals.tf          # Local values
```

## Usage

1. Clone the repository:
```bash
git clone <repository-url>
cd create-cluster-v1.0.0
```

2. Create a `terraform.tfvars` file with your configuration:
```hcl
compartment_ocid = "ocid1.compartment.oc1..xxxxx"
cluster_name     = "my-cluster"
ssh_public_key   = "ssh-rsa AAAA..."
# Add other required variables
```

3. Initialize Terraform:
```bash
terraform init
```

4. Review the plan:
```bash
terraform plan
```

5. Apply the configuration:
```bash
terraform apply
```

## Security

- Bastion host is the only instance with public IP
- Control plane and compute nodes are in private subnets
- SSH access to private instances is only possible through the bastion host
- Security groups and network security groups control traffic flow

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 