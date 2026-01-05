# Changelog

## [v0.1.0] – Initial Release

### Added
- AWS VPC creation with configurable CIDR
- Public subnet support with Internet Gateway and routing
- Private subnet support with dedicated route table
- Optional NAT Gateway support
  - Single-AZ (zonal) NAT Gateway
  - Regional NAT Gateway mode
- Elastic IP creation for NAT Gateway
- Route tables and route table associations for all subnets
- Input variable validations for subnet and CIDR list lengths
- Outputs for VPC, subnets, IGW, NAT Gateway, and EIP
