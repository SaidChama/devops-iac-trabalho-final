variable "azs" {
    description = "The availability zones for subnets"
    type        = list(string)
    default     = ["us-east-1a"]
}

variable "private_subnets" {
    description = "The private subnets CIDR blocks"
    type        = list(string)
    default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
    description = "The public subnets CIDR blocks"
    type        = list(string)
    default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}