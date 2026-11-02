# Day 1 — Terraform Three-Tier Network Security

## Objective

Build a least-privilege network security architecture using
Terraform and an existing AWS VPC.

## Architecture

- Web tier: existing AWS security group.
- Application tier: new Terraform-managed security group.
- Database tier: new Terraform-managed security group.
- No EC2 instance or RDS database deployed.

## Security requirements

- Web tier to application: TCP 8080.
- Application to database: TCP 5432.
- Database inbound: application security group only.
- No public inbound access to the application/database tiers.
- No SSH access.
- No unrestricted application egress.

## Terraform resources

- Two security groups.
- One application ingress rule.
- One application egress rule.
- One database ingress rule.
- One data source reading the existing web security group.

## Security exercise

Introduce an intentionally unsafe source:
0.0.0.0/0 for application TCP 8080.

Review the Terraform plan, verify the risk,
restore the approved security-group reference,
and verify the corrected AWS configuration.

## Cleanup

Destroy only resources created by Day 1.

## Interview concepts

- Infrastructure as Code
- Terraform providers, resources and data sources
- Variables, outputs and state
- Ingress and egress
- Stateful security groups
- Security-group references
- Least privilege
- Configuration drift
