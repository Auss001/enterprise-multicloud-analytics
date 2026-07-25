# Cost Analysis

## Overview

The Enterprise Tri-Cloud Analytics Platform was designed to demonstrate enterprise cloud engineering while remaining cost-conscious.

Each cloud provider contributes different services, with different pricing models.

---

# Microsoft Azure

## Services

- Azure Static Web Apps

### Cost

For this project, frontend hosting remains within the selected hosting tier and incurs little or no cost.

---

# Google Cloud Platform

## Services

- BigQuery

### Cost

The project stores a very small number of analytics events.

Storage and query usage remain within Google Cloud's free usage allowances, resulting in no observed charges during development.

---

# Amazon Web Services

AWS hosts the backend infrastructure.

Services include:

- ECS Fargate
- Application Load Balancer
- Amazon ECR
- CloudWatch
- IAM
- Secrets Manager

### Primary Cost Drivers

The main ongoing costs are:

- ECS Fargate compute while tasks are running
- Application Load Balancer hourly usage

Other services generate little or no cost for this project.

---

# Cost Optimization

To minimize costs:

- Scale the ECS service to **0** when demonstrations are not required.
- Scale back to **1** before interviews or presentations.
- Remove unused Docker images from ECR periodically.
- Monitor AWS Billing regularly.

---

# Operational Strategy

The platform is intended to remain fully operational during demonstrations, portfolio reviews, and interviews.

When inactive, compute resources can be scaled down to reduce costs while preserving the deployed infrastructure.

---

# Estimated Cost Summary

| Cloud Provider | Primary Service | Typical Cost During This Project |
|---------------|-----------------|----------------------------------|
| Azure | Static Web Apps | Minimal or none |
| Google Cloud | BigQuery | Within free usage during development |
| AWS | ECS Fargate + ALB | Primary source of ongoing cost |

---

# Conclusion

This project demonstrates that enterprise-style cloud architectures can be developed responsibly by monitoring usage, understanding pricing models, and scaling resources according to demand.

Cost optimization is treated as an architectural consideration alongside security, performance, and maintainability.