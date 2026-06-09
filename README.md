# AWS Infrastructure Automation using Terraform

## Project Overview

This project demonstrates the provisioning of a highly available AWS infrastructure using Terraform. The architecture follows Infrastructure as Code (IaC) principles and deploys a production-style environment with multi-AZ networking, Auto Scaling, Application Load Balancer, NAT Gateways, and a Bastion Host.

---

## Architecture

![Architecture Diagram](./diagrams/architecture.png)

### Key Components

- Custom VPC (10.0.0.0/16)
- 2 Public Subnets across multiple Availability Zones
- 2 Private Subnets across multiple Availability Zones
- Internet Gateway
- NAT Gateway in each Availability Zone
- Bastion Host for secure SSH access
- Application Load Balancer (ALB)
- Target Group and Listener Configuration
- Auto Scaling Group (ASG)
- Launch Template
- Security Groups
- Route Tables and Associations

---

## Architecture Flow

Users access the application through the Application Load Balancer.

1. Internet traffic reaches the ALB.
2. ALB forwards requests to the Target Group.
3. Target Group routes traffic to EC2 instances managed by Auto Scaling Group.
4. EC2 instances run inside private subnets.
5. NAT Gateways provide outbound internet access for private instances.
6. Bastion Host allows secure SSH access to private resources.
7. Multi-AZ deployment ensures high availability and fault tolerance.

---

## Technologies Used

| Technology | Purpose |
|------------|----------|
| Terraform | Infrastructure as Code |
| AWS VPC | Networking |
| AWS EC2 | Compute Resources |
| AWS Auto Scaling | High Availability |
| AWS ALB | Load Balancing |
| AWS NAT Gateway | Private Subnet Internet Access |
| AWS Security Groups | Network Security |
| AWS Route Tables | Traffic Routing |

---

## Infrastructure Components

### Networking

- VPC: 10.0.0.0/16
- Public Subnet 1: 10.0.0.0/24 (ap-south-1a)
- Public Subnet 2: 10.0.1.0/24 (ap-south-1b)
- Private Subnet 1: 10.0.2.0/24 (ap-south-1a)
- Private Subnet 2: 10.0.3.0/24 (ap-south-1b)

### Security

- SSH Access (Port 22)
- HTTP Access (Port 80)
- Application Port (8000)

### Compute

- Bastion Host
- Auto Scaling Group
- Launch Template
- EC2 Instances

### Load Balancing

- Application Load Balancer
- HTTP Listener (Port 80)
- Target Group (Port 8000)

---

## Features

✅ Infrastructure as Code (IaC)

✅ Multi-AZ Architecture

✅ High Availability

✅ Auto Scaling

✅ Application Load Balancing

✅ Secure Bastion Host Access

✅ Private Subnet Isolation

✅ Outbound Internet via NAT Gateway

✅ Reproducible Infrastructure Deployment

---

## Deployment Steps

### Clone Repository

```bash
git clone https://github.com/yourusername/aws-infrastructure-terraform.git

cd aws-infrastructure-terraform
```

### Initialize Terraform

```bash
terraform init
```

### Validate Configuration

```bash
terraform validate
```

### Preview Changes

```bash
terraform plan
```

### Deploy Infrastructure

```bash
terraform apply
```

### Destroy Infrastructure

```bash
terraform destroy
```

---

## Project Structure

```text
.
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
├── diagrams
│   └── architecture.png
├── screenshots
│   ├── vpc.png
│   ├── alb.png
│   ├── autoscaling.png
│   └── ec2.png
└── README.md
```

---

## Learning Outcomes

Through this project, I gained hands-on experience with:

- Terraform Infrastructure as Code
- AWS Networking Concepts
- VPC Design
- Route Tables and Internet Routing
- NAT Gateways
- Security Groups
- Application Load Balancers
- Auto Scaling Groups
- High Availability Architecture
- Production-ready AWS Infrastructure Design

---

## Future Improvements

- Terraform Modules
- Remote State Management using S3
- DynamoDB State Locking
- GitHub Actions CI/CD
- CloudWatch Monitoring
- HTTPS using ACM Certificate
- Route53 DNS Integration

---

## Author

**Avinash Shetty**

DevOps | Cloud | AWS | Terraform | Kubernetes

