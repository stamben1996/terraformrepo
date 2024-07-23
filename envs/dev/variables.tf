variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "ami_id" {
  type = string
}

variable "ec2_type" {
  type = string
}

variable "elb_port" {
  type = number
}
