output "id" {
  value = aws_vpc.this.id
  description = "ID of the VPC"
}

output "cidr" {
  value = aws_vpc.this.cidr_block
  description = "CIDR block of the VPC"
}

output "private_subnet_ids" {
  value = aws_subnet.private.*.id
  description = "Private subnets' ids attached to the VPC"
}

output "private_subnet_cidrs" {
  value = aws_subnet.private.*.cidr_block
  description = "Private subnets' cidrs attached to the VPC"
}

output "public_subnet_ids" {
  value = aws_subnet.public.*.id
  description = "Public subnets' cidrs attached to the VPC"
}

output "public_subnet_cidrs" {
  value = aws_subnet.public.*.cidr_block
  description = "Public subnets' cidrs attached to the VPC"
}
