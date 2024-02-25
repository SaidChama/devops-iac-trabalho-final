variable "key_name" {
  description = "The name of the key pair to use for the EC2 instances"
  type        = string
  default     = "notebook_key_pair"

}

variable "instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
  default     = "t2.micro"

}