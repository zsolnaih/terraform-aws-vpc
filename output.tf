output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = try(aws_subnet.public[*].id, null) 
}

output "private_subnets" {
  value = try(aws_subnet.private[*].id, null)
}

output "igw" {
  value = try(aws_internet_gateway.this[0].id, null)
}

output "eip" {
  value = try(aws_eip.this, null)
}

output "nat_gw" {
  value = try(aws_nat_gateway.this, null)
}