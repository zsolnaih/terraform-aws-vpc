# Terraform AWS VPC Module

This Terraform module provisions an AWS VPC with **public** and **private** subnets and optionally creates a **NAT Gateway** ("zonal" or “regional” mode), including all required route tables and route table associations.

---

## What This Module Creates

- `aws_vpc`
- `aws_subnet` (public and private)
- `aws_internet_gateway` (if public subnets are defined)
- `aws_route_table` and `aws_route_table_association` (public and private)
- `aws_eip` and `aws_nat_gateway` (if `nat_gw = true`)

### Routing Logic

- **Public subnets**: a public route table with `0.0.0.0/0 -> Internet Gateway` (only if public subnets exist).
- **Private subnets with NAT Gateway**: a private route table with `0.0.0.0/0 -> NAT Gateway` (only if private subnets exist **and** `nat_gw = true`).

If private subnets exist but `nat_gw = false`, no default internet route is created for the private route table.

---

## Requirements

- Terraform `>= 1.10.0`
- AWS provider `~> 6.26`

---

## Input Variables

| Name | Type | Default | Description | Required |
|---|---|---|---|---|
| `name` | `string` | `"zsolnaih"` | Name prefix used for resource tags | no |
| `region` | `string` | `null` | AWS region (if `null`, provider region is used) | no |
| `vpc_cidr` | `string` | `"10.0.0.0/16"` | VPC CIDR block | no |
| `public_subnet` | `list(string)` | `[]` | Availability Zones for public subnets (e.g. `eu-central-1a`) | no |
| `public_subnet_cidr` | `list(string)` | `[]` | CIDR blocks for public subnets (must match `public_subnet` length) | no |
| `private_subnet` | `list(string)` | `[]` | Availability Zones for private subnets | no |
| `private_subnet_cidr` | `list(string)` | `[]` | CIDR blocks for private subnets (must match `private_subnet` length) | no |
| `nat_gw` | `bool` | `false` | Whether to create a NAT Gateway | no |
| `single_az_nat` | `bool` | `false` | If `true`, create a zonal NAT Gateway in the first public subnet. If `false`, use “regional” mode | no |

### Validations

- `public_subnet` and `public_subnet_cidr` must have the same number of elements
- `private_subnet` and `private_subnet_cidr` must have the same number of elements
- If `nat_gw = true`, at least one public subnet must be defined

---

## Outputs

| Name | Description |
|---|---|
| `vpc_id` | ID of the created VPC |
| `public_subnets` | List of public subnet IDs |
| `private_subnets` | List of private subnet IDs |
| `igw` | Internet Gateway ID *(only if public subnets exist)* |
| `eip` | Elastic IP resource *(only if `nat_gw = true`)* |
| `nat_gw` | NAT Gateway resource *(only if `nat_gw = true`)* |

---

## Versioning

Semantic Versioning is recommended (e.g. `v0.1.0`).  
Use module versions via Git tags:

```hcl
source = "github.com/zsolnaih/terraform-aws-vpc?ref=v0.1.0"
```
