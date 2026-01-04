output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "igw" {
  value = aws_internet_gateway.this[0].id
}

output "eip" {
  value = aws_eip.this
}

output "nat_gw" {
  value = aws_nat_gateway.this
}