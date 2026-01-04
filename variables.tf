variable "name" {
  type        = string
  default     = "zsolnaih"
}

variable "region" {
  description = "Region where the resource will be managed. Defaults to the region set in the provider configuration"
  type        = string
  default     = null
}

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type = list(string)
  default = []
  validation {
    condition = length(var.public_subnet) != length(var.public_subnet_cidr) ? false : true
    error_message = "Number of public subnet cidr and public subnet count are different"
  }
}

variable "private_subnet_cidr" {
  type = list(string)
  default = []
  validation {
    condition = length(var.private_subnet) != length(var.private_subnet_cidr) ? false : true
    error_message = "Number of private subnet cidr and private subnet count are different"
  }
}

variable "public_subnet" {
  type = list(string)
  default = []
}

variable "private_subnet" {
  type = list(string)
  default = []
}

variable "single_az_nat" {
  type = bool
  default = false
}

variable "nat_gw" {
  type = bool
  default = false
  validation {
    condition = length(var.public_subnet_cidr) < 1 && var.nat_gw ? false : true
    error_message = "Need public subnet for NAT GW"
  }
}