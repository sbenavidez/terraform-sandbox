
variable "server_port" {
  description = "Server port for HTTP requests"
  type        = number
  default     = 8080
}

variable "elb_port" {
  description = "ELB Port for port fowarding"
  type        = number
  default     = 80
}