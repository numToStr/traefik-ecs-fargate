variable "alb_name" {
  type = string
  description = "Name of the ALB"
}

variable "vpc_id" {
  type = string
  description = "VPC ID"
}

variable "public_subnet_ids" {
  type = list(string)
  description = "Public subnets' id for the load balancer"
}
