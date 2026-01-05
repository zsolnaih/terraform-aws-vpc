resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  region = var.region
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = "${var.name}-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  region                  = var.region
  count                   = length(var.public_subnet)
  availability_zone       = var.public_subnet[count.index]
  map_public_ip_on_launch = true
  cidr_block              = var.public_subnet_cidr[count.index]

  tags = {
    Name = "${var.name}-Public-${count.index+1}"
  }

}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.this.id
  region                  = var.region
  count                   = length(var.private_subnet)
  availability_zone       = var.private_subnet[count.index]
  cidr_block              = var.private_subnet_cidr[count.index]

  tags = {
    Name = "${var.name}-Private${count.index+1}"
  }
}

resource "aws_internet_gateway" "this" {
  count  = length(var.public_subnet) > 0 ? 1: 0
  region = var.region
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_route_table" "public_route_table" {
  count  = length(var.public_subnet) > 0 ? 1: 0
  region = var.region
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id     = aws_internet_gateway.this[0].id
  }

  tags = {
    Name = "${var.name}-Public-rt"
  }
}

resource "aws_route_table_association" "public" {
  region         = var.region
  depends_on     = [aws_subnet.public]
  route_table_id = aws_route_table.public_route_table[0].id
  count          = length(var.public_subnet)
  subnet_id      = aws_subnet.public[count.index].id
}

resource "aws_route_table" "private_route_table" {
  count  = length(var.private_subnet) > 0 && var.nat_gw ? 1 : 0
  region = var.region
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[0].id
  }

  tags = {
    Name = "${var.name}-Privte-rt"
  }
}

resource "aws_route_table_association" "private" {
  region         = var.region
  depends_on     = [aws_subnet.private]
  route_table_id = aws_route_table.private_route_table[0].id
  count          = length(var.private_subnet) > 0 && var.nat_gw ? length(var.private_subnet) : 0 
  subnet_id      = aws_subnet.private[count.index].id
}

resource "aws_eip" "this" {
  count   = var.nat_gw && var.single_az_nat ? 1 : 0
  domain  = "vpc"
  region  = var.region

  tags = {
    Name = "${var.name}-eip"
  }
}


resource "aws_nat_gateway" "this" {
  region        = var.region
  count         = var.nat_gw ? 1 : 0
  allocation_id = var.single_az_nat ? aws_eip.this[0].id : null
  subnet_id     = var.single_az_nat ? aws_subnet.public[0].id : null

  vpc_id            = var.single_az_nat ? null : aws_vpc.this.id
  availability_mode = var.single_az_nat ? "zonal" : "regional"
  
  
  depends_on = [aws_internet_gateway.this]

  tags = {
    Name = "${var.name}-nat-gw"
  }
}