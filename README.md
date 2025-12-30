# Production Ready Threat Composer, Deployed on AWS ECS Fargate  

<img width="1279" height="873" alt="Screenshot 2025-11-09 at 13 47 02" src="https://github.com/user-attachments/assets/44f9e392-8d1d-4aa7-b838-55941477e598" />

## Overview  
This project deploys **Threat-Composer**, an open-source application by **Amazon**, to **AWS** using **Terraform** and **GitHub Actions**.  
It includes full **DNS configuration**, **SSL certificate setup**, and **deployment to a custom domain** — **tm.digitalcncloud.org**.  


This project demonstrates a **modular Terraform architecture**, a **remote backend** for collaborative state management, and an **automated CI/CD pipeline** that builds, scans, and pushes Docker images to **Amazon ECR**.  

---

## 🏗️ Infrastructure Highlights  

- **Modular Terraform Structure**  
  Each AWS component (VPC, ALB, ECS, ACM, Route53, Security Groups) is split into its own module for readability and scalability.  

- **Remote Backend with S3**  
  Terraform state is stored in **Amazon S3**, allowing collaboration within large teams and ensuring a single source of truth for deployments.  

- **State Locking Enabled**  
  **AWS S3-based locking** prevents concurrent changes to infrastructure, protecting against state corruption.  

- **CI/CD Integration**  
  - GitHub Actions automatically builds and scans Docker images using **Trivy**.  
  - Authenticates securely to AWS (via OIDC or encrypted secrets).  
  - Pushes images to **ECR** and triggers Terraform pipelines for updates.  

---

## 🗂️ Directory Structure  
```
ECS-Threat-Composer-App/
├── .github/
│ └── workflows/
│ ├── push-ecr.yml 
│ ├── terraform-plan.yml 
│ ├── terraform-apply.yml 
│ └── terraform-destroy.yml
│
├── app/ 
│ └── Dockerfile
│
├── terraform/ 
│ ├── main.tf
│ ├── provider.tf
│ ├── variables.tf
│ └── modules/
│ ├── vpc/
│ ├── alb/
│ ├── ecs/
│ ├── sg/
│ ├── acm/
│ └── route53/
│
└── README.md
```

## 🛠️ AWS Services Used  

- **VPC (Virtual Private Cloud):** Provides isolated networking for all resources, ensuring security and traffic control.  
- **ALB (Application Load Balancer):** Routes incoming traffic to ECS Fargate services and acts as a reverse proxy.  
- **ECS (Elastic Container Service):** Manages containerised workloads, task definitions, and service scaling.  
- **ECR (Elastic Container Registry):** Stores, versions, and manages Docker images used by ECS.  
- **Security Groups (SG):** Define inbound and outbound firewall rules to control network access.  
- **Route53:** Handles DNS management and routing for the custom domain **tc.threatcomposer.co.uk**.  
- **ACM (AWS Certificate Manager):** Issues and manages SSL/TLS certificates for secure HTTPS communication.  
- **IAM (Identity and Access Management):** Provides fine-grained access control for AWS users, roles, and policies.  
- **Internet Gateway (IG):** Enables internet access for public subnets within the VPC.  
