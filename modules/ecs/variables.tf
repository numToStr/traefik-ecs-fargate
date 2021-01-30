variable "vpc_id" {
  type = string
  description = "VPC ID"
}

variable "cluster_name" {
  type = string
  description = "Cluster id for the service to attach to."
}

variable "private_subnet_ids" {
  type = list(string)
  description = "Private subnets' id for the ecs service"
}

variable "alb_target_group_arn" {
  type = string
  description = "ALB target group for the service"
}

variable "alb_security_group" {
  type = string
  description = "ALB target group for the service"
}

variable "alb_dns" {
  type = string
  description = "DNS of the load balancer"
}
