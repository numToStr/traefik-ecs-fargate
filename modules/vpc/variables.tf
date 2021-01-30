variable "cidr_block" {
  type = string
  description = "CIDR block for the VPC"
}

variable "azs" {
  type = list(string)
  description = "Availability Zones for the current region"

  validation {
    condition = length(var.azs) >= 2
    error_message = "The length of availability zones should be greater or equal to 2."
  }
}

variable "destination_cidr_block" {
  type = string
  default = "0.0.0.0/0"
  description = "CIDR Block for the traffic routing"
}
